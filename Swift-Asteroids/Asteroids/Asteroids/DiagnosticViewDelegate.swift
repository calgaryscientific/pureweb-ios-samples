//
//  DiagnosticViewDelegate.swift
//  Asteroids
//
//  Created by Jonathan Neitz on 2016-02-16.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

import UIKit
import PureWeb

class DiagnosticViewDelegate: NSObject, PWViewDelegate {

    static let encoderConfiguration = PWMutableEncoderConfiguration(interactiveQuality: PWMutableEncoderFormat(mimeType: "image/x-tile", quality: 30),
                                                                    fullQuality: PWMutableEncoderFormat(mimeType:"image/png", quality:70))
    static let sharedInstance = DiagnosticViewDelegate()
    
    override fileprivate init() {}
    
    // MARK - PWView delegate methods
    
    func preferredEncoderConfiguration(for view: PWView!) -> PWEncoderConfiguration! {
        return DiagnosticViewDelegate.encoderConfiguration
    }
}
