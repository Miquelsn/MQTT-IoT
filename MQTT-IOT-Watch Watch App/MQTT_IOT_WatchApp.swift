//
//  MQTT_IOT_WatchApp.swift
//  MQTT-IOT-Watch Watch App
//
//  Created by Miquel Sitges Nicolau on 3/2/24.
//

import SwiftUI

@main
struct MQTT_IOT_Watch_Watch_AppApp: App {
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

