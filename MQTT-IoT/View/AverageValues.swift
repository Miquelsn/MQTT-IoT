//
//  AverageValues.swift
//  MQTT-IoT
//
//  Created by Miquel Sitges Nicolau on 9/1/24.
//

import SwiftUI

struct AverageValues: View {
    @Bindable var hpc:HPC
    @Environment(MQTT.self) var mqtt
    
    var body: some View {
        Section("Valores medios"){
            Text("Consumo Medio")
            Text(String(Int(hpc.averagePower))+"W")
            Text("Temperatura Media")
            Text(String(hpc.averageTemp)+"ºC")
        }
    }
}

#Preview {
    AverageValues(hpc: HPC())
        .environment(MQTT())
}
