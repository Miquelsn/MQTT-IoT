//
//  PowerSaveView.swift
//  MQTT-IoT
//
//  Created by Miquel Sitges Nicolau on 29/12/23.
//

import SwiftUI

struct PowerSaveView: View {
    @Bindable var hpc:HPC
    @Environment(MQTT.self) var mqtt
    var body: some View {
        Section(header:Text("Umbrales")){
            Text("Umbral Maximo: \(Int(hpc.threhold))W")
#if os(watchOS)
            
            Slider(value: $hpc.threhold,in: 0...3000,step: 50,
                    minimumValueLabel: Text("-"),
                   
                   maximumValueLabel: Text("+"),label:{
                Text("Umbral Maximo")
            } )
            .onChange(of: hpc.threhold){
 
                mqtt.send(data: String(Int(hpc.threhold)), topic: "umbralMaximo")
            }
            
            
#endif
#if !os(watchOS)
            
            Slider(value: $hpc.threhold,in: 0...3000,step: 50,
                   onEditingChanged: { editing in
                if(editing==false)
                {
                    mqtt.send(data: String(Int(hpc.threhold)), topic: "umbralMaximo")
                }
                
            }, minimumValueLabel: Text("0W"),
                   
                   maximumValueLabel: Text("3000W"),label:{
                Text("Umbral Maximo")
            } )
            .padding(.horizontal)
            
#endif
        }
        Section(header:Text("Orden de Prioridad")){
            ForEach($hpc.prioridad, id: \.self,editActions: .move){prioridad in
                HStack{
                    Text(prioridad.wrappedValue)
                    Spacer()
                    Image(systemName: "line.3.horizontal")
                }
                
            }
            .onMove(perform: move)
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        hpc.prioridad.move(fromOffsets: source, toOffset: destination)
        var aux_prioridad=""
        for pri in hpc.prioridad
        {
            aux_prioridad+=pri+"/n"
        }
        mqtt.send(data: aux_prioridad, topic: "prioridad")
    }
}

#Preview {
    PowerSaveView(hpc: HPC())
        .environment(MQTT())
    
}


