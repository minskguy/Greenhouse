//
//  AddDeviceViewController.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/3/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Cocoa

class AddDeviceViewController: NSViewController {
    
    @IBOutlet weak var deviceTypeComboBox: NSComboBox!
    @IBOutlet weak var rowTextField: NSTextField!
    @IBOutlet weak var columnTextField: NSTextField!
    
    weak var parentVC: GreenhouseViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func addDeviceButton(_ sender: NSButton) {
        guard let deviceType = deviceTypeComboBox.objectValueOfSelectedItem as? String else { return }
        guard let row = rowTextField?.intValue, let column =
            columnTextField?.intValue else { return }
        let device: AddedDevice = (deviceType, Int(row), Int(column))
        parentVC?.newDevice = device
        dismiss(self)
    }
}
