//
//  ChangePlantViewController.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/12/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Cocoa

class ChangePlantViewController: NSViewController {
    
    @IBOutlet weak var plantComboBox: NSComboBox!
    weak var parentVC: CultivationCycleViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changePlantButtonTapped(_ sender: NSButton) {
        
        guard let plantString = plantComboBox.objectValueOfSelectedItem as? String, !plantString.isEmpty else {
            showAlert(messageHeader: "Invalid plant", messageText: "Choose any plant from the list")
            return
            
        }
        CultivationCycleManager.shared.currentPlant = Plants(rawValue: plantString)!
        parentVC?.plant = Plants(rawValue: plantString)!
        dismiss(self)
    }
    
}
