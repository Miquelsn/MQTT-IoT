//
//  MQTT_IoT_macApp.swift
//  MQTT-IoT-mac
//
//  Created by Miquel Sitges Nicolau on 12/2/24.
//

import SwiftUI


@main
struct MQTT_IoTmacAPP: App {
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
