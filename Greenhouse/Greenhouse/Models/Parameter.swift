//
//  Parameter.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/4/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Foundation

struct Parameter {
    var parameterName: String
    var value: Int
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
    
    init(name: String, value: Int, duration: Int, deviation: Double,
         startTime: Int) {
        self.parameterName = name
        self.value = value
        self.duration = duration
        self.deviation = deviation
        self.startTime = startTime
        self.isActive = false
    }
}
