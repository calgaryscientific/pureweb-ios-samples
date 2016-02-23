//
//  AsteroidsViewController.swift
//  Asteroids
//
//  Created by Jonathan Neitz on 2016-02-12.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

import UIKit
import PureWeb
import MessageUI

enum KeyCode : Int {
    case Left = 37
    case Right = 39
    case Up = 38
    case Down = 40
    case Space = 32
    case KeyCodeS = 83
};


class AsteroidsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var asteroidsView : PWView!
    
    @IBOutlet weak var fireBlurView: UIVisualEffectView!
    
    @IBOutlet weak var actionBlurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        asteroidsView.framework = PWFramework.sharedInstance();
        asteroidsView.viewName = "AsteroidsView"
        asteroidsView.multipleTouchEnabled = true
        asteroidsView.delegate = DiagnosticViewDelegate.sharedInstance
        
        fireBlurView.layer.cornerRadius = 10.0
        actionBlurView.layer.cornerRadius = actionBlurView.bounds.width/2
        
    }

    @IBAction func fireBegan(sender: AnyObject) {
        queueKeyPress("KeyDown", keycode: .Space, modifiers: 0)
    }
   
    @IBAction func fireEnd(sender: AnyObject) {
        queueKeyPress("KeyUp", keycode: .Space, modifiers: 0)
    }

    @IBAction func shieldBegan(sender: AnyObject) {
        queueKeyPress("KeyDown", keycode: .KeyCodeS, modifiers: 0)
    }
    
    @IBAction func shieldEnd(sender: AnyObject) {
        queueKeyPress("KeyUp", keycode: .KeyCodeS, modifiers: 0)
    }
    
    func queueKeyPress(eventType: String, keycode: KeyCode, modifiers: Int)
    {
        let cmdParams = [ "EventType" : eventType, "Path" : "AsteroidsView", "KeyCode" : "\(keycode.rawValue)", "Modifiers" : "\(modifiers)" ]
        
        PWFramework.sharedInstance().client().queueCommand("InputEvent", withParameters:cmdParams);
    }
    
    // MARK: - Share action
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        
        PWFramework.sharedInstance().client().getSessionShareUrlAsyncWithPassword("Scientific", shareDescriptor: "", shareTimeout: 1800000, completion: { (shareUrl: NSURL!, error: NSError!) in
            
            if(error != nil) {
                
                let alert = UIAlertController(title: "There was an error creating the application share", message : error.description, preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(okAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            self.presentMailComposeWithUrl(shareUrl)
        })
    }
   
    func presentMailComposeWithUrl(shareUrl: NSURL) {
        let mailer = MFMailComposeViewController()
        
        mailer.navigationBar.tintColor = UIColor.darkGrayColor()
        mailer.mailComposeDelegate = self
        mailer.setSubject("Please join my shared PureWeb session")
        mailer.setMessageBody(shareUrl.absoluteString, isHTML: false)
        mailer.modalPresentationStyle = .FormSheet
        
        presentViewController(mailer, animated: true, completion: nil);
        
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
}
