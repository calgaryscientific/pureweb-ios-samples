//
//  PGViewController.m
//  DDxSample
//
//  Created by Chris Garrett on 4/11/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PGViewController.h"
#import <PureWeb/PureWeb.h>
#import "DDxView.h"
#import "PWTouchButtonView.h"
#import "PWLog.h"
#import "DiagnosticViewDelegate.h"

@interface PGViewController ()
@property (nonatomic, readonly, strong) PWMutableEncoderConfiguration *encoderConfiguration;
@end

@implementation PGViewController

#pragma mark - UIViewController
#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    UIView *v = [UIView new];
    self.view = v;

    _pgView = [[DDxView alloc] initWithFramework:[PWFramework sharedInstance] frame:CGRectZero];
    _pgView.viewName = @"PGView";
    _pgView.showImageDetails = YES;
    [_pgView updateLabel:nil];
    _pgView.delegate = [DiagnosticViewDelegate sharedInstance];
    
    [[DiagnosticViewDelegate sharedInstance].encoderConfiguration.changed addSubscriber:self action:@selector(encoderConfigurationDidChange:)];
    
    [self.view addSubview:_pgView];

    _touchButton = [[PWTouchButtonView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _touchButton.hidden = NO;
    [_pgView addSubview:_touchButton];
    
    [self encoderConfigurationDidChange:nil]; 
    
}

- (void) viewDidLayoutSubviews {
    
    [self resize];
    
}
- (void) resize {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect screenRect = [PWUtility screenRect:orientation];
    CGFloat navBarOffset = [PWUtility navigationbarHeight:orientation];
    CGFloat tabBarOffset = [PWUtility tabbarHeight];
    CGFloat statusBarOffset = [PWUtility statusbarHeight];
    CGFloat totalOffset = navBarOffset + statusBarOffset;
    
    CGRect pgViewRect = CGRectMake(0, totalOffset, screenRect.size.width, (screenRect.size.height - tabBarOffset));
    _pgView.frame = pgViewRect;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [_pgView addGestureRecognizer:pan];
    
    [[PWFramework sharedInstance].state.stateManager addChildChangedHandler:@"/DDx/PGView/MouseEvent" 
                                                                     target:_pgView
                                                                     action:@selector(updateLabel:)];
    [_pgView.viewUpdated addSubscriber:self action:@selector(viewWasUpdated:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_pgView.viewUpdated removeSubscribersForTarget:self];
    [[PWFramework sharedInstance].state.stateManager removeAllChildChangedHandlersForTarget:self];
}

- (void)viewWasPopped
{
    [_pgView detachView];
}

#ifdef __IPHONE_6_0

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)updateTouchButton:(CGPoint)point
{
    _touchButton.frame = CGRectMake(point.x-_touchButton.frame.size.width/2.0, 
                                    point.y-_touchButton.frame.size.height/2.0, 
                                    _touchButton.frame.size.width, 
                                    _touchButton.frame.size.height);
}

#pragma mark - Private methods
#pragma mark -

- (void)panGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint p = [gesture locationInView:gesture.view];
    
    [self updateTouchButton:p];
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            [_pgView mouseEnter:p];
            break;
        case UIGestureRecognizerStateChanged:
            [_pgView mouseMove:p];
            break;
        case UIGestureRecognizerStateEnded:
            [_pgView mouseLeave];
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateFailed:
            break;
    }
}

- (BOOL)getValue:(NSString *)path
{
    NSString *valueString = [[PWFramework sharedInstance].state.stateManager getValue:path];
    BOOL valueBool = [valueString boolValue];
    return valueBool;
    //return [[[PWFramework sharedInstance].state.stateManager getValue:path] boolValue];
}

- (void)updateValue:(NSString *)path enabled:(BOOL)enabled
{
    [[PWFramework sharedInstance].state.stateManager setAppStatePathWithValue:path 
                                                                        value:enabled?@"True":@"False"];
}

- (void)tripleSwipeGesture:(UISwipeGestureRecognizer *)gesture
{
    [self didRequestOptionsPanel];
}

- (void)viewWasUpdated:(PWViewUpdatedEventArgs *)args
{
    [_pgView updateLabel:nil];
}

#pragma mark PGSettingsViewControllerDelegate
#pragma mark -

- (void)doneWasPushed;
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)asyncImageGenerationDidChange:(BOOL)enabled
{
    [self updateValue:@"/DDx/AsyncImageGeneration" enabled:enabled];
}

- (void)useDeferredRenderingDidChange:(BOOL)enabled
{
    [self updateValue:@"/DDx/UseDeferredRendering" enabled:enabled];
}

- (void)useClientSizeDidChange:(BOOL)enabled
{
    [self updateValue:@"/DDx/UseClientSize" enabled:enabled];
}

- (void)useTilesDidChange:(BOOL)enabled
{
    [self updateValue:@"/DDx/UseTiles" enabled:enabled];
}

- (void)showMousePositionDidChange:(BOOL)enabled
{
    [self updateValue:@"/DDx/ShowMousePos" enabled:enabled];
}

- (void)screenshotButtonTouchUpInside
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[PWFramework sharedInstance].client queueCommand:@"Screenshot" onComplete:^(PWCommandResponseEventArgs *args) 
        { 
            PWGuid *resourceId = [[args.response elementForName:@"ResourceKey"] getTextAsWithDefault:@encode(PWGuid) defaultValue:[PWGuid emptyGuid]];
            [self dismissViewControllerAnimated:YES completion:^(void)
                {
                    UIViewController *controller = [[UIViewController alloc] init];
                    UIImageView *view = [[UIImageView alloc] init];
                    controller.view = view;
                    
                    [[PWFramework sharedInstance].client retrieveObject:resourceId onComplete:^(PWBinaryObject *screenShot, NSError *error)
                     {
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

                        if(!error)
                        {
                            [view setImage:[UIImage imageWithData:screenShot.object]];
                            
                            [self.navigationController pushViewController:controller animated:YES];
                        }
                     }];
                }];
        }];
}

- (PWMutableEncoderConfiguration *)encoderConfiguration
{
    PWMutableEncoderConfiguration *encoderConfiguration = [DiagnosticViewDelegate sharedInstance].encoderConfiguration;
    return encoderConfiguration;
}

- (void)mimeTypeDidChange:(NSString *)mimeType
{
    self.encoderConfiguration.interactiveQuality.mimeType = mimeType;
    self.encoderConfiguration.fullQuality.mimeType = mimeType;
}

- (void)encoderConfigurationDidChange:(NSObject *)object
{
    [_pgView updateEncoderConfiguration];
}

#pragma mark OptionsPanelDelegate
#pragma mark -

- (void)didRequestOptionsPanel
{
    PGSettingsViewController *settings = [[PGSettingsViewController alloc] init];
    settings.delegate = self;
    settings.asyncImageGeneration.on = [self getValue:@"/DDx/AsyncImageGeneration"];
    settings.useDeferredRendering.on = [self getValue:@"/DDx/UseDeferredRendering"];
    settings.useClientSize.on = [self getValue:@"/DDx/UseClientSize"];
    settings.showMousePosition.on = [self getValue:@"/DDx/ShowMousePos"];
    [settings.screenshotButton setEnabled:YES];
    settings.selectedMimeType = self.encoderConfiguration.interactiveQuality.mimeType;
    
    UINavigationController *settingsNav = [[UINavigationController alloc] initWithRootViewController:settings];
    settingsNav.modalPresentationStyle = UIModalPresentationFormSheet;
    settingsNav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:settingsNav animated:YES completion: nil];
}

@end
