//
//  MQTT.swift
//  MQTT_Example
//
//  Created by Miquel Sitges Nicolau on 21/12/23.
//

import SwiftUI
import MQTTNIO
import Observation

@Observable class MQTT{
    var apc:[APC]=[APC(name:"Nevera",topic: "nevera",maxEstimatedPower:600),APC(name:"Lavadora",topic: "lavadora",maxEstimatedPower:1400),APC(name:"Television",topic: "television",maxEstimatedPower:500),APC(name:"ESP32",topic: "ESP32",maxEstimatedPower:10)]
    let topics=["umbralMaximo","prioridad","lavadora/consumoActual","television/consumoActual","nevera/consumoActual","ESP32/consumoActual","consumoMedio","temperaturaMedia","lavadora/estado","television/estado","nevera/estado","ESP32/estado","NSCR/timestamp","NSCR/valores"]
    var hpc=HPC()
    var nscr=NSCR()
    let client = MQTTClient(
        configuration: .init(
            //Introduce the name of the host
            target: .host("broker.hivemq.com", port: 1883),
            protocolVersion: .version3_1_1
        ),
        eventLoopGroupProvider: .createNew
    )
    var estado=Estado.desconectado
    func connect() {
        
        client.connect()
        client.whenConnected { response in
            self.estado=Estado.conectado
        }
        client.whenDisconnected { reason in
            self.estado=Estado.desconectado
        }
        
        client.whenMessage { message in
            let topic=message.topic.replacingOccurrences(of: "MUSI-IoT-2023-24/casaAlcudia/", with: "")
            switch topic{
            case "umbralMaximo":
                self.hpc.threhold=Float(message.payload.string ?? "Error decodificando") ?? 0
            case "prioridad":
                self.hpc.prioridad=message.payload.string!.components(separatedBy: "/n")
                self.hpc.prioridad.removeLast()
            case "nevera/consumoActual":
                self.apc[0].currentPower=Float(message.payload.string ?? "Error decodificando") ?? 0
            case "lavadora/consumoActual":
                self.apc[1].currentPower=Float(message.payload.string ?? "Error decodificando") ?? 0
            case "television/consumoActual":
                self.apc[2].currentPower=Float(message.payload.string ?? "Error decodificando") ?? 0
            case "ESP32/consumoActual":
                self.apc[3].currentPower=Float(message.payload.string ?? "Error decodificando") ?? 0
            case "consumoMedio":
                self.hpc.averagePower=Float(message.payload.string ?? "Error decodificando") ?? 0
            case "temperaturaMedia":
                self.hpc.averageTemp=Float(message.payload.string ?? "Error decodificando") ?? 0
                self.hpc.averageTemp=Float(round(10 * self.hpc.averageTemp) / 10)
            case "nevera/estado":
                self.apc[0].estado=APCEstado(rawValue: (message.payload.string ?? "Error decodificando" )) ?? APCEstado.off
            case "lavadora/estado":
                self.apc[1].estado=APCEstado(rawValue: (message.payload.string ?? "Error decodificando" )) ?? APCEstado.off
            case "television/estado":
                self.apc[2].estado=APCEstado(rawValue: (message.payload.string ?? "Error decodificando" )) ?? APCEstado.off
            case "ESP32/estado":
                self.apc[3].estado=APCEstado(rawValue: (message.payload.string ?? "Error decodificando" )) ?? APCEstado.off
            case "NSCR/timestamp":

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let formattedString = dateFormatter.string(from:Date(timeIntervalSince1970: TimeInterval(Double(message.payload.string ?? "0")!/1000)))
                self.nscr.timestamp = formattedString
            case "NSCR/valores":
                let aux = message.payload.string ?? "Error decodificando"
                // Convert JSON string to data
                if let jsonData = aux.data(using: .utf8) {
                    do {
                        // Decode JSON data into an array of HouseData structs
                        self.nscr.valores = try JSONDecoder().decode([HouseData].self, from: jsonData)
                        // Sort the array in descending order based on "consumo"
                        self.nscr.valores.sort { $0.consumo < $1.consumo }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else {
                    print("Invalid JSON data string")
                }
 
                
            default:
                print("No detectado")
            }
        }
    }
    
    func send(data:String,topic:String) {
        let completeTopic="MUSI-IoT-2023-24/casaAlcudia/"+topic
        client.publish(data,to: completeTopic,qos: .atLeastOnce,retain: true)
    }
    
    func suscribe(topic:String){
        let completeTopic="MUSI-IoT-2023-24/casaAlcudia/"+topic
        client.subscribe(to: completeTopic)
    }
    
    func cambioEstado(data:String,topic:String){
        let completeTopic=topic+"/estado"
        self.send(data: data, topic: completeTopic)
    }
    
    func solicitud()
    {
        let completeTopic="NSCR/solicitud"
        self.send(data: String(Date.currentTimeStamp), topic: completeTopic)
    }
    func suscribeAllTopics(){
        for topic in topics {
            self.suscribe(topic: topic)
        }
    }
}


enum Estado:String {
    case conectado
    case desconectado
}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
