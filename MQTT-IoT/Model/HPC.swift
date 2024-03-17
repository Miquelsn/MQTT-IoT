//
//  HPC.swift
//  MQTT-IoT
//
//  Created by Miquel Sitges Nicolau on 29/12/23.
//

import Foundation
@Observable class HPC{
    var threhold:Float=0
    var prioridad:[String]=["APC1","APC2","APC3","APC4"]
    var averageTemp:Float=0
    var averagePower:Float=0
}

