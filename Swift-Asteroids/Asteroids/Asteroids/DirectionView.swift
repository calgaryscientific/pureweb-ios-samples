//
//  DirectionView.swift
//  Asteroids
//
//  Created by Jonathan Neitz on 2016-02-12.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

import UIKit
import PureWeb

enum ActionMode {
    case Started
    case Ended
}

class DirectionView: UIVisualEffectView {

    // MARK: - Process touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
    
            processTouch(touch, withMode:.Started);
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
    
            processTouch(touch, withMode:.Ended);
        }
    }
    
    func processTouch(touch: UITouch, withMode mode: ActionMode) {
    
        let location = touch.locationInView(self)
    
        if location.y > location.x {
    
            if location.y > (self.frame.size.height - location.x) {
                bottomWithMode(mode)
            }
            else {
                leftWithMode(mode)
            }
    
        }
        else {
    
            if location.y > (self.frame.size.height - location.x) {
    
                rightWithMode(mode)
            }
            else {
    
                topWithMode(mode);
            }
    
        }
    }
    
    
    
    // MARK: - Directional modes
    
    func leftWithMode(mode: ActionMode) {
    
        if mode == .Started {
    
            queueKeyPress("KeyDown",  keycode: .Left,  modifiers:0);
    
        }
        else {
    
            queueKeyPress("KeyUp", keycode: .Left, modifiers:0);
        }
    }
    
    func rightWithMode(mode: ActionMode) {
    
        if mode == .Started {
    
            queueKeyPress("KeyDown",  keycode: .Right,  modifiers:0);
        }
        else {
    
            queueKeyPress("KeyUp", keycode: .Right, modifiers:0);
        }
    }
    
    func topWithMode(mode: ActionMode) {
    
        if mode == .Started {
    
            queueKeyPress("KeyDown",  keycode: .Up,  modifiers:0);
    
        }
        else {
    
             queueKeyPress("KeyUp", keycode: .Up, modifiers:0);
        }
    
    }
    
    func bottomWithMode(mode: ActionMode) {
    
        if mode == .Started {
    
            queueKeyPress("KeyDown",  keycode: .Down,  modifiers:0);
    
        }
        else {
    
             queueKeyPress("KeyUp", keycode: .Down, modifiers:0);
        }
    
    }
    
    func queueKeyPress(eventType: String, keycode: KeyCode, modifiers: Int)
    {
        let cmdParams = [ "EventType" : eventType, "Path" : "AsteroidsView", "KeyCode" : "\(keycode.rawValue)", "Modifiers" : "\(modifiers)" ]
    
        PWFramework.sharedInstance().client().queueCommand("InputEvent", withParameters:cmdParams);
    }
   

}
