import Foundation
import Cocoa

final class CultivationCycleManager: NSObject {
    var modifiedDevices: [IndexPath] = []
    
    var greenhouseAverageTemperature: Double = 0
    var greenhouseAverageHumidity: Double = 0
    var greenhouseAverageAcidity: Double = 0
    
    var cultivationCycleTimer: Timer?
    var cultivationCycleDuration = 1
    var cultivationCycleCurrentTime = 0
    var cultivationCycleCurrentDate: String = ""
    var currentPlant: Plants = .hibiscus {
        didSet {
            changeConfiguration()
        }
    }
    var currentParameterConfiguration: [Parameter] = []
    var currentDeviceConfiguration: [[Device]] = [[]]
    var isInProcess: Bool = false {
        didSet {
            if isInProcess {
                startCultivationCycle()
            } else {
                stopCultivationCycle()
                resetConfiguration()
            }
        }
    }
    static var shared = CultivationCycleManager()
    
    private override init() {
        super.init()
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        cultivationCycleCurrentDate = formatter.string(from: today)
        changeConfiguration()
    }
    
    @objc func startTimer() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timeDidChange"), object: cultivationCycleCurrentTime)
        modifiedDevices = []
        soilDegradation()
        for i in 0..<currentParameterConfiguration.count {
            checkDevices(parameter: &currentParameterConfiguration[i])
        }
        cultivationCycleCurrentTime += 1
        if cultivationCycleCurrentTime == cultivationCycleDuration * 24 {
            cultivationCycleTimer?.invalidate()
        }
    }
    
    func startCultivationCycle() {
        cultivationCycleTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    }
    
    func stopCultivationCycle() {
        cultivationCycleTimer?.invalidate()
    }
    
    func changeConfiguration() {
        currentParameterConfiguration = []
        currentDeviceConfiguration = emptyDeviceConfiguration()
        
        switch currentPlant {
        case .hibiscus:
            cultivationCycleDuration = 5
            currentParameterConfiguration.append(Parameter(name: "Temperature", value: 32, duration: 100, deviation: 5, startTime: 0))
            currentParameterConfiguration.append(Parameter(name: "Light", value: 1, duration: 50, deviation: 0, startTime: 5))
            currentParameterConfiguration.append(Parameter(name: "Humidity", value: 25, duration: 50, deviation: 7, startTime: 30))
            currentParameterConfiguration.append(Parameter(name: "Acidity", value: 50, duration: 150, deviation: 10, startTime: 50))
                        
            
            currentDeviceConfiguration[1][3] = TemperatureActiveSensor()
            currentDeviceConfiguration[1][6] = TemperaturePassiveSensor()
            currentDeviceConfiguration[2][3] = HumidityPassiveSensor()
            currentDeviceConfiguration[2][6] = HumidityActiveSensor()
            currentDeviceConfiguration[1][0] = AcidityPassiveSensor()
            currentDeviceConfiguration[1][9] = AcidityActiveSensor()
            currentDeviceConfiguration[2][0] = Heater()
            currentDeviceConfiguration[2][9] = Heater()
            currentDeviceConfiguration[0][1] = Conditioner()
            currentDeviceConfiguration[0][8] = Conditioner()
            currentDeviceConfiguration[3][1] = Humidifier()
            currentDeviceConfiguration[3][8] = Humidifier()
            currentDeviceConfiguration[1][1] = FertilizerDispenser()
            currentDeviceConfiguration[1][8] = FertilizerDispenser()
        case .clivia:
            cultivationCycleDuration = 50
            
            currentParameterConfiguration.append(Parameter(name: "Temperature", value: 35, duration: 2, deviation: 40, startTime: 178))
            currentParameterConfiguration.append(Parameter(name: "Humidity", value: 14, duration: 10, deviation: 20, startTime: 8))
            currentParameterConfiguration.append(Parameter(name: "Temperature", value: 35, duration: 76, deviation: 40, startTime: 180))
            
            currentDeviceConfiguration[1][0] = AcidityActiveSensor()
            currentDeviceConfiguration[3][4] = AcidityPassiveSensor()
            currentDeviceConfiguration[3][3] = TemperaturePassiveSensor()
            currentDeviceConfiguration[0][0] = TemperatureActiveSensor()
            currentDeviceConfiguration[2][8] = HumidityActiveSensor()
            currentDeviceConfiguration[3][0] = HumidityPassiveSensor()
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
    
    func resetConfiguration() {
        for i in 0...3 {
            for j in 0...9 {
                switch currentDeviceConfiguration[i][j].deviceType {
                case .heater, .humidifier, .fertilizerDispenser, .conditioner:
                    currentDeviceConfiguration[i][j].isActive = false
                    currentDeviceConfiguration[i][j].observedSensors = [:]
                case .acidityActiveSensor, .acidityPassiveSensor:
                    currentDeviceConfiguration[i][j].currentValue = 34
                case .humidityPassiveSensor, .humidityActiveSensor:
                    currentDeviceConfiguration[i][j].currentValue = 55
                case .temperaturePassiveSensor, .temperatureActiveSensor:
                    currentDeviceConfiguration[i][j].currentValue = 25
                default:
                    break
                }
            }
        }
        for i in 0..<currentParameterConfiguration.count {
            if currentParameterConfiguration[i].isActive {
                currentParameterConfiguration[i].isActive = false
            }
        }
        cultivationCycleCurrentTime = 0
    }
    
    func emptyDeviceConfiguration() -> [[Device]] {
        var devices = [[Device]]()
        for _ in 0...3 {
            var devicesRow = [Device]()
            for _ in 0...9 {
                devicesRow.append(None())
            }
            devices.append(devicesRow)
        }
        return devices
    }
    
    func setAverageValues() {
        var aciditySensorsCount: Double = 0, humiditySensorsCount: Double = 0, temperatureSensorsCount: Double = 0
        var totalAcidity: Double = 0, totalHumidity: Double = 0, totalTemperature: Double = 0
        currentDeviceConfiguration.forEach { deviceArray in
            deviceArray.forEach { device in
                switch device.deviceType {
                case .acidityPassiveSensor, .acidityActiveSensor:
                    aciditySensorsCount += 1
                    totalAcidity += device.currentValue!
                case .humidityPassiveSensor, .humidityActiveSensor:
                    humiditySensorsCount += 1
                    totalHumidity += device.currentValue!
                case .temperaturePassiveSensor, .temperatureActiveSensor:
                    temperatureSensorsCount += 1
                    totalTemperature += device.currentValue!
                default:
                    break
                }
            }
        }
        greenhouseAverageTemperature = totalTemperature / temperatureSensorsCount
        greenhouseAverageAcidity = totalAcidity / aciditySensorsCount
        greenhouseAverageHumidity = totalHumidity / humiditySensorsCount
    }
    
    func checkDevices(parameter: inout Parameter) {
        setAverageValues()
        checkDeviceStart(parameter: &parameter)
        checkDeviceEnd(parameter: &parameter)
        activeSensorsRangeCheck(parameter: parameter)
    }
    
    func activeSensorsRangeCheck(parameter: Parameter) {
        switch parameter.parameterName {
        case "Temperature":
            for i in 0...3 {
                for j in 0...9 {
                    var device = currentDeviceConfiguration[i][j]
                    if device.deviceType == .temperatureActiveSensor {
                        device.isOutOfRange = !(device.currentValue! >= (parameter.value - parameter.deviation)
                            && device.currentValue! <= (parameter.value + parameter.deviation))
                    }
                }
            }
        case "Humidity":
            for i in 0...3 {
                for j in 0...9 {
                    var device = currentDeviceConfiguration[i][j]
                    if currentDeviceConfiguration[i][j].deviceType == .humidityActiveSensor {
                        device.isOutOfRange = device.currentValue! >= parameter.value - parameter.deviation
                        && device.currentValue! <= parameter.value + parameter.deviation
                    }
                }
            }
        case "Acidity":
            for i in 0...3 {
                for j in 0...9 {
                    var device = currentDeviceConfiguration[i][j]
                    if currentDeviceConfiguration[i][j].deviceType == .acidityActiveSensor {
                        device.isOutOfRange = device.currentValue! >= parameter.value - parameter.deviation
                        && device.currentValue! <= parameter.value + parameter.deviation
                    }
                }
            }
        default:
            break
        }
    }
    
    func checkDeviceStart(parameter: inout Parameter) {
        if !parameter.isActive && parameter.startTime == cultivationCycleCurrentTime {
            switch parameter.parameterName {
            case "Temperature":
                if parameter.value > greenhouseAverageTemperature {
                    for i in 0...3 {
                        for j in 0...9 {
                            if currentDeviceConfiguration[i][j].deviceType == .heater {
                                currentDeviceConfiguration[i][j].isActive = true
                                modifiedDevices.append(IndexPath(item: i * 10 + j, section: 0))
                            }
                        }
                    }
                    recalculateSensorsValues(device: .heater, isON: true)
                } else if parameter.value < greenhouseAverageTemperature {
                    for i in 0...3 {
                        for j in 0...9 {
                            if currentDeviceConfiguration[i][j].deviceType == .conditioner {
                                currentDeviceConfiguration[i][j].isActive = true
                                modifiedDevices.append(IndexPath(item: i * 10 + j, section: 0))
                            }
                        }
                    }
                    recalculateSensorsValues(device: .conditioner, isON: true)
                }
            case "Humidity":
                if parameter.value > greenhouseAverageHumidity {
                    for i in 0...3 {
                        for j in 0...9 {
                            if currentDeviceConfiguration[i][j].deviceType == .humidifier {
                                currentDeviceConfiguration[i][j].isActive = true
                                modifiedDevices.append(IndexPath(item: i * 10 + j, section: 0))
                            }
                        }
                    }
                    recalculateSensorsValues(device: .humidifier, isON: true)
                } else if parameter.value < greenhouseAverageTemperature {
                    for i in 0...3 {
                        for j in 0...9 {
                            if currentDeviceConfiguration[i][j].deviceType == .heater {
                                currentDeviceConfiguration[i][j].isActive = true
                                modifiedDevices.append(IndexPath(item: i * 10 + j, section: 0))
                            }
                        }
                    }
                    recalculateSensorsValues(device: .heater, isON: true)
                }
            case "Acidity":
                if parameter.value > greenhouseAverageAcidity {
                    for i in 0...3 {
                        for j in 0...9 {
                            if currentDeviceConfiguration[i][j].deviceType == .fertilizerDispenser {
                                currentDeviceConfiguration[i][j].isActive = true
                                modifiedDevices.append(IndexPath(item: i * 10 + j, section: 0))
                            }
                        }
                    }
                    recalculateSensorsValues(device: .fertilizerDispenser, isON: true)
                }
            case "Light":
                for i in 0...3 {
                    for j in 0...9 {
                        if currentDeviceConfiguration[i][j].deviceType == .sourceOfLight {
                            currentDeviceConfiguration[i][j].isActive = true
                            modifiedDevices.append(IndexPath(item: i * 10 + j, section: 0))
                        }
                    }
                }
            default:
                break
            }
            parameter.isActive = true
        }
    }
    
    func checkDeviceEnd(parameter: inout Parameter) {
        if parameter.isActive && (parameter.startTime + parameter.duration == cultivationCycleCurrentTime) {
            switch parameter.parameterName {
            case "Temperature":
                for i in 0...3 {
                    for j in 0...9 {
                        if currentDeviceConfiguration[i][j].deviceType == .heater
                            || currentDeviceConfiguration[i][j].deviceType == .conditioner {
                            currentDeviceConfiguration[i][j].isActive = false
                            modifiedDevices.append(IndexPath(item: i * 10 + j, section: 0))
                        }
                    }
                }
                recalculateSensorsValues(device: .heater, isON: false)
                recalculateSensorsValues(device: .conditioner, isON: false)
            case "Humidity":
                for i in 0...3 {
                    for j in 0...9 {
                        if currentDeviceConfiguration[i][j].deviceType == .heater
                            || currentDeviceConfiguration[i][j].deviceType == .humidifier {
                            currentDeviceConfiguration[i][j].isActive = false
                            modifiedDevices.append(IndexPath(item: i * 10 + j, section: 0))
                        }
                    }
                }
                recalculateSensorsValues(device: .heater, isON: false)
                recalculateSensorsValues(device: .humidifier, isON: false)
            case "Acidity":
                for i in 0...3 {
                    for j in 0...9 {
                        if currentDeviceConfiguration[i][j].deviceType == .fertilizerDispenser {
                            currentDeviceConfiguration[i][j].isActive = false
                            modifiedDevices.append(IndexPath(item: i * 10 + j, section: 0))
                        }
                    }
                }
                recalculateSensorsValues(device: .fertilizerDispenser, isON: false)
            case "Light":
                for i in 0...3 {
                    for j in 0...9 {
                        if currentDeviceConfiguration[i][j].deviceType == .sourceOfLight {
                            currentDeviceConfiguration[i][j].isActive = false
                            modifiedDevices.append(IndexPath(item: i * 10 + j, section: 0))
                        }
                    }
                }
            default:
                break
            }
            parameter.isActive = false
        }
    }
    
    func recalculateSensorsValues(device: DeviceType, isON: Bool) {
        var heatersArray: [IndexPath] = []
        var conditionersArray: [IndexPath] = []
        var humidifiersArray: [IndexPath] = []
        var fertilizerDispensersArray: [IndexPath] = []
        
        var temperatureSensorsArray: [IndexPath] = []
        var humiditySensorsArray: [IndexPath] = []
        var aciditySensorsArray: [IndexPath] = []
        
        for i in 0...3 {
            for j in 0...9 {
                switch currentDeviceConfiguration[i][j].deviceType {
                case .heater:
                    heatersArray.append(IndexPath(item: i*10 + j, section: 0))
                case .humidifier:
                    humidifiersArray.append(IndexPath(item: i*10 + j, section: 0))
                case .conditioner:
                    conditionersArray.append(IndexPath(item: i*10 + j, section: 0))
                case .fertilizerDispenser:
                    fertilizerDispensersArray.append(IndexPath(item: i*10 + j, section: 0))
                case .acidityActiveSensor, .acidityPassiveSensor:
                    aciditySensorsArray.append(IndexPath(item: i*10 + j, section: 0))
                case .temperatureActiveSensor, .temperaturePassiveSensor:
                    temperatureSensorsArray.append(IndexPath(item: i*10 + j, section: 0))
                case .humidityActiveSensor, .humidityPassiveSensor:
                    humiditySensorsArray.append(IndexPath(item: i*10 + j, section: 0))
                default:
                    break
                }
            }
        }
        
        switch device {
        case .heater:
            if isON {
                for i in 0..<temperatureSensorsArray.count {
                    for j in 0..<heatersArray.count {
                        let temperature = calculateTemperatureValue(sensor: temperatureSensorsArray[i], device: heatersArray[j])
                        currentDeviceConfiguration[temperatureSensorsArray[i].item / 10][temperatureSensorsArray[i].item % 10].currentValue! += temperature
                        currentDeviceConfiguration[heatersArray[j].item / 10][heatersArray[j].item % 10].observedSensors![temperatureSensorsArray[i]] = temperature
                    }
                }
                for i in 0..<humiditySensorsArray.count {
                    for j in 0..<heatersArray.count {
                        let humidity = calculateHumidityValue(sensor: humiditySensorsArray[i], device: heatersArray[j])
                        currentDeviceConfiguration[humiditySensorsArray[i].item / 10][humiditySensorsArray[i].item % 10].currentValue! -= humidity
                        currentDeviceConfiguration[heatersArray[j].item / 10][heatersArray[j].item % 10].observedSensors![humiditySensorsArray[i]] = humidity
                    }
                }
            } else {
                for j in 0..<heatersArray.count {
                    for sensor in currentDeviceConfiguration[heatersArray[j].item / 10][heatersArray[j].item % 10].observedSensors! {
                        var device = currentDeviceConfiguration[sensor.key.item / 10][sensor.key.item % 10]
                        if device.deviceType == .temperatureActiveSensor || device.deviceType == .temperaturePassiveSensor {
                            device.currentValue! -= sensor.value
                        } else {
                            device.currentValue! += sensor.value
                        }
                        currentDeviceConfiguration[heatersArray[j].item / 10][heatersArray[j].item % 10].observedSensors?.removeValue(forKey: sensor.key)
                    }
                }
            }
            if !heatersArray.isEmpty {
                modifiedDevices.append(contentsOf: temperatureSensorsArray)
                modifiedDevices.append(contentsOf: humiditySensorsArray)
            }
        case .conditioner:
            if isON {
                for i in 0..<temperatureSensorsArray.count {
                    for j in 0..<conditionersArray.count {
                        let temperature = calculateTemperatureValue(sensor: temperatureSensorsArray[i], device: conditionersArray[j])
                        currentDeviceConfiguration[temperatureSensorsArray[i].item / 10][temperatureSensorsArray[i].item % 10].currentValue! -= temperature
                        currentDeviceConfiguration[conditionersArray[j].item / 10][conditionersArray[j].item % 10].observedSensors![temperatureSensorsArray[i]] = temperature
                    }
                }
                for i in 0..<humiditySensorsArray.count {
                    for j in 0..<conditionersArray.count {
                        let humidity = calculateHumidityValue(sensor: humiditySensorsArray[i], device: conditionersArray[j])
                        currentDeviceConfiguration[humiditySensorsArray[i].item / 10][humiditySensorsArray[i].item % 10].currentValue! += humidity
                        currentDeviceConfiguration[conditionersArray[j].item / 10][conditionersArray[j].item % 10].observedSensors![humiditySensorsArray[i]] = humidity
                    }
                }
            } else {
                for j in 0..<conditionersArray.count {
                    for sensor in currentDeviceConfiguration[conditionersArray[j].item / 10][conditionersArray[j].item % 10].observedSensors! {
                        var device = currentDeviceConfiguration[sensor.key.item / 10][sensor.key.item % 10]
                        if device.deviceType == .temperatureActiveSensor || device.deviceType == .temperaturePassiveSensor {
                            device.currentValue! += sensor.value
                        } else {
                            device.currentValue! -= sensor.value
                        }
                        currentDeviceConfiguration[conditionersArray[j].item / 10][conditionersArray[j].item % 10].observedSensors?.removeValue(forKey: sensor.key)
                    }
                }
            }
            if !conditionersArray.isEmpty {
                modifiedDevices.append(contentsOf: temperatureSensorsArray)
                modifiedDevices.append(contentsOf: humiditySensorsArray)
            }
        case .humidifier:
            if isON {
                for i in 0..<humiditySensorsArray.count {
                    for j in 0..<humidifiersArray.count {
                        let humidity = calculateHumidityValue(sensor: humiditySensorsArray[i], device: humidifiersArray[j])
                        currentDeviceConfiguration[humiditySensorsArray[i].item / 10][humiditySensorsArray[i].item % 10].currentValue! += humidity
                        currentDeviceConfiguration[humidifiersArray[j].item / 10][humidifiersArray[j].item % 10].observedSensors![humiditySensorsArray[i]] = humidity
                    }
                }
            } else {
                for j in 0..<humidifiersArray.count {
                    for sensor in currentDeviceConfiguration[humidifiersArray[j].item / 10][humidifiersArray[j].item % 10].observedSensors! {
                        currentDeviceConfiguration[sensor.key.item / 10][sensor.key.item % 10].currentValue! -= sensor.value
                        currentDeviceConfiguration[humidifiersArray[j].item / 10][humidifiersArray[j].item % 10].observedSensors?.removeValue(forKey: sensor.key)
                    }
                }
            }
            if !humidifiersArray.isEmpty {
                modifiedDevices.append(contentsOf: humiditySensorsArray)
            }
        case .fertilizerDispenser:
            if isON {
                for i in 0..<aciditySensorsArray.count {
                    for j in 0..<fertilizerDispensersArray.count {
                        let acidity = calculateAcidityValue(sensor: aciditySensorsArray[i], device: fertilizerDispensersArray[j])
                        currentDeviceConfiguration[aciditySensorsArray[i].item / 10][aciditySensorsArray[i].item % 10].currentValue! += acidity
                        currentDeviceConfiguration[fertilizerDispensersArray[j].item / 10][fertilizerDispensersArray[j].item % 10].observedSensors![aciditySensorsArray[i]] = acidity
                    }
                }
            } else {
                for j in 0..<fertilizerDispensersArray.count {
                    for sensor in currentDeviceConfiguration[fertilizerDispensersArray[j].item / 10][fertilizerDispensersArray[j].item % 10].observedSensors! {
                        currentDeviceConfiguration[sensor.key.item / 10][sensor.key.item % 10].currentValue! -= sensor.value
                        currentDeviceConfiguration[fertilizerDispensersArray[j].item / 10][fertilizerDispensersArray[j].item % 10].observedSensors?.removeValue(forKey: sensor.key)
                    }
                }
            }
        default:
            break
        }
    }
    
    func calculateTemperatureValue(sensor: IndexPath, device: IndexPath) -> Double {
        let distance: Double = sqrt(pow(Double(abs(sensor.item / 10 - device.item / 10)), 2) + pow(Double(abs(sensor.item % 10 - device.item % 10)), 2))
        var temperature: Double = 25
        if distance > 4 {
            temperature = 3
        } else {
            temperature -= 8 * distance
        }
        return temperature
    }
    
    func calculateHumidityValue(sensor: IndexPath, device: IndexPath) -> Double {
        let distance: Double = sqrt(pow(Double(abs(sensor.item / 10 - device.item / 10)), 2) + pow(Double(abs(sensor.item % 10 - device.item % 10)), 2))
        var humidity: Double = 55
        if distance > 4 {
            humidity = 5
        } else {
            humidity -= 10 * distance
        }
        return humidity
    }
    
    func calculateAcidityValue(sensor: IndexPath, device: IndexPath) -> Double {
        let distance: Double = sqrt(pow(Double(abs(sensor.item / 10 - device.item / 10)), 2) + pow(Double(abs(sensor.item % 10 - device.item % 10)), 2))
        var acidity: Double = 34
        if distance > 2 {
            acidity = 1
        } else {
            acidity -= 2 * distance
        }
        return acidity
    }
    
    func soilDegradation() {
        if cultivationCycleCurrentTime % 10 == 0 {
            for i in 0...3 {
                for j in 0...9 {
                    if currentDeviceConfiguration[i][j].deviceType == .acidityActiveSensor || currentDeviceConfiguration[i][j].deviceType == .acidityPassiveSensor {
                        currentDeviceConfiguration[i][j].currentValue! -= 1
                        modifiedDevices.append(IndexPath(item: i*10 + j, section: 0))
                    }
                }
            }
        }
    }
}
