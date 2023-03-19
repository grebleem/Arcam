//
//  ContentView.swift
//  Arcam iOS
//
//  Created by Bastiaan Meelberg on 19/03/2023.
//

import SwiftUI

enum ButtonName: String {
    case mute = "Mute"
    case power = "Power"
}

struct ContentView: View {
    @EnvironmentObject var model: WebSocketController
    
    var body: some View {
        VStack {
            Button {
                model.sendCommand(.softwareVersion)
            } label: {
                Text("Version")
            }
            Button {
                model.codeRC5(.muteOn)
            } label: {
                Text("Mute On")
                    .font(.headline)
            }
            .frame(minWidth: 200, minHeight: 44)
            .background(model.buttonPool.contains(.mute) ? .red : .blue)
            .opacity(0.8)
            .clipShape(Capsule())
            .foregroundColor(.white)
            Button {
                model.codeRC5(.muteOff)
            } label: {
                Text("Mute Off")
                    .font(.headline)
            }
            .frame(minWidth: 200, minHeight: 44)
            .background(model.buttonPool.contains(.mute) ? .red : .blue)
            .opacity(0.8)
            .clipShape(Capsule())
            .foregroundColor(.white)
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let myEnvObject = WebSocketController(hostname: "192.168.1.80", port: 50000)
        ContentView()
            .environmentObject(myEnvObject)
    }
}
