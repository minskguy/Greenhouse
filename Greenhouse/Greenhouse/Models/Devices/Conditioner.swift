import Foundation

final class Conditioner: Device {
    var isOutOfRange: Bool?
    var observedSensors: [IndexPath : Double]? = [:]
    var currentValue: Double? = nil
    var isActive: Bool = false
    var deviceType: DeviceType = .conditioner
}
