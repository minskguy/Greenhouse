import Foundation

final class SourceOfLight: Device {
    var isOutOfRange: Bool?
    var observedSensors: [IndexPath : Double]?
    var currentValue: Double? = nil
    var isActive: Bool = false
    var deviceType: DeviceType = .sourceOfLight
}
