//
//  AddParameterViewController.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/12/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Cocoa

class AddParameterViewController: NSViewController {
    @IBOutlet weak var parameterNameComboBox: NSComboBox!
    @IBOutlet weak var valueTextField: NSTextField!
    @IBOutlet weak var durationTextField: NSTextField!
    @IBOutlet weak var startTimeTextField: NSTextField!
    @IBOutlet weak var deviationTextField: NSTextField!
    
    weak var parentVC: CultivationCycleViewController?
    
    @IBAction func addParameterButtonTapped(_ sender: NSButton) {
        guard let parameterName = parameterNameComboBox.objectValueOfSelectedItem as? String else { return }
        guard let value = valueTextField?.intValue, let duration =
            durationTextField?.intValue, let startTime = startTimeTextField?.intValue, let deviation = deviationTextField?.doubleValue else { return }
        let parameter: Parameter = Parameter(name: parameterName, value: Int(value), duration: Int(duration), deviation: deviation, startTime: Int(startTime))
        parentVC?.newParameter = parameter
        dismiss(self)
    }
}
