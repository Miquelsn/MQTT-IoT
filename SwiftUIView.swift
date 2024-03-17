//
//  SwiftUIView.swift
//  MQTT-IoT
//
//  Created by Miquel Sitges Nicolau on 29/12/23.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var users = ["Paul", "Taylor", "Adele"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(users, id: \.self) { user in
                    Text(user)
                }
                .onMove(perform: move)
            }.environment(\.editMode, Binding.constant(EditMode.active))
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        users.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    SwiftUIView()
}
