//
//  DDxViewController.m
//  DDxSample
//
//  Created by Chris Garrett on 4/11/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import "DDxViewController.h"
#import <PureWeb/PureWeb.h>
#import <QuartzCore/QuartzCore.h>
#import "DDxView.h"
#import "PWDiagnosticViewDelegate.h"

static int const kMaxDDxViews = 4;

@interface DDxViewController ()

- (void)panGesture:(UIPanGestureRecognizer *)gesture;
- (void)stateInitialized;

@end

@implementation DDxViewController

#pragma mark -
#pragma mark UIViewController

@synthesize framework = _framework;
@synthesize toolset = _toolset;

- (PWFramework*)framework
{
    return _framework != nil ? _framework : [PWFramework sharedInstance];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSAssert(_framework, @"framework property has not been set on DDxViewController, can't continue");
    


    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:pan];
    
    [self loadAcetateTools];
    
    _lastViewInput = nil;
    _ddxViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < kMaxDDxViews; i++)
    {
        DDxView *view = [[DDxView alloc] initWithFramework:[PWFramework sharedInstance] frame:CGRectZero];
        view.delegate = [PWDiagnosticViewDelegate sharedInstance];
        view.viewName = [NSString stringWithFormat:@"/DDx/View%d",i];

        [view updateLabel:nil];

        [[PWFramework sharedInstance].state.stateManager addChildChangedHandler:[NSString stringWithFormat:@"/DDx/DDx/View%d/MouseEvent",i] 
                                                                         target:view 
                                                                         action:@selector(updateLabel:)];

        [_ddxViews addObject:view];
        [self.view addSubview:view];
        view.acetateToolset = self.toolset;
    }    

    [[PWFramework sharedInstance].isStateInitializedChanged addSubscriber:self action:@selector(stateInitialized)];
    
    [[PWDiagnosticViewDelegate sharedInstance].encoderConfiguration.changed addSubscriber:self action:@selector(encoderConfigurationDidChange:)];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [[PWFramework sharedInstance].isStateInitializedChanged removeSubscribersForTarget:self];
    [[PWFramework sharedInstance].state.stateManager removeAllChildChangedHandlersForTarget:self];
    [[PWFramework sharedInstance].state.stateManager removeAllValueChangedHandlersForTarget:self];
    
    _ddxViews = nil;    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addObserver:self forKeyPath:@"frame" options:0 context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view removeObserver:self forKeyPath:@"frame"];
}

- (void)viewWasPopped
{
    for (int i = 0; i < kMaxDDxViews; i++)
        [((PWView *)[_ddxViews objectAtIndex:i]) detachView];
}

#ifdef __IPHONE_6_0

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark Private

- (void)loadAcetateTools
{
    self.toolset = [[PWAcetateToolset alloc] init];
    
    PWCursorPositionTool *cursorPositionTool = [[PWCursorPositionTool alloc] init];
    [self.toolset registerTool:cursorPositionTool];
    
    PWPolylineTool *polylineTool = [[PWPolylineTool alloc] init];
    [self.toolset registerTool:polylineTool];
    
    PWClearMarkupTool *clearMarkupTool = [[PWClearMarkupTool alloc] init];
    [self.toolset registerTool:clearMarkupTool];
    
    self.toolset.defaultTool = cursorPositionTool;
    [self.toolset activateTool:polylineTool];
    [self.toolset activateTool:cursorPositionTool];
}

- (void)resize
{
    //size the ddx view based on four distinct views
    CGRect visible = self.view.frame;
    CGFloat rowWidth = visible.size.width/2.0;
    
    //calculate various offsets
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat navBarOffset = [PWUtility navigationbarHeight:orientation];
    CGFloat tabBarOffset = [PWUtility tabbarHeight];
    CGFloat statusBarOffset = [PWUtility statusbarHeight]; 
    CGFloat totalOffset = navBarOffset + statusBarOffset;
    
    CGFloat rowHeight = (visible.size.height - (navBarOffset + tabBarOffset + statusBarOffset))/2.0;
    
    ((DDxView *)[_ddxViews objectAtIndex:0]).frame = CGRectMake(0, totalOffset, rowWidth, rowHeight);
    ((DDxView *)[_ddxViews objectAtIndex:1]).frame = CGRectMake(rowWidth, totalOffset, rowWidth, rowHeight);
    ((DDxView *)[_ddxViews objectAtIndex:2]).frame = CGRectMake(0, (totalOffset + rowHeight), rowWidth, rowHeight);
    ((DDxView *)[_ddxViews objectAtIndex:3]).frame = CGRectMake(rowWidth, (totalOffset + rowHeight), rowWidth, rowHeight);
}

