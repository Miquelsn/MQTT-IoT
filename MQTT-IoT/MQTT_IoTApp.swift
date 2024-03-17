//
//  MQTT_IoTApp.swift
//  MQTT-IoT
//
//  Created by Miquel Sitges Nicolau on 24/12/23.
//

import SwiftUI

@main
struct MQTT_IoTApp: App {
    @State var mqtt=MQTT()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(){
                    mqtt.connect()
                }
                .environment(mqtt)
        }
        
    }
}
