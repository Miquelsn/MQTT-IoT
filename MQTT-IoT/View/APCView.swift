//
//  APCView.swift
//  MQTT-IoT
//
//  Created by Miquel Sitges Nicolau on 27/12/23.
//

import SwiftUI

struct APCView: View {
    @Bindable var apc: APC
    @Environment(MQTT.self) var mqtt
    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])
    var body: some View {
        VStack{
            Text(apc.name)
                .font(.title)
                
            Gauge(value: apc.currentPower, in: 0...apc.maxEstimatedPower) {
                        Text("Consumo")
                    } currentValueLabel: {
                        Text("\(Int(apc.currentPower))")
                     
                    } minimumValueLabel: {
                        Text("\(Int(0))")
                            .font(.system(size: 8,weight: .bold))
                            .foregroundStyle(.green)
                    } maximumValueLabel: {
                        Text("\(Int(apc.maxEstimatedPower))")
                            .font(.system(size: 8,weight: .bold))
                            .foregroundStyle(.red)
                    }
                    .gaugeStyle(.accessoryCircular)
                    .tint(gradient)
                    .scaleEffect(1.5)
                    .frame(width: 75,height: 75)
            
            Picker("Estado",selection: $apc.estado){
                ForEach(APCEstado.allCases){option in
                    Text(option.description).tag(option.id)
                }

                .onChange(of: apc.estado)
                {
                    mqtt.cambioEstado(data: apc.estado.rawValue, topic: apc.topic)
                }
            }
#if os(watchOS)
            .pickerStyle(.navigationLink)
            .padding(.vertical)
            #endif
            .tint(chooseColor(state: apc.estado))
        }
      
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(chooseColor(state: apc.estado), lineWidth: 1)
        )
       
    }
    func chooseColor(state:APCEstado)->Color{
        switch state{
        case .alwaysOn: return .green
        case .off: return .red
        case .power: return .blue
        }
    }
}

#Preview {
    let apc = APC(name:"Nevera",topic: "nevera/encendido", maxEstimatedPower: 1000)
    let mqtt = MQTT()
    return APCView(apc: apc)
        .environment(mqtt)
}
