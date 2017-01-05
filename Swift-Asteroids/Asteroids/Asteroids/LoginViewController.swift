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
        usernameField.text = UserDefaults.standard.string(forKey: "pureweb_username")
        passwordField.text = UserDefaults.standard.string(forKey: "pureweb_password")
        
        if let username = usernameField.text, let password = passwordField.text, username.characters.count > 0 && password.characters.count > 0 {
           connectButton.isEnabled = true
        } else {
           connectButton.isEnabled = false
        }
        
        loadCollaborationCredentials()
    }
    
    func loadCollaborationCredentials() {
        if let name = UserDefaults.standard.string(forKey: "pureweb_collab_name") {
            PWFramework.sharedInstance().collaborationManager().updateUserInfo("Name", value: name)
        }
        
        if let email = UserDefaults.standard.string(forKey: "pureweb_collab_email") {
            PWFramework.sharedInstance().collaborationManager().updateUserInfo("Email", value: email)
        }
    }
    
    
    // MARK: - Button actions
    
    @IBAction func connectButtonPressed(_ sender: AnyObject) {
        if let username = usernameField.text, let password = passwordField.text, username.characters.count > 0 && password.characters.count > 0 {
         
                processLoginCredentials!(username,password);

        }
    }
    
    
    // MARK: - TextField delegate methods
    
    @IBAction func editingDidChange(_ sender: AnyObject) {
        
        if let username = usernameField.text, let password = passwordField.text, username.characters.count > 0 && password.characters.count > 0 {
                connectButton.isEnabled = true
        } else {
            connectButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
