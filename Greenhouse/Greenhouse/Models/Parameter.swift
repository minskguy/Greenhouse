//
//  Parameter.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/4/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Foundation

final class Parameter {
    var parameterName: String = ""
    var value: Int = 0
    var duration: Int = 0
    var deviation: Double = 0
    var startTime: Int = 0
    
    init(name: String, value: Int, duration: Int, deviation: Double,
         startTime: Int) {
        self.parameterName = name
        self.value = value
        self.duration = duration
        self.deviation = deviation
        self.startTime = startTime
    }
}
