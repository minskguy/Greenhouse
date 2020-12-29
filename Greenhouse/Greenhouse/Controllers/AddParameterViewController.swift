import Cocoa

class AddParameterViewController: NSViewController {
    @IBOutlet weak var parameterNameComboBox: NSComboBox!
    @IBOutlet weak var valueTextField: NSTextField!
    @IBOutlet weak var durationTextField: NSTextField!
    @IBOutlet weak var startTimeTextField: NSTextField!
    @IBOutlet weak var deviationTextField: NSTextField!
    
    weak var parentVC: CultivationCycleViewController?
    
    @IBAction func addParameterButtonTapped(_ sender: NSButton) {
        guard let parameterName = parameterNameComboBox.objectValueOfSelectedItem as? String, !parameterName.isEmpty else {
            showAlert(messageHeader: "Invalid Parameter Name", messageText: "Choose any parameter from the list")
            return
        }
        
        guard let value = valueTextField?.doubleValue, let duration =
            durationTextField?.intValue, let startTime = startTimeTextField?.intValue, let deviation = deviationTextField?.doubleValue else { return }
        if (value <= 0 || value > 100) {
            showAlert(messageHeader: "Invalid Value", messageText: "Enter valid value")
            return
        } else if (duration <= 0) {
            showAlert(messageHeader: "Invalid Duration", messageText: "Enter valid duration")
            return
        } else if (startTime <= 0) {
            showAlert(messageHeader: "Invalid Start Time", messageText: "Enter valid start time")
            return
        } else if (deviation <= 0) {
            showAlert(messageHeader: "Invalid Deviation", messageText: "Enter valid deviation")
            return
        }
        for i in 0..<CultivationCycleManager.shared.currentParameterConfiguration.count {
            let parameter = CultivationCycleManager.shared.currentParameterConfiguration[i]
            if (startTime >= parameter.startTime && startTime < parameter.startTime + parameter.duration)
                || (startTime + duration > startTime && startTime + duration <= parameter.startTime + parameter.duration) {
                showAlert(messageHeader: "Invalid Start Time", messageText: "Two parameters cannot occur simultaneously! Enter valid start time")
                return
            }
        }
        let parameter: Parameter = Parameter(name: parameterName, value: value, duration: Int(duration), deviation: deviation, startTime: Int(startTime))
        parentVC?.newParameter = parameter
        dismiss(self)
    }
}
