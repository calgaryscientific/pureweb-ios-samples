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
    case started
    case ended
}

class DirectionView: UIVisualEffectView {

    // MARK: - Process touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
    
            processTouch(touch, withMode:.started);
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
    
            processTouch(touch, withMode:.ended);
        }
    }
    
    func processTouch(_ touch: UITouch, withMode mode: ActionMode) {
    
        let location = touch.location(in: self)
    
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
    
    func leftWithMode(_ mode: ActionMode) {
    
        if mode == .started {
    
            queueKeyPress("KeyDown",  keycode: .left,  modifiers:0);
    
        }
        else {
    
            queueKeyPress("KeyUp", keycode: .left, modifiers:0);
        }
    }
    
    func rightWithMode(_ mode: ActionMode) {
    
        if mode == .started {
    
            queueKeyPress("KeyDown",  keycode: .right,  modifiers:0);
        }
        else {
    
            queueKeyPress("KeyUp", keycode: .right, modifiers:0);
        }
    }
    
    func topWithMode(_ mode: ActionMode) {
    
        if mode == .started {
    
            queueKeyPress("KeyDown",  keycode: .up,  modifiers:0);
    
        }
        else {
    
             queueKeyPress("KeyUp", keycode: .up, modifiers:0);
        }
    
    }
    
    func bottomWithMode(_ mode: ActionMode) {
    
        if mode == .started {
    
            queueKeyPress("KeyDown",  keycode: .down,  modifiers:0);
    
        }
        else {
    
             queueKeyPress("KeyUp", keycode: .down, modifiers:0);
        }
    
    }
    
    func queueKeyPress(_ eventType: String, keycode: KeyCode, modifiers: Int)
    {
        let cmdParams = [ "EventType" : eventType, "Path" : "AsteroidsView", "KeyCode" : "\(keycode.rawValue)", "Modifiers" : "\(modifiers)" ]
    
        PWFramework.sharedInstance().client().queueCommand("InputEvent", withParameters:cmdParams);
    }
   

}
