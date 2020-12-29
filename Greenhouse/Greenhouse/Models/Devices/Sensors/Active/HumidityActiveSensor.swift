import Foundation

final class HumidityActiveSensor: Device {
    var isOutOfRange: Bool? = false
    var observedSensors: [IndexPath : Double]?
    var currentValue: Double? = 55
    var isActive: Bool = true
    var deviceType: DeviceType = .humidityActiveSensor
}
