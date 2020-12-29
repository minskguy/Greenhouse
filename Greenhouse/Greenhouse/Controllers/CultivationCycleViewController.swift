import Cocoa

class CultivationCycleViewController: NSViewController {
    var parameters = [Parameter]()
    var newParameter: Parameter = Parameter() {
        didSet {
            parameters.append(self.newParameter)
            CultivationCycleManager.shared.currentParameterConfiguration.append(self.newParameter)
            parametersTableView.reloadData()
        }
    }
    var plant: Plants = CultivationCycleManager.shared.currentPlant {
        didSet {
            parameters = CultivationCycleManager.shared.currentParameterConfiguration
            plantTextField?.stringValue = "Plant: \(self.plant.rawValue)"
            plantTextField?.sizeToFit()
            plantImageView.image = NSImage(named: self.plant.rawValue.lowercased())
            parametersTableView.reloadData()
        }
    }
    
    @IBOutlet weak var parametersTableView: NSTableView!
    @IBOutlet weak var plantTextField: NSTextField!
    @IBOutlet weak var plantImageView: NSImageView!
    @IBOutlet weak var cultivationCycleDurationTextField: NSTextField!
    @IBOutlet weak var changePlantButton: NSButton!
    @IBOutlet weak var addParameterButton: NSButton!
    @IBOutlet weak var customModeButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureParametersTableView()
        parameters = CultivationCycleManager.shared.currentParameterConfiguration
        plantTextField?.stringValue = "Plant: \(self.plant.rawValue)"
        plantTextField?.sizeToFit()
        plantImageView.image = NSImage(named: self.plant.rawValue.lowercased())
        changePlantButton.isEnabled = !CultivationCycleManager.shared.isInProcess
        customModeButton.isEnabled = !CultivationCycleManager.shared.isInProcess
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
    
    @IBAction func addParameterButtonTapped(_ sender: NSButton) {
        guard let VC = NSStoryboard.main?.instantiateController(withIdentifier: "addParameterID") as? AddParameterViewController else { return }
        VC.parentVC = self
        presentAsModalWindow(VC)
    }
    
    @IBAction func customModeButtonTapped(_ sender: NSButton) {
        if cultivationCycleDurationTextField.isEnabled {
            cultivationCycleDurationTextField.isEnabled = false
            
        } else {
            cultivationCycleDurationTextField.isEnabled = true
        }
    }
    
    
    func configureParametersTableView() {
        parametersTableView.delegate = self
        parametersTableView.dataSource = self
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
