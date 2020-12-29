import Cocoa

extension NSViewController {
    func showAlert(messageHeader: String, messageText: String) {
        let alert = NSAlert()
        alert.messageText = messageHeader
        alert.informativeText = messageText
        alert.beginSheetModal(for: self.view.window!)
    }
}
