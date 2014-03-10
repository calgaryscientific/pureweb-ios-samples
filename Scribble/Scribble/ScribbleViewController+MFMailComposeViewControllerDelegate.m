#import "ScribbleViewController+MFMailComposeViewControllerDelegate.h"

@implementation ScribbleViewController (MFMailComposeViewControllerDelegate)

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}


@end
