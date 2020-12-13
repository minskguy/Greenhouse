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
        
        guard let plantString = plantComboBox.objectValueOfSelectedItem as? String else { return }
        parentVC?.plant = plantString
        dismiss(self)
    }
    
}
