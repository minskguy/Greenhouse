import Foundation

final class HumidityPassiveSensor: Device {
    var isOutOfRange: Bool?
    var observedSensors: [IndexPath : Double]?
    var currentValue: Double? = 55
    var isActive: Bool = true
    var deviceType: DeviceType = .humidityPassiveSensor
}
