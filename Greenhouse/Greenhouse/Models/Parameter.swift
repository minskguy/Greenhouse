import Foundation

struct Parameter {
    var parameterName: String
    var value: Double
    var duration: Int
    var deviation: Double
    var startTime: Int
    var isActive: Bool
    
    init() {
        parameterName = ""
        value = 0
        duration = 0
        deviation = 0
        startTime = 0
        isActive = false
    }
    
    init(name: String, value: Double, duration: Int, deviation: Double,
         startTime: Int) {
        self.parameterName = name
        self.value = value
        self.duration = duration
        self.deviation = deviation
        self.startTime = startTime
        self.isActive = false
    }
}
