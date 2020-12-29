import Foundation

protocol Device {
    var isOutOfRange: Bool? { get set }
    var isActive: Bool { get set }
    var deviceType: DeviceType { get set }
    var currentValue: Double? { get set }
    var observedSensors: [IndexPath: Double]? { get set }
}
