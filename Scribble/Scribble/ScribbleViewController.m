#import "ScribbleViewController.h"

#import <MessageUI/MessageUI.h>
#import <PureWeb/PureWeb.h>
#import <PureWeb/PWLog.h>

#import "ColorSelectionViewController.h"
#import "ScribbleViewController+MFMailComposeViewControllerDelegate.h"
#import "DiagnosticViewDelegate.h"

@interface ScribbleViewController ()

@property (strong, nonatomic) IBOutlet PWView *scribbleView;
@property (strong, nonatomic) ColorSelectionViewController *colorPanel;


@end

@implementation ScribbleViewController

- (void)viewDidLoad
{
    //cache the color panel which is embedded into the scribble page
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[ColorSelectionViewController class]]) {
            self.colorPanel = (ColorSelectionViewController *) obj;
        }
    }];
    
    
    //detect pan gestures on the scribble view, translate these gestures into PW mouse events
    UIPanGestureRecognizer *oneFingerPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scribbleDrawGesture:)];
    oneFingerPanGestureRecognizer.maximumNumberOfTouches = 1;
    [self.scribbleView addGestureRecognizer:oneFingerPanGestureRecognizer];
    
    //connect the pureweb view, this is done just by setting the name propery on the view
    self.scribbleView.framework = [PWFramework sharedInstance];
    self.scribbleView.viewName = @"ScribbleView";
    self.scribbleView.delegate = [DiagnosticViewDelegate sharedInstance];
}


#pragma mark Button & Gesture Methods
- (IBAction)colorButtonPressed:(UIBarButtonItem *)sender
{
    [self.colorPanel traySelected];
    PWLogInfo(@"Color Button Pressed");
}

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender
{
    [self.scribbleView.framework.client queueCommand:@"Clear"];
    PWLogInfo(@"Clear Button Pressed");
}

- (IBAction)shareButtonPressed:(UIBarButtonItem *)sender {
    
    //request a share url from the server
    [[PWFramework sharedInstance].client getSessionShareUrlAsyncWithPassword:@"Scientific"
                                                             shareDescriptor:@""
                                                                shareTimeout:1800000
                                                                      target:self
                                                                      action:@selector(sessionShareRequestFinished:)];
}
- (void)sessionShareRequestFinished:(PWServiceRequestCompletedEventArgs *)args
{
    if (args.request.status == PWServiceRequestStatusSuccess) {
        
        PWAppShare *appShare = (PWAppShare *)args.request;
        
        MFMailComposeViewController *mailController = [MFMailComposeViewController new];

        mailController.mailComposeDelegate = self;
        [mailController setSubject:@"Join My Shared PureWeb Session."];
        [mailController setMessageBody:[appShare shareUrl] isHTML:NO];
        
        mailController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:mailController animated:YES completion:^{
            
            
        }];
    }
    
    else {
        
        PWLogError(@"Service Request Failed");
        
    }
}

- (void)scribbleDrawGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            [self.scribbleView queueMouseDown:1 modifiers:0 x:point.x y:point.y];
            break;
        case UIGestureRecognizerStateChanged:
            [self.scribbleView queueMouseMove:1 modifiers:0 x:point.x y:point.y];
            break;
        case UIGestureRecognizerStateEnded:
            [self.scribbleView queueMouseUp:1 modifiers:0 x:point.x y:point.y];
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateFailed:
            break;
    }
}


@end
