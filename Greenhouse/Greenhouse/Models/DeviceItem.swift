//
//  DeviceItem.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/3/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Cocoa

class DeviceItem: NSCollectionViewItem {
    
    var parameterLabel: NSTextField?
    var parameter: Double? {
        didSet {
            guard let parameter = self.parameter else { return }
            parameterLabel?.stringValue = String(parameter)
            parameterLabel?.isHidden = false
            }
        }
    
    func addLabel() {
        let label = NSTextField()
        label.stringValue = String(parameter!)
        label.font = NSFont.systemFont(ofSize: 10)
        label.isEditable = false
        label.sizeToFit()
        label.frame = NSRect(x: view.frame.width / 2 - label.frame.width / 2, y: view.frame.height / 2 - label.frame.height / 2, width: label.frame.width, height: label.frame.height)
        parameterLabel = label
        view.addSubview(label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        let layer: CALayer = CALayer()
        layer.backgroundColor = NSColor.gray.cgColor
        layer.frame = view.bounds
        view.layer = layer
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        parameterLabel?.stringValue = ""
        parameterLabel?.isHidden = true
    }
    
    func setImage(image: NSImage?) {
        imageView?.image = image
    }
}