- (DDxView *)viewForPosition:(CGPoint)point
{
    for (int i = 0; i < _ddxViews.count; i++)
    {
        DDxView *view = (DDxView *)[_ddxViews objectAtIndex:i];
        if (CGRectContainsPoint(view.frame, point))
            return view;
    }
    return nil;
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint p = [gesture locationInView:gesture.view];

    if (_lastViewInput == nil)
    {
        _lastViewInput = [self viewForPosition:p];
        if (!_lastViewInput)
        {
            PWLogError(@"unable to determine view!!");
            return;
        }
    }        
    
    p = [self.view convertPoint:p toView:_lastViewInput];
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            [_lastViewInput mouseEnter:p];
            break;
        case UIGestureRecognizerStateChanged:
            [_lastViewInput mouseMove:p];
            break;
        case UIGestureRecognizerStateEnded:
            [_lastViewInput mouseLeave];
            _lastViewInput = nil;
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateFailed:
            break;
    }
}

- (void)stateInitialized
{
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.view && [keyPath isEqualToString:@"frame"]) 
    {
        [self resize];
    }
}

- (void)tripleSwipeGesture:(UISwipeGestureRecognizer *)gesture
{
    [self didRequestOptionsPanel];
}

- (void)encoderConfigurationDidChange:(NSObject *)object
{
    for(DDxView *ddxView in _ddxViews)
    {
        [ddxView updateEncoderConfiguration];
    }
}

#pragma mark -
#pragma mark DDxSettingsViewControllerDelgate

- (void)gridSizeDidChange:(CGFloat)size
{
    [[PWFramework sharedInstance].state.stateManager setAppStatePathWithValue:@"/DDx/Grid/LineSpacing" value:[NSString stringWithFormat:@"%.0f",size]];
}

- (void)gridEnabledDidChange:(BOOL)enabled
{
    [[PWFramework sharedInstance].state.stateManager setAppStatePathWithValue:@"/DDx/Grid/On" value:enabled?@"True":@"False"];
}

- (void)inputTransmissionDidChange:(BOOL)enabled
{
    for(DDxView *view in _ddxViews)
    {
        view.inputTransmissionEnabled = enabled;
    }
}

- (void)clearWasPushed
{
    [[PWFramework sharedInstance].collaborationManager removeAcetateMarkup:@"/DDx/View0"];
    [[PWFramework sharedInstance].collaborationManager removeAcetateMarkup:@"/DDx/View1"];
    [[PWFramework sharedInstance].collaborationManager removeAcetateMarkup:@"/DDx/View2"];
    [[PWFramework sharedInstance].collaborationManager removeAcetateMarkup:@"/DDx/View3"];    
}

- (void)doneWasPushed
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark OptionsPanelDelegate

- (void)didRequestOptionsPanel
{
    // TODO: Add guard so that modal dialog cannot be opened twice
    
    DDxSettingsViewController *settings = [[DDxSettingsViewController alloc] init];
    settings.delegate = self;
    settings.enabled.on = YES;
    settings.gridSize.value = 100;
    NSString *gridOnState = [[PWFramework sharedInstance].state.stateManager getValue:@"/DDx/Grid/On"];
    if(gridOnState) settings.enabled.on = [gridOnState boolValue];
    
    NSString *gridLineSpacingState = [[PWFramework sharedInstance].state.stateManager getValue:@"/DDx/Grid/LineSpacing"];
    if(gridOnState) settings.gridSize.value = [gridLineSpacingState floatValue];
    
    DDxView *ddxView0 = (DDxView *)[_ddxViews objectAtIndex:0];
    settings.inputTransmission.on = ddxView0.inputTransmissionEnabled;
    
    UINavigationController *settingsNav = [[UINavigationController alloc] initWithRootViewController:settings];
    settingsNav.modalPresentationStyle = UIModalPresentationFormSheet;
    settingsNav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:settingsNav animated:YES completion: nil];
}

@end
