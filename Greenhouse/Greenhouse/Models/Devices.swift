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
    case heater = "heat"
    case sourceOfLight = "sun"
    case conditioner = "ac"
    case humidifier = "water"
    case fertilizerDispenser = "fertilizer"
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
