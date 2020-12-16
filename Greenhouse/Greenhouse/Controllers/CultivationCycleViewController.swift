//
//  CultivationCycleViewController.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/3/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Cocoa

class CultivationCycleViewController: NSViewController {
    var plantManager: PlantManager = PlantManager()
    var parameters = [Parameter]()
    var plant: String = "Rose" {
        didSet {
            plantTextField?.stringValue = "Plant: \(plant)"
            plantTextField?.sizeToFit()
            parameters = plantManager.getParametersConfiguration(plantName: plant)
            parametersTableView.reloadData()
        }
    }
    
    @IBOutlet weak var parametersTableView: NSTableView!
    @IBOutlet weak var plantTextField: NSTextField!
    @IBOutlet weak var plantImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureParametersTableView()
        parameters = plantManager.getParametersConfiguration(plantName: plant)
        parametersTableView.reloadData()
    }
    @IBAction func backButtonTapped(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func changePlantButtonTapped(_ sender: NSButton) {
        guard let VC = NSStoryboard.main?.instantiateController(withIdentifier: "changePlantID") as? ChangePlantViewController else { return }
        VC.parentVC = self
        presentAsModalWindow(VC)
    }
    
    func configureParametersTableView() {
        parametersTableView.delegate = self
        parametersTableView.dataSource = self
    }
    
    func fillTableView() {
        parameters.append(Parameter(name: "Temperature", value: 35, duration: 46, deviation: 10, startTime: 78))
        parameters.append(Parameter(name: "Humidity", value: 14, duration: 10, deviation: 20, startTime: 8))
        parameters.append(Parameter(name: "Light", value: 1, duration: 28, deviation: 0, startTime: 10))
        parametersTableView.reloadData()
    }
    
}

extension CultivationCycleViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return parameters.count
    }
}

extension CultivationCycleViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ParameterCellID"), owner: nil) as? NSTableCellView {
            switch tableColumn {
            case tableView.tableColumns[0]:
                cell.textField?.stringValue = parameters[row].parameterName
                break
            case tableView.tableColumns[1]:
                cell.textField?.stringValue = String(parameters[row].value)
                break
            case tableView.tableColumns[2]:
                cell.textField?.stringValue = String(parameters[row].duration)
                break
            case tableView.tableColumns[3]:
                cell.textField?.stringValue = String(parameters[row].deviation)
                break
            case tableView.tableColumns[4]:
                cell.textField?.stringValue = String(parameters[row].startTime)
                break
            default:
                break
            }
            return cell
        }
        return nil
    }
}
