import Cocoa

class LaunchViewController: NSViewController {

    @IBOutlet weak var cultivationCycleButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override var representedObject: Any? {
        didSet {

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
