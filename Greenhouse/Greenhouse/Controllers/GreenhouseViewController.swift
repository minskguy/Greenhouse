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
    @IBOutlet weak var cultivationTextField: NSTextField!
    @IBOutlet weak var plantImageView: NSImageView!
    @IBOutlet weak var headerColorWell: NSColorWell!
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(timeDidChange(notification:)), name: NSNotification.Name(rawValue: "timeDidChange"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cultivationTextField.stringValue = "\(CultivationCycleManager.shared.currentPlant.rawValue), cycle start - 13.11.2020, lasted: \(CultivationCycleManager.shared.cultivationCycleCurrentTime) hours"
        plantImageView.image = NSImage(named: CultivationCycleManager.shared.currentPlant.rawValue.lowercased())
        configureDevicesCollectionView()
        devices = CultivationCycleManager.shared.currentDeviceConfiguration
        changeBackgroundColor()
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
        item.parameterLabel?.stringValue = ""
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
            item.parameter = nil
            break
        }
        item.addLabel()
        item.setImage(image: device.getImage())
        return item
    }
    
    func changeBackgroundColor() {
        switch CultivationCycleManager.shared.currentPlant {
        case .hibiscus:
            headerColorWell.color = NSColor(red: 158/255, green: 122/255, blue: 18/255, alpha: 1)
        case .clivia:
            headerColorWell.color = NSColor(red: 179/255, green: 143/255, blue: 15/255, alpha: 1)
        case .dahlia:
            headerColorWell.color = NSColor(red: 179/255, green: 69/255, blue: 70/255, alpha: 1)
        case .jade:
            headerColorWell.color = NSColor(red: 159/255, green: 114/255, blue: 161/255, alpha: 1)
        case .plumeria:
            headerColorWell.color = NSColor(red: 157/255, green: 150/255, blue: 182/255, alpha: 1)
        }
    }
    
    @objc func timeDidChange(notification: NSNotification) {
        guard let time = notification.object as? Int else { return }
        cultivationTextField.stringValue = "\(CultivationCycleManager.shared.currentPlant.rawValue), cycle start - 13.11.2020, lasted: \(time) hours"
    }
}



