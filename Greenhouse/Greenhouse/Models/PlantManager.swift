//
//  PlantManager.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/15/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Foundation

class PlantManager {
    
    func getParametersConfiguration(plantName: String) -> [Parameter] {
        var parameters = [Parameter]()
        switch plantName {
        case "Rose":
            parameters.append(Parameter(name: "Temperature", value: 35, duration: 46, deviation: 10, startTime: 78))
            parameters.append(Parameter(name: "Humidity", value: 14, duration: 10, deviation: 20, startTime: 8))
            parameters.append(Parameter(name: "Light", value: 1, duration: 28, deviation: 0, startTime: 10))
        case "Chamomile":
            parameters.append(Parameter(name: "Temperature", value: 35, duration: 2, deviation: 40, startTime: 178))
            parameters.append(Parameter(name: "Humidity", value: 14, duration: 10, deviation: 20, startTime: 8))
            parameters.append(Parameter(name: "Temperature", value: 35, duration: 76, deviation: 40, startTime: 180))
        case "Sunflower":
            parameters.append(Parameter(name: "Humidity", value: 14, duration: 10, deviation: 20, startTime: 8))
            parameters.append(Parameter(name: "Humidity", value: 50, duration: 23, deviation: 20, startTime: 19))
            
        case "Iris":
            parameters.append(Parameter(name: "Temperature", value: 21, duration: 46, deviation: 10, startTime: 78))
            parameters.append(Parameter(name: "Light", value: 1, duration: 28, deviation: 0, startTime: 10))
            parameters.append(Parameter(name: "Humidity", value: 6, duration: 10, deviation: 20, startTime: 8))
        case "Tulips":
            parameters.append(Parameter(name: "Temperature", value: 35, duration: 46, deviation: 10, startTime: 78))
            parameters.append(Parameter(name: "Humidity", value: 14, duration: 10, deviation: 20, startTime: 8))
            parameters.append(Parameter(name: "Light", value: 1, duration: 28, deviation: 0, startTime: 10))
        case "Lilies":
            parameters.append(Parameter(name: "Temperature", value: 35, duration: 46, deviation: 10, startTime: 78))
            parameters.append(Parameter(name: "Humidity", value: 14, duration: 10, deviation: 20, startTime: 8))
            parameters.append(Parameter(name: "Light", value: 1, duration: 28, deviation: 0, startTime: 10))
        default:
            break
        }
        return parameters
    }
}
