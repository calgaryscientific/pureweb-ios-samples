//
//  DiagnosticsViewController.swift
//  Asteroids
//
//  Created by Jonathan Neitz on 2016-02-16.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

import UIKit

class DiagnosticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func doneButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
