import Cocoa

class DeviceItem: NSCollectionViewItem {
    
    var parameterLabel: NSTextField = {
        let parameterLabel = NSTextField()
        parameterLabel.font = NSFont.systemFont(ofSize: 10)
        parameterLabel.isEditable = false
        parameterLabel.isBordered = false
        parameterLabel.isHidden = true
        return parameterLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parameterLabel.frame = NSRect(x: view.frame.width / 2 - parameterLabel.frame.width / 2, y: view.frame.height / 2 - parameterLabel.frame.height / 2, width: parameterLabel.frame.width, height: parameterLabel.frame.height)
        view.addSubview(parameterLabel)
        
        view.wantsLayer = true
        setBackgroundColor(color: NSColor.gray.cgColor)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        parameterLabel.stringValue = ""
        parameterLabel.isHidden = true
    }
    
    func setImage(image: NSImage?) {
        imageView?.image = image
    }
    
    func setBackgroundColor(color: CGColor) {
        view.wantsLayer = true
        let layer: CALayer = CALayer()
        layer.backgroundColor = color
        layer.frame = view.bounds
        view.layer = layer
    }
}
