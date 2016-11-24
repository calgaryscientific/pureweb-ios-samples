//
//  OptionsViewController.swift
//  Asteroids
//
//  Created by Jonathan Neitz on 2016-02-16.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

import UIKit


class OptionsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var interactiveMimePicker: UIPickerView!
    
    @IBOutlet weak var nonInteractiveMimePicker: UIPickerView!
    
    @IBOutlet weak var interactiveQualitySlider: UISlider!
    
    @IBOutlet weak var nonInteractiveQualitySlider: UISlider!
    
    let divisor : Float = 100.0 // Conversion for the UISlider 0.0 to 1.0 to quality range between 0 and 100
    
    let mimeTypes = ["image/x-tile","image/jpeg","image/png"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        interactiveMimePicker.delegate = self
        interactiveMimePicker.dataSource = self
        nonInteractiveMimePicker.delegate = self
        nonInteractiveMimePicker.dataSource = self
        
        let encoderConfiguration = DiagnosticViewDelegate.encoderConfiguration
        
        interactiveQualitySlider.value = Float(encoderConfiguration.interactiveQuality.quality) / divisor
        nonInteractiveQualitySlider.value = Float(encoderConfiguration.fullQuality.quality) / divisor
        
        setMimePickerRow(encoderConfiguration.interactiveQuality.mimeType, picker: interactiveMimePicker)
        setMimePickerRow(encoderConfiguration.fullQuality.mimeType, picker: nonInteractiveMimePicker)
        
        encoderConfiguration.interactiveQuality.changed.addSubscriber(self, action: #selector(OptionsViewController.interactiveQualityChanged(_:)))
        encoderConfiguration.fullQuality.changed.addSubscriber(self, action: #selector(OptionsViewController.nonInteractiveQualityChanged(_:)))
    }
    
    func setMimePickerRow(mimeType : String, picker : UIPickerView ) {
        var index : Int = 0
        for mime in mimeTypes {
            if mimeType == mime {
                picker.selectRow(index, inComponent: 0, animated: false)
            }
            
            index += 1;
        }
    }
    
    // MARK: UISlider actions
    
    @IBAction func interactiveSliderChanged(sender: UISlider) {
        DiagnosticViewDelegate.encoderConfiguration.interactiveQuality.quality = Int(sender.value * divisor)
    }
    
    @IBAction func nonInteractiveSliderChanged(sender: UISlider) {
        DiagnosticViewDelegate.encoderConfiguration.fullQuality.quality = Int(sender.value * divisor)
    }
    
    // MARK: UIPickerView actions
    
    func interactiveQualityChanged(object : NSObject) {
        let encoderConfiguration = DiagnosticViewDelegate.encoderConfiguration
        
        interactiveQualitySlider.value = Float(encoderConfiguration.interactiveQuality.quality) / divisor
        setMimePickerRow(encoderConfiguration.interactiveQuality.mimeType, picker: interactiveMimePicker)
        
    }
    
    func nonInteractiveQualityChanged(object: NSObject) {
        let encoderConfiguration = DiagnosticViewDelegate.encoderConfiguration
        
        nonInteractiveQualitySlider.value = Float(encoderConfiguration.fullQuality.quality) / divisor
        setMimePickerRow(encoderConfiguration.fullQuality.mimeType, picker: nonInteractiveMimePicker)
    }
    
    // MARK: - UIPickerView Delegate and Data source methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3;
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mimeTypes[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        let encoderConfiguration = DiagnosticViewDelegate.encoderConfiguration
        
        if pickerView == self.interactiveMimePicker {
            encoderConfiguration.interactiveQuality.mimeType = mimeTypes[row]
        } else {
            encoderConfiguration.fullQuality.mimeType = mimeTypes[row]
        }
    }
    
}
