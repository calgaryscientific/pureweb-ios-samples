#import "AsteroidsViewController.h"

#import "FXBlurView.h"

#import <PureWeb/PureWeb.h>
#import <PureWeb/PWUtility.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

#import "DiagnosticViewDelegate.h"

enum KeyCode
{
    KeyCodeLeft = 37,
    KeyCodeRight = 39,
    KeyCodeUp = 38,
    KeyCodeDown = 40,
    KeyCodeSpace = 32,
    KeyCodeS = 83,
};


@interface AsteroidsViewController ()<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet PWView *asteroidsView;
@property (weak, nonatomic) IBOutlet FXBlurView *directionContainingView;
@property (weak, nonatomic) IBOutlet FXBlurView *actionContainingView;


@end

@implementation AsteroidsViewController

- (void)viewDidLoad
{
    //setup the pureweb view (i.e. the asteroids view)
    self.asteroidsView.framework = [PWFramework sharedInstance];
    self.asteroidsView.viewName = @"AsteroidsView";
    self.asteroidsView.multipleTouchEnabled = YES;
    self.asteroidsView.delegate = [DiagnosticViewDelegate sharedInstance];
    
    //create blurred views
    [self setupBlurView:self.directionContainingView];
    [self setupBlurView:self.actionContainingView];
    
    [[self.actionContainingView layer] setCornerRadius:10.0f];
    [[self.directionContainingView layer] setCornerRadius:(self.directionContainingView.frame.size.width/2)];
    
    [super viewDidLoad];
}


- (void) setupBlurView: (FXBlurView *) blurView {
    
    blurView.blurEnabled = YES;
    blurView.dynamic = NO;
    blurView.tintColor = [UIColor whiteColor];
    
    [[blurView layer] setMasksToBounds:YES];
    
}
#pragma mark Sharing
- (IBAction)shareButtonPressed:(UIBarButtonItem *)sender {
    
    [[PWFramework sharedInstance].client getSessionShareUrlAsyncWithPassword:@"Scientific"
                                                             shareDescriptor:@""
                                                                shareTimeout:1800000
     completion:^(NSURL *shareURL, NSError *error) {
         
         if (error) {
             PWLogError(@"share url failed with error %@", error);
             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"There was an error while creating the application share."
                                                                 message:[error description]
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
             [alertView show];
             
             return;
         }
         
         [self presentMailComposeWithURL:shareURL];
     }];
    
}

- (void) presentMailComposeWithURL: (NSURL *) shareURL {
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    if (mailController != nil)
    {
        mailController.navigationBar.tintColor = [UIColor darkGrayColor];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:@"Please join my shared PureWeb session."];
        [mailController setMessageBody:[shareURL absoluteString] isHTML:NO];
        mailController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:mailController animated:YES completion:nil];
    }
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark Actions Buttons
- (IBAction)fireBegan:(UIButton *)sender {
    
    [self queueKeyPress:@"KeyDown" keycode:KeyCodeSpace modifiers:0];
}
- (IBAction)fireEnded:(UIButton *)sender {
    
    [self queueKeyPress:@"KeyUp" keycode:KeyCodeSpace modifiers:0];
}

- (IBAction)shieldBegan:(UIButton *)sender {
    
    [self queueKeyPress:@"KeyDown" keycode:KeyCodeS modifiers:0];
}
- (IBAction)shieldEnded:(UIButton *)sender {
    
    [self queueKeyPress:@"KeyUp" keycode:KeyCodeS modifiers:0];

}

- (void)queueKeyPress:(NSString *)eventType keycode:(long)keycode modifiers:(long)modifiers
{
    NSDictionary *cmdParams = [NSDictionary dictionaryWithObjectsAndKeys:
                               eventType, @"EventType",
                               @"AsteroidsView", @"Path",
                               [NSString stringWithFormat:@"%ld", keycode], @"KeyCode",
                               [NSString stringWithFormat:@"%ld", modifiers], @"Modifiers",
                               nil];
    
    [[PWFramework sharedInstance].client queueCommand:@"InputEvent" withParameters:cmdParams];
}

#pragma mark Landscape Only
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate{
    return YES;
}


@end
