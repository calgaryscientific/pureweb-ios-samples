#import "ScribbleViewController.h"

#import <MessageUI/MessageUI.h>
#import <PureWeb/PureWeb.h>
#import <PureWeb/PWLog.h>

#import "ScribbleViewController+MFMailComposeViewControllerDelegate.h"
#import "DiagnosticViewDelegate.h"
#import "Scribble-Swift.h"

@interface ScribbleViewController ()

@property (strong, nonatomic) IBOutlet PWView *scribbleView;
@property (strong, nonatomic) ColorViewController *colorPanel;


@end

@implementation ScribbleViewController

- (void)viewDidLoad
{
    //cache the color panel which is embedded into the scribble page
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[ColorViewController class]]) {
            self.colorPanel = (ColorViewController *) obj;
        }
    }];
    
    
    //detect pan gestures on the scribble view, translate these gestures into PW mouse events
    UIPanGestureRecognizer *oneFingerPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scribbleDrawGesture:)];
    oneFingerPanGestureRecognizer.maximumNumberOfTouches = 1;
    [self.scribbleView addGestureRecognizer:oneFingerPanGestureRecognizer];
    
    //detect a double tap to support 'clear'
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2; //double tap
    [self.scribbleView addGestureRecognizer:doubleTapGestureRecognizer];
    
    //connect the pureweb view, this is done just by setting the name propery on the view
    self.scribbleView.framework = [PWFramework sharedInstance];
    self.scribbleView.viewName = @"ScribbleView";
    self.scribbleView.delegate = [DiagnosticViewDelegate sharedInstance];
    
    [super viewDidLoad];
}


#pragma mark Button Pressed Methods
- (IBAction)colorButtonPressed:(UIBarButtonItem *)sender
{
    [self.colorPanel selectTray];
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
     completion:^(NSURL *shareURL, NSError *error) {
         
         if (error) {
             PWLogError(@"share url created failed with error %@", error);
             return;
         }
         
         [self presentMailComposerWithShareURL:shareURL];
     }];
    
}


- (void) presentMailComposerWithShareURL:(NSURL *) shareURL {
    
    MFMailComposeViewController *mailController = [MFMailComposeViewController new];
    
    mailController.mailComposeDelegate = self;
    [mailController setSubject:@"Join My Shared PureWeb Session."];
    [mailController setMessageBody:[shareURL absoluteString] isHTML:NO];
    
    mailController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:mailController animated:YES completion:nil];

    
}

#pragma mark Gesture  Methods
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
- (void)doubleTapGesture:(UIPanGestureRecognizer *)gesture
{
    
    [self.scribbleView.framework.client queueCommand:@"Clear"];
    
}

@end
