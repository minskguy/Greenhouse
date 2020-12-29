import Foundation

final class TemperaturePassiveSensor: Device {
    var isOutOfRange: Bool?
    var observedSensors: [IndexPath : Double]?
    var currentValue: Double? = 25
    var isActive: Bool = true
    var deviceType: DeviceType = .temperaturePassiveSensor
}
