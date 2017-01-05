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
    case left = 37
    case right = 39
    case up = 38
    case down = 40
    case space = 32
    case keyCodeS = 83
};


class AsteroidsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var asteroidsView : PWView!
    
    @IBOutlet weak var fireBlurView: UIVisualEffectView!
    
    @IBOutlet weak var actionBlurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        asteroidsView.framework = PWFramework.sharedInstance();
        asteroidsView.viewName = "AsteroidsView"
        asteroidsView.isMultipleTouchEnabled = true
        asteroidsView.delegate = DiagnosticViewDelegate.sharedInstance
        
        fireBlurView.layer.cornerRadius = 10.0
        actionBlurView.layer.cornerRadius = actionBlurView.bounds.width/2
        
    }

    @IBAction func fireBegan(_ sender: AnyObject) {
        queueKeyPress("KeyDown", keycode: .space, modifiers: 0)
    }
   
    @IBAction func fireEnd(_ sender: AnyObject) {
        queueKeyPress("KeyUp", keycode: .space, modifiers: 0)
    }

    @IBAction func shieldBegan(_ sender: AnyObject) {
        queueKeyPress("KeyDown", keycode: .keyCodeS, modifiers: 0)
    }
    
    @IBAction func shieldEnd(_ sender: AnyObject) {
        queueKeyPress("KeyUp", keycode: .keyCodeS, modifiers: 0)
    }
    
    func queueKeyPress(_ eventType: String, keycode: KeyCode, modifiers: Int)
    {
        let cmdParams = [ "EventType" : eventType, "Path" : "AsteroidsView", "KeyCode" : "\(keycode.rawValue)", "Modifiers" : "\(modifiers)" ]
        
        PWFramework.sharedInstance().client().queueCommand("InputEvent", withParameters:cmdParams);
    }
    
    // MARK: - Share action
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        
        PWFramework.sharedInstance().client().getSessionShareUrlAsync(withPassword: "Scientific", shareDescriptor: "", shareTimeout: 1800000, completion: { (shareUrl, error) in
            
            if(error != nil) {
                
                let alert = UIAlertController(title: "There was an error creating the application share", message : error?.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.presentMailComposeWithUrl(shareUrl!)
        })
    }
   
    func presentMailComposeWithUrl(_ shareUrl: URL) {
        let mailer = MFMailComposeViewController()
        
        mailer.navigationBar.tintColor = UIColor.darkGray
        mailer.mailComposeDelegate = self
        mailer.setSubject("Please join my shared PureWeb session")
        mailer.setMessageBody(shareUrl.absoluteString, isHTML: false)
        mailer.modalPresentationStyle = .formSheet
        
        present(mailer, animated: true, completion: nil);
        
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
}
