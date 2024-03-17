//
//  NSCR.swift
//  MQTT-IoT
//
//  Created by Miquel Sitges Nicolau on 4/2/24.
//

import Foundation
@Observable class NSCR{
    var timestamp:String=""
    var valores:[HouseData]=[]
}

struct HouseData: Codable,Identifiable,Hashable {
    let nombre: String
    let consumo: Int
    let id = UUID()
}
