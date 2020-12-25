import Foundation
import Cocoa

final class CultivationCycleManager: NSObject {
    
    var cultivationCycleTimer: Timer?
    var cultivationCycleDuration = 100
    var cultivationCycleCurrentTime = 0
    var currentPlant: Plants = .hibiscus {
        didSet {
            changeConfiguration()
        }
    }
    var currentParameterConfiguration: [Parameter] = []
    var currentDeviceConfiguration: [[Devices]] = [[]]
    var isInProcess: Bool = false {
        didSet {
            if isInProcess {
                startCultivationCycle()
            } else {
                stopCultivationCycle()
            }
        }
    }
    static var shared = CultivationCycleManager()
    
    private override init() {
        super.init()
        changeConfiguration()
    }
    
    func startCultivationCycle() {
        cultivationCycleTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    }
    
    func stopCultivationCycle() {
        cultivationCycleTimer?.invalidate()
    }
    
    func changeConfiguration() {
        currentParameterConfiguration = []
        currentDeviceConfiguration = emptyDeviceConfiguration()
        
        switch currentPlant {
        case .hibiscus:
            cultivationCycleDuration = 100
            
            currentParameterConfiguration.append(Parameter(name: "Temperature", value: 35, duration: 46, deviation: 10, startTime: 78))
            currentParameterConfiguration.append(Parameter(name: "Humidity", value: 14, duration: 10, deviation: 20, startTime: 8))
            currentParameterConfiguration.append(Parameter(name: "Light", value: 1, duration: 28, deviation: 0, startTime: 10))
            
            currentDeviceConfiguration[0][0] = .acidityActiveSensor
            currentDeviceConfiguration[3][0] = .acidityPassiveSensor
            currentDeviceConfiguration[0][9] = .temperaturePassiveSensor
            currentDeviceConfiguration[3][9] = .temperatureActiveSensor
            currentDeviceConfiguration[1][2] = .humidityActiveSensor
            currentDeviceConfiguration[0][4] = .humidityPassiveSensor
        case .clivia:
            cultivationCycleDuration = 50
            
            currentParameterConfiguration.append(Parameter(name: "Temperature", value: 35, duration: 2, deviation: 40, startTime: 178))
            currentParameterConfiguration.append(Parameter(name: "Humidity", value: 14, duration: 10, deviation: 20, startTime: 8))
            currentParameterConfiguration.append(Parameter(name: "Temperature", value: 35, duration: 76, deviation: 40, startTime: 180))
            
            currentDeviceConfiguration[1][0] = .acidityActiveSensor
            currentDeviceConfiguration[3][4] = .acidityPassiveSensor
            currentDeviceConfiguration[3][3] = .temperaturePassiveSensor
            currentDeviceConfiguration[0][0] = .temperatureActiveSensor
            currentDeviceConfiguration[2][8] = .humidityActiveSensor
            currentDeviceConfiguration[3][0] = .humidityPassiveSensor
        case .dahlia:
            cultivationCycleDuration = 86
            
            currentParameterConfiguration.append(Parameter(name: "Humidity", value: 14, duration: 10, deviation: 20, startTime: 8))
            currentParameterConfiguration.append(Parameter(name: "Humidity", value: 50, duration: 23, deviation: 20, startTime: 19))
        case .jade:
            cultivationCycleDuration = 34
            
            currentParameterConfiguration.append(Parameter(name: "Temperature", value: 21, duration: 46, deviation: 10, startTime: 78))
            currentParameterConfiguration.append(Parameter(name: "Light", value: 1, duration: 28, deviation: 0, startTime: 10))
            currentParameterConfiguration.append(Parameter(name: "Humidity", value: 6, duration: 10, deviation: 20, startTime: 8))
        case .plumeria:
            cultivationCycleDuration = 180
            
            currentParameterConfiguration.append(Parameter(name: "Temperature", value: 35, duration: 46, deviation: 10, startTime: 78))
            currentParameterConfiguration.append(Parameter(name: "Humidity", value: 14, duration: 10, deviation: 20, startTime: 8))
            currentParameterConfiguration.append(Parameter(name: "Light", value: 1, duration: 28, deviation: 0, startTime: 10))
        }
    }
    
    func emptyDeviceConfiguration() -> [[Devices]] {
        var devices = [[Devices]]()
        for _ in 0...3 {
            var devicesRow = [Devices]()
            for _ in 0...9 {
                devicesRow.append(.none)
            }
            devices.append(devicesRow)
        }
        return devices
    }
    
    @objc func startTimer() {
        cultivationCycleCurrentTime += 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timeDidChange"), object: cultivationCycleCurrentTime)
        
        currentParameterConfiguration.forEach { parameter in
            
        }
        
        if cultivationCycleCurrentTime == cultivationCycleDuration * 24 {
            cultivationCycleTimer?.invalidate()
        }
    }
}
