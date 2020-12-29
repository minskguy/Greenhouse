import Cocoa

typealias AddedDevice = (String, Int, Int)

class GreenhouseViewController: NSViewController {
    
    var devices = [[Device]]()
    var newDevice: AddedDevice? {
        didSet {
            let results = DeviceType.allCases.filter {
                $0.rawValue.lowercased() == self.newDevice!.0.lowercased().replacingOccurrences(of: " ", with: "")
            }
            var device: Device
            switch results.first! {
            case .heater:
                device = Heater()
            case .sourceOfLight:
                device = SourceOfLight()
            case .conditioner:
                device = Conditioner()
            case .humidifier:
                device = Humidifier()
            case .fertilizerDispenser:
                device = FertilizerDispenser()
            case .acidityActiveSensor:
                device = AcidityActiveSensor()
            case .acidityPassiveSensor:
                device = AcidityPassiveSensor()
            case .humidityActiveSensor:
                device = HumidityActiveSensor()
            case .humidityPassiveSensor:
                device = HumidityPassiveSensor()
            case .temperatureActiveSensor:
                device = TemperatureActiveSensor()
            case .temperaturePassiveSensor:
                device = TemperaturePassiveSensor()
            case .none:
                device = None()
            }
            devices[self.newDevice!.1][self.newDevice!.2] = device
            CultivationCycleManager.shared.currentDeviceConfiguration[self.newDevice!.1][self.newDevice!.2] = device
            cultivationTextField.stringValue = "\(CultivationCycleManager.shared.currentPlant.rawValue), cycle start - 13.11.2020, lasted: \(CultivationCycleManager.shared.cultivationCycleCurrentTime) hours"
            devicesCollectionView.reloadData()
        }
    }
    
    let deviceItemIdentifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "deviceItemIdentifier")
    @IBOutlet weak var devicesCollectionView: NSCollectionView!
    @IBOutlet weak var cultivationTextField: NSTextField!
    @IBOutlet weak var plantImageView: NSImageView!
    @IBOutlet weak var headerColorWell: NSColorWell!
    @IBOutlet weak var addDeviceButton: NSButton!
    
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
        devicesCollectionView.allowsMultipleSelection = false
        cultivationTextField.stringValue = "\(CultivationCycleManager.shared.currentPlant.rawValue), cycle start - \(CultivationCycleManager.shared.cultivationCycleCurrentDate), lasted: \(CultivationCycleManager.shared.cultivationCycleCurrentTime) hours"
        plantImageView.image = NSImage(named: CultivationCycleManager.shared.currentPlant.rawValue.lowercased())
        addDeviceButton.isEnabled = !CultivationCycleManager.shared.isInProcess
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
        devicesCollectionView.delegate = self
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
        cultivationTextField.stringValue = "\(CultivationCycleManager.shared.currentPlant.rawValue), cycle start - \(CultivationCycleManager.shared.cultivationCycleCurrentDate), lasted: \(time) hours"
        devices = CultivationCycleManager.shared.currentDeviceConfiguration
        devicesCollectionView.reloadItems(at: Set(CultivationCycleManager.shared.modifiedDevices))
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
        guard let value = device.currentValue else {
            item.setImage(image: device.deviceType.getImage())
            if !device.isActive {
                item.imageView?.image = NSImage(named: "\(device.deviceType.rawValue)Gray")
            } else {
                item.imageView?.image = NSImage(named: device.deviceType.rawValue)
            }
            return item
        }
        item.parameterLabel.stringValue = String(Int(value))
        item.parameterLabel.isHidden = false
        item.parameterLabel.sizeToFit()
        item.setImage(image: device.deviceType.getImage())
        return item
    }
}

extension GreenhouseViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.forEach() { indexPath in
            guard let item = collectionView.item(at: indexPath) as? DeviceItem else { return }
            item.setBackgroundColor(color: NSColor.blue.cgColor)
            let device = CultivationCycleManager.shared.currentDeviceConfiguration[indexPath.item / 10][indexPath.item % 10]
            if device.deviceType == .acidityActiveSensor
            || device.deviceType == .humidityActiveSensor
                || device.deviceType == .temperatureActiveSensor {
                if device.isOutOfRange! {
                    item.setBackgroundColor(color: NSColor.red.cgColor)
                } else {
                    item.setBackgroundColor(color: NSColor.green.cgColor)
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.forEach() { indexPath in
            guard let item = collectionView.item(at: indexPath) as? DeviceItem else { return }
            item.setBackgroundColor(color: NSColor.gray.cgColor)
            
        }
    }
}
