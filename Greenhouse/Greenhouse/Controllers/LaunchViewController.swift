//
//  LaunchViewController.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/3/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Cocoa

class LaunchViewController: NSViewController {

    @IBOutlet weak var cultivationCycleButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func cultivationCycleButtonTapped(_ sender: NSButton) {
        if CultivationCycleManager.shared.isInProcess {
            CultivationCycleManager.shared.isInProcess = false
            cultivationCycleButton.image = NSImage(named: "startCultivationCycleButton")
        } else {
            CultivationCycleManager.shared.isInProcess = true
            cultivationCycleButton.image = NSImage(named: "stopCultivationCycleButton")
        }
    }
}
