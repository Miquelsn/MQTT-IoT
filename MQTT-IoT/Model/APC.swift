//
//  APC.swift
//  MQTT-IoT
//
//  Created by Miquel Sitges Nicolau on 27/12/23.
//

import Foundation

@Observable class APC{
    init(name: String = "", topic: String = "", maxEstimatedPower:Float, estado: APCEstado = APCEstado.off) {
        self.name = name
        self.topic = topic
        self.estado = estado
        self.maxEstimatedPower=maxEstimatedPower
    }
    var name=""
    var topic=""
    var estado=APCEstado.off
    var currentPower:Float=0
    var maxEstimatedPower:Float=100
    let id=UUID()
}

enum APCEstado:String, CaseIterable, Identifiable{
    case alwaysOn
    case off
    case power
    var id: Self { self }
    var description:String{
        switch self {
        case .alwaysOn:
            return "Siempre Encendido"
        case .off:
            return "Siempre Apagado"
        case .power:
            return "Ahorro de Energia"
        
        }
    }
}
