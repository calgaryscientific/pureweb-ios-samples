//
//  TraceViewController.swift
//  Asteroids
//
//  Created by Jonathan Neitz on 2016-02-16.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

import UIKit
import PureWeb

class TraceViewController: UIViewController {

    @IBOutlet weak var traceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logger = PWTraceLogger.sharedInstance()
        
        let messages = logger?.getMessages()
        
        for message in messages! {
            logMessage(message as! String)
        }
        
        logger?.messageLogged().addSubscriber(self, action: #selector(DDLogger.log(message:)))
    }

    func logMessage(_ msg:String) {
        traceTextView.text = traceTextView.text + msg + "\n";
        traceTextView.scrollRangeToVisible( NSMakeRange(traceTextView.text.characters.count, 0));
    }
    
    deinit {
        let logger = PWTraceLogger.sharedInstance()
        logger?.messageLogged().removeSubscriber(self, action: #selector(DDLogger.log(message:)))
    }
    
}
