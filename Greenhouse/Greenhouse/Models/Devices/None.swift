import Foundation

final class None: Device {
    var isOutOfRange: Bool?
    var observedSensors: [IndexPath : Double]?
    var currentValue: Double? = nil
    var isActive: Bool = true
    var deviceType: DeviceType = .none
}
