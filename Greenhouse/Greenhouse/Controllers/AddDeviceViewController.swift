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
    }
    
    @IBAction func addDeviceButton(_ sender: NSButton) {
        guard let deviceType = deviceTypeComboBox.objectValueOfSelectedItem as? String, !deviceType.isEmpty else {
            showAlert(messageHeader: "Invalid Device Type", messageText: "Choose any device type from the list")
            return
        }
        guard let row = rowTextField?.stringValue, let column =
            columnTextField?.stringValue else { return }
        if ((Int(row) ?? -1) < 0 || (Int(row) ?? -1) > 3 || row.isEmpty) {
            showAlert(messageHeader: "Invalid Row Value", messageText: "Enter valid row value")
            return
        } else if ((Int(column) ?? -1) < 0 || (Int(column) ?? -1) > 9 || column.isEmpty) {
            showAlert(messageHeader: "Invalid Column Value", messageText: "Enter valid column value")
            return
        }
        let device: AddedDevice = (deviceType, (Int(column) ?? -1), (Int(column) ?? -1))
        parentVC?.newDevice = device
        dismiss(self)
    }
}
