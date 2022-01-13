//
//  ContentView.swift
//  Arcam
//
//  Created by Bastiaan Meelberg on 12/01/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: WebSocketController
    
    @AppStorage("ipAddress")
    
    
    private var ipAddress = "192.168.1.74"
    
    
    let arcam = ArcamCodes()
    
    var body: some View {
        VStack {
            Button {
                model.heartBeat()
            } label: {
                Text("Power")
            }
            
            VStack{
                HStack {
                    Button {
                        model.codeRC5(.one)
                    } label: {
                        Text("1")
                    }

                }
            }
        }
        .frame(minWidth: 700, minHeight: 300)
        .onAppear {
            model.connect()
        }
        .onDisappear {
            model.disconnect()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let myEnvObject = WebSocketController()
    static var previews: some View {
        ContentView()
            .environmentObject(myEnvObject)
    }
}
