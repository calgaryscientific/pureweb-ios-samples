//
//  AppStateViewController.swift
//  Asteroids
//
//  Created by Jonathan Neitz on 2016-02-16.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

import UIKit
import PureWeb

class AppStateViewController: UIViewController {

    @IBOutlet weak var appStateWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let description = PWFramework.sharedInstance().state().stateManager.getTree("/").description;
        
        let xml = "<?xml version=\"1.0\"encoding=\"UTF-8\" ?>\(description)"
        
        if let data = xml.dataUsingEncoding(NSUTF8StringEncoding) {
            
            appStateWebView.loadData(data, MIMEType:"text/plain", textEncodingName:"utf-8", baseURL: NSURL( string:"http://")! );
        }
    }

}
