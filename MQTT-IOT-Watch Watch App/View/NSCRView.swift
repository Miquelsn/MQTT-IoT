//
//  NSCR.swift
//  MQTT-IoT
//
//  Created by Miquel Sitges Nicolau on 4/2/24.
//

import SwiftUI

struct NSCRView: View {
    @Environment(MQTT.self) var mqtt
    
    var body: some View {
        ScrollView{
            ForEach(Array(mqtt.nscr.valores.enumerated()), id: \.element) { index, valor in
                VStack(){
                    Text("\(index + 1)º")
                    Text(valor.nombre)
                    Text(String(valor.consumo)+"Wh")
                }
                .foregroundColor(Color(uiColor: UIColor.blend(color1: UIColor.green, intensity1: CGFloat(1-index/2), color2: UIColor.red, intensity2: CGFloat(index))))
            }
            
                
                Button("Actualizacion"){
                    mqtt.solicitud()
                    print(mqtt.nscr.valores)
                    print("hola")
                }.padding(.vertical)
                    .buttonStyle(.borderedProminent)
                Text("Ultima actualizacion datos")
                Text(mqtt.nscr.timestamp)
                
            }
        
    }
}

#Preview {
    let mqtt = MQTT()
    mqtt.nscr.valores=[HouseData(nombre: "ABC", consumo: 100),HouseData(nombre: "CD", consumo: 100)]
    return NSCRView()
        .environment(mqtt)
        .previewDevice(PreviewDevice(rawValue: "Apple Wacth Series 55 (44mm)"))
}
extension UIColor {
    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2}
        guard l2 > 0 else { return color1}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}
