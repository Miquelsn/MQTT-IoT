//
//  ContentView.swift
//  MQTT-IoT
//
//  Created by Miquel Sitges Nicolau on 24/12/23.
//
import SwiftUI

struct ContentView: View {
    @Environment(MQTT.self) var mqtt
    @State private var texto:String=""
    var body: some View {
        GeometryReader { geomentry in
            VStack {
                    if(mqtt.estado == .desconectado){
                        Button("Conecta al servidor MQTT"){
                            mqtt.connect()
                        }
                    }
                    if(mqtt.estado == .conectado)
                {
                        TabView{
#if !os(watchOS)
                            if(geomentry.size.width<150*4 && geomentry.size.height>170*2){
                                LazyVGrid(columns:[GridItem(.adaptive(minimum: 150, maximum: 500))]) {
                                    ForEach(mqtt.apc,id: \.id){
                                        APCView(apc: $0)
                                    }
                                }
                                .tabItem {
                                    Label("Actuales", systemImage: "house.fill")
                                }
                            }
                            else
                            {
                                HStack{
                                    ForEach(mqtt.apc,id: \.id){
                                        APCView(apc: $0)
                                            .padding(.horizontal)
                                    }
                                }
                                .tabItem {
                                    Label("Actuales", systemImage: "house.fill")
                                }
                            }
#endif
#if os(watchOS)
                            
                            ScrollView(){
                                ForEach(mqtt.apc,id: \.id){
                                    APCView(apc: $0)
                                        .frame(width: geomentry.size.width*0.8,height: geomentry.size.width)
                                        .padding(.vertical,15)
                                }
                                
                                
                            }
                            .tabItem {
                                Label("Actuales", systemImage: "house.fill")
                            }
                            
#endif
                            
                            Form{
                                PowerSaveView(hpc: mqtt.hpc)
                                AverageValues(hpc: mqtt.hpc)
                            }
                            .tabItem {
                                Label("Ahorro Energia", systemImage: "bolt.circle")
                            }
                            
                            NSCRView()
                                .tabItem {
                                    Label("Ranking",systemImage: "1.circle")
                                }
                        }
                        .tint(.green)
                        .onAppear(){
                            mqtt.suscribeAllTopics()
                        }
                        .environment(mqtt)
#if os(watchOS)
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        
#endif
                    }

            }
        }
    }
}


#Preview {
    let mqtt = MQTT()
    return ContentView()
        .environment(mqtt)
        .previewDevice("iPhone 15 Pro")
}
#Preview {
    let mqtt = MQTT()
    return ContentView()
        .environment(mqtt)
    
}


