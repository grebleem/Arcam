//
//  ContentView.swift
//  Arcam
//
//  Created by Bastiaan Meelberg on 12/01/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: WebSocketController
    @State var inputHex: String = ""
    @State var outputString: String = ""
    
    @AppStorage("ipAddress")
    
    private var ipAddress = "192.168.1.74"
    
    
    let arcam = ArcamCodes()
    
    var body: some View {
        VStack {
            HStack{
                RoomEqView()
                Button {
                    model.codeRC5(.powerOn)
                } label: {
                    Text("ON")
                }
                Button {
                    model.codeRC5(.PowerOff)
                } label: {
                    Text("OFF")
                }
            }
            .padding()
            
            HStack {
                if let volume = model.volume {
                    Text("\(volume) dB")
                        .bold()
                        .font(.title)
                }
            }
            Button {
                model.sendCommand(.softwareVersion)
            } label: {
                Text("Version")
            }
            Button {
                model.sendCommand(.nowPlayingInformation)
            } label: {
                Text("Info")
            }
            Button {
                model.sendCommand(.power)
            } label: {
                Text("Get State")
            }
            
            HStack{
                HStack {
                    Button {
                        model.codeRC5(.volumeDown)
                    } label: {
                        Text("-")
                    }
                }
                HStack {
                    Button {
                        model.codeRC5(.volumeUp)
                    } label: {
                        Text("+")
                    }
                }
            }
            VStack {
                HStack {
                    TextField("Convert HEX", text: $inputHex)
                    Button("Convert") {
                        //
                        doConvertHex()
                        
                    }
                }
                TextEditor(text: $outputString)
                    .lineLimit(1)
                    .padding()
                    .frame( height: 70)
                    .cornerRadius(25)
                    
                    
            }
            .padding()
        }
        .frame(minWidth: 800, minHeight: 400)
        .onAppear {
            model.connect()
        }
        .onDisappear {
            //model.stop()
        }
    }
    
    
    func doConvertHex() {
        print(inputHex)
        outputString = "[ " + inputHex.replacingOccurrences(of: " ", with: ", ").replacingOccurrences(of: "\n", with: ", ") + " ]"
    }
}

struct ContentView_Previews: PreviewProvider {
    static let myEnvObject = WebSocketController(hostname: "192.168.1.80", port: 50000)
    static var previews: some View {
        ContentView()
            .environmentObject(myEnvObject)
    }
}
