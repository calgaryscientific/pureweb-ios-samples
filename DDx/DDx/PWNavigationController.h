//
//  PWNavigationController.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

///
/// The NavigationViewController protocol should be adopted by view controllers that want to be
/// notified when they are pushed on or popped off a navigation controller.
///
@protocol PWNavigationControllerDelegate

@optional

///
/// This method is invoked when a view controller is pushed. The receiver will receive this message
/// after -viewWillAppear: and before -viewDidAppear:.
///
- (void)viewWasPushed;

///
/// This method is invoked when a view controller is popped. The receiver will receive this message
/// after -viewWillDisappear: and before -viewDidDisappear: (if the view was visible).
///
- (void)viewWasPopped;

@end

///
/// NavigationController extends the standard UINavigationController by:
/// 
/// - providing a mechanism for view controllers to be notified when they are pushed on or popped
/// off the navigation stack. UIViewControllers that want these notifications must conform to the
/// NavigationViewController protocol.
/// 
/// - automatically dismissing any modal view controller of the top-most view controller when it is
/// popped. (With UINavigationController, if a view controller is popped while a modal view
/// controller is displayed, the modal view controller remains on the screen.)
///
@interface PWNavigationController : UINavigationController

@end
