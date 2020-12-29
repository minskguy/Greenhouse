import Foundation

final class TemperatureActiveSensor: Device {
    var isOutOfRange: Bool? = false
    var observedSensors: [IndexPath : Double]?
    var currentValue: Double? = 25
    var isActive: Bool = true
    var deviceType: DeviceType = .temperatureActiveSensor
}
