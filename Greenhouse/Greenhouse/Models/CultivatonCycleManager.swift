//
//  CultivatonCycleManager.swift
//  Greenhouse
//
//  Created by Марк Курлович on 12/4/20.
//  Copyright © 2020 Марк Курлович. All rights reserved.
//

import Foundation
import Cocoa

final class CultivationCycleManager {
    var isInProcess: Bool = false {
        didSet {
            if isInProcess {
                startCycle()
            }
        }
    }
    static var shared = CultivationCycleManager()
    
    func startCycle() {
        
    }
}
