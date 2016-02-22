//
//  ColorViewController.swift
//  Scribble
//
//  Created by Jonathan Neitz on 2016-02-08.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

import UIKit
import PureWeb

class ColorViewController: UIViewController {
    
    var trayExtended : Bool = false
    
    var currentlySelectedColorButton : UIButton?
    @IBOutlet weak var enclosingView : UIView!
    
    let colorNames = [ "White", "Black","Blue", "Red", "Green", "Purple","Orange", "Yellow"];
    let colors =  [UIColor.whiteColor(), UIColor.blackColor(),UIColor.blueColor(), UIColor.redColor(),
        UIColor.greenColor(), UIColor.purpleColor(),UIColor.orangeColor(),UIColor.yellowColor()]
    
    var colorDict = [String : UIColor]()
    var reverseColorDict = [UIColor : String]()
    
    func selectTray() {
        
        if let superView = self.view.superview {
            
            let colorTrayFrame = superView.frame;
            let colorTrayHeight = superView.frame.size.height;
            
            let navigationBarHeight : CGFloat = 44;
            var offset = colorTrayHeight + navigationBarHeight;
            
            //If the tray is already extended, we want to move in the opposite direction
            if(trayExtended){
                offset = offset * -1;
            }
            
            //Animation the hiding or showing animation
            UIView.animateWithDuration(0.3, delay:0, options:.LayoutSubviews,  animations: {
                
                let destinationFrame = CGRect(x: colorTrayFrame.origin.x, y: (colorTrayFrame.origin.y - offset),
                    width: colorTrayFrame.size.width, height: colorTrayFrame.size.height);
                
                superView.frame = destinationFrame;
                
                },  completion: nil);
        }
        
        //Reverse whether tray has been extended
        self.trayExtended = !self.trayExtended;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PWFramework.sharedInstance().state().stateManager.addValueChangedHandler("/ScribbleColor",target: self,
            action: Selector("colorDidChange:"));
        for i in 0..<colorNames.count {
            reverseColorDict[colors[i]] = colorNames[i]
            colorDict[colorNames[i]] = colors[i]
        }
        
        setupColorButtons()
    }
    
    override func viewWillLayoutSubviews() {
        self.trayExtended = false; // whenever the view does a layout we need to restore the extended to no, since the container will return to the autolayout proportions
    }
    
    // MARK: - Button selection functions
    
    func setupColorButtons() {
        for(index, subview) in self.enclosingView.subviews.enumerate() {
            
            if let button = subview as? UIButton {
                
                let colorName = colorNames[index]
                let color = colorDict[colorName]
                
                button.backgroundColor = color!;
                
                button.layer.cornerRadius = 10.0;
            }
        }
    }
    
    func selectButton(button: UIButton?) {
        if let bttn = button {
            bttn.layer.borderColor = bttn.backgroundColor!.highlightColor().CGColor;
            bttn.layer.borderWidth  = 5.0;
        }
    }
    
    func buttonForColor(color: UIColor) -> (UIButton?) {
        var chosenButton : UIButton?
        
        for(_, subview) in self.enclosingView.subviews.enumerate() {
            
            if let button = subview as? UIButton {
                if button.backgroundColor == color {
                    chosenButton = button
                    break;
                }
            }
        }
        
        return chosenButton;
    }
    
    func unselectButton(button: UIButton?) {
        if let bttn = button {
            bttn.layer.borderWidth = 0.0;
        }
    }
    
    @IBAction func colorButtonSelected(button : UIButton?) {
        if let bttn = button {
            updateAppStateWithColor(bttn.backgroundColor!);
        }
    }
    
    // MARK: - PureWeb methods
    
    func updateAppStateWithColor(chosenColor : UIColor) {
        let colorName = reverseColorDict[chosenColor];
        PWFramework.sharedInstance().state().setAppStatePathWithValue("/ScribbleColor", value: colorName!);
    }
    
    func colorDidChange(args : PWValueChangedEventArgs) {
        
        let colorName = args.newValue;
        let chosenColor = colorDict[colorName];
        
        //regardless of whether the color corresponds, unselect the currently selected color
        unselectButton(currentlySelectedColorButton);
        
        //if a button corresponding to the updated color exists then select it
        if chosenColor != nil {
            if let chosenButton = buttonForColor(chosenColor!) {
            
                selectButton(chosenButton);
                self.currentlySelectedColorButton = chosenButton;
            }
        }
        
    }
    
}
