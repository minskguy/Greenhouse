//
//  DeviceInfo.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/3/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Cocoa

enum Devices: String, CaseIterable {
    case none = ""
    case heater = "heater"
    case sourceOfLight = "sourceOfLight"
    case conditioner = "conditioner"
    case humidifier = "humidifer"
    case fertilizerDispenser = "fertilizerDispenser"
    case acidityPassiveSensor = "acidityPassiveSensor"
    case humidityPassiveSensor = "humidityPassiveSensor"
    case temperaturePassiveSensor = "temperaturePassiveSensor"
    case acidityActiveSensor = "acidityActiveSensor"
    case humidityActiveSensor = "humidityActiveSensor"
    case temperatureActiveSensor = "temperatureActiveSensor"
    
    func getImage() -> NSImage? {
        return NSImage(named: self.rawValue)
    }
}
