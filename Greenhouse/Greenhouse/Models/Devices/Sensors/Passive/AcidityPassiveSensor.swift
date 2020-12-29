import Foundation

final class AcidityPassiveSensor: Device {
    var isOutOfRange: Bool?
    var observedSensors: [IndexPath : Double]?
    var currentValue: Double? = 34
    var isActive: Bool = true
    var deviceType: DeviceType = .acidityPassiveSensor
}
