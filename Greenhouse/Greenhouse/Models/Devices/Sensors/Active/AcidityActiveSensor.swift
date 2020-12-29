import Foundation

final class AcidityActiveSensor: Device {
    var isOutOfRange: Bool? = false
    var observedSensors: [IndexPath : Double]?
    var currentValue: Double? = 34
    var isActive: Bool = true
    var deviceType: DeviceType = .acidityActiveSensor
}
