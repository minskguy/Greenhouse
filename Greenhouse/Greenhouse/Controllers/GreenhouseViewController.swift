//
//  GreenhouseViewController.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/3/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Cocoa

typealias AddedDevice = (String, Int, Int)

class GreenhouseViewController: NSViewController {
    
    var devices = [[Devices]]()
    var newDevice: AddedDevice? {
        didSet {
            let results = Devices.allCases.filter {
                $0.rawValue.lowercased() == self.newDevice!.0.lowercased().replacingOccurrences(of: " ", with: "")
            }
            devices[self.newDevice!.1][self.newDevice!.2] = results.first!
            devicesCollectionView.reloadData()
        }
    }
    
    let deviceItemIdentifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "deviceItemIdentifier")
    @IBOutlet weak var devicesCollectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDevicesCollectionView()
        fillModel()
        devicesCollectionView.reloadData()
    }
    
    @IBAction func addDeviceButtonTapped(_ sender: NSButton) {
        guard let VC = NSStoryboard.main?.instantiateController(withIdentifier: "addDeviceID") as? AddDeviceViewController else { return }
        VC.parentVC = self
        presentAsModalWindow(VC)
    }
    
    @IBAction func backButtonTapped(_ sender: NSButton) {
        dismiss(self)
    }
    
    func configureDevicesCollectionView() {
        devicesCollectionView.delegate = self
        devicesCollectionView.dataSource = self
        devicesCollectionView.register(NSNib(nibNamed: "DeviceItem", bundle: nil), forItemWithIdentifier: deviceItemIdentifier)
        configureGridLayout()
    }
    
    func configureGridLayout() {
        let gridLayout = NSCollectionViewGridLayout()
        gridLayout.minimumInteritemSpacing = 10.0
        gridLayout.minimumLineSpacing = 10.0
        gridLayout.maximumNumberOfColumns = 10
        gridLayout.maximumNumberOfRows = 4
        gridLayout.margins = NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        devicesCollectionView.collectionViewLayout = gridLayout
    }
    
    func fillModel() {
        for _ in 0...3 {
            var devicesRow = [Devices]()
            for _ in 0...9 {
                devicesRow.append(.none)
            }
            devices.append(devicesRow)
        }
        defaultGreenhouse()
    }
    
    func defaultGreenhouse() {
        devices[0][0] = .acidityActiveSensor
        devices[3][0] = .acidityPassiveSensor
        devices[0][9] = .temperaturePassiveSensor
        devices[3][9] = .temperatureActiveSensor
        devices[1][2] = .humidityActiveSensor
        devices[0][4] = .humidityPassiveSensor
    }
}

extension GreenhouseViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
         guard let item = collectionView.makeItem(withIdentifier: deviceItemIdentifier, for: indexPath) as? DeviceItem else { return NSCollectionViewItem() }
        let device = devices[indexPath.item / 10][indexPath.item % 10]
        switch device {
        case .acidityActiveSensor:
            item.parameter = 34
        case .acidityPassiveSensor:
            item.parameter = 34
        case .temperatureActiveSensor:
            item.parameter = 25
        case .temperaturePassiveSensor:
            item.parameter = 25
        case .humidityActiveSensor:
            item.parameter = 55
        case .humidityPassiveSensor:
            item.parameter = 55
        default:
            break
        }
        if device == .acidityActiveSensor
            || device == .acidityPassiveSensor
            || device == .humidityActiveSensor
            || device == .humidityPassiveSensor
            || device == .temperatureActiveSensor
            || device == .temperaturePassiveSensor {
            item.addLabel()
        }
        item.setImage(image: device.getImage())
        return item
    }

}



