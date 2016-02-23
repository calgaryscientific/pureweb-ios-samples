//
//  LoginViewController.swift
//  Asteroids
//
//  Created by Jonathan Neitz on 2016-02-10.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

import UIKit
import PureWeb

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    
    var processLoginCredentials : ((String,String)->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.delegate = self
        passwordField.delegate = self

        loadCredentials()
    }
    
    func loadCredentials() {
        usernameField.text = NSUserDefaults.standardUserDefaults().stringForKey("pureweb_username")
        passwordField.text = NSUserDefaults.standardUserDefaults().stringForKey("pureweb_password")
        
        if let username = usernameField.text, let password = passwordField.text
            where username.characters.count > 0 && password.characters.count > 0 {
           connectButton.enabled = true
        } else {
           connectButton.enabled = false
        }
        
        loadCollaborationCredentials()
    }
    
    func loadCollaborationCredentials() {
        if let name = NSUserDefaults.standardUserDefaults().stringForKey("pureweb_collab_name") {
            PWFramework.sharedInstance().collaborationManager().updateUserInfo("Name", value: name)
        }
        
        if let email = NSUserDefaults.standardUserDefaults().stringForKey("pureweb_collab_email") {
            PWFramework.sharedInstance().collaborationManager().updateUserInfo("Email", value: email)
        }
    }
    
    
    // MARK: - Button actions
    
    @IBAction func connectButtonPressed(sender: AnyObject) {
        if let username = usernameField.text, let password = passwordField.text
            where username.characters.count > 0 && password.characters.count > 0 {
         
                processLoginCredentials!(username,password);

        }
    }
    
    
    // MARK: - TextField delegate methods
    
    @IBAction func editingDidChange(sender: AnyObject) {
        
        if let username = usernameField.text, let password = passwordField.text
            where username.characters.count > 0 && password.characters.count > 0 {
                connectButton.enabled = true
        } else {
            connectButton.enabled = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
