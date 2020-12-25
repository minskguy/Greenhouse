//
//  Utilities+NSViewController.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/24/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Cocoa

extension NSViewController {
    func showAlert(messageHeader: String, messageText: String) {
        let alert = NSAlert()
        alert.messageText = messageHeader
        alert.informativeText = messageText
        alert.beginSheetModal(for: self.view.window!)
    }
}
