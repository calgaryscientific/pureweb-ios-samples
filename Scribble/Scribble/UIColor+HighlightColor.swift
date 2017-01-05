//
//  UIColor+HighlightColor.swift
//  Scribble
//
//  Created by Jonathan Neitz on 2016-02-08.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

import Foundation

extension UIColor {
    
    func highlightColor() -> (UIColor) {
        
        let specialColors = [UIColor(red:0.93333334, green:0.50980395, blue:0.93333334, alpha:1),
            UIColor(red:1.0, green:1.0, blue:1.0, alpha:1),
            UIColor.yellow,
            UIColor.white];
        
        for color in specialColors {
            if color == self {
                return UIColor.black
            }
        }
        
        return UIColor.white;
    }
}
