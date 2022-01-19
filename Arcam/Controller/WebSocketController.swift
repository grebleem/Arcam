//
//  WebSocketController.swift
//  Arcam
//
//  Created by Bastiaan Meelberg on 12/01/2022.
//

import Combine
import Foundation
import Network


final class WebSocketController: ObservableObject {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var arcam = ArcamCodes()
    
    init(hostname: String, port: Int) {
        let host = NWEndpoint.Host(hostname)
        let port = NWEndpoint.Port("\(port)")!
        self.connection = NWConnection(host: host, port: port, using: .tcp)
    }
    
    let connection: NWConnection
    
    func connect() {
        
        NSLog("Start Connection.")
        self.connection.stateUpdateHandler = self.didChange(state:)
        self.startReceive()
        self.connection.start(queue: .main)
//        let url = URL(string: "ws://192.168.1.80:50000")!
//
//        webSocketTask = URLSession.shared.webSocketTask(with: url)
//        webSocketTask?.receive(completionHandler: onReceive)
//        webSocketTask?.resume()
    }
    
    private func didChange(state: NWConnection.State) {
        switch state {
        case .setup:
            break
        case .waiting(let error):
            NSLog("is waiting: %@", "\(error)")
        case .preparing:
            break
        case .ready:
            break
        case .failed(let error):
            NSLog("did fail, error: %@", "\(error)")
            self.stop()
        case .cancelled:
            NSLog("was cancelled")
            self.stop()
        @unknown default:
            break
        }
    }
    
    private func startReceive() {
        self.connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { data, _, isDone, error in
            if let data = data, !data.isEmpty {
                NSLog("did receive, data: %@", data as NSData)
                self.decodeData(data: data)
            }
            if let error = error {
                NSLog("did receive, error: %@", "\(error)")
                self.stop()
                return
            }
            if isDone {
                NSLog("did receive, EOF")
                self.stop()
                return
            }
            self.startReceive()
        }
    }
    
    func stop() {
        self.connection.cancel()
        NSLog("did stop")
    }
    
    private func decodeData(data: Data) { // 4

            print("Received: \(data.count) byte(s).")
            // print(data.bytes)
            //print(String(bytes: data, encoding: .ascii) ?? "")
            
            guard data[0] == 0x21 else { return }
            guard data.last == 0x0D else { return }
            let zoneNumber: UInt8 = data[1] 
            switch zoneNumber {
            case 0x01: print("ZN: 1")
            case 0x02: print("ZN: 2")
            default:
                print("no Zone")
            }
            guard let commandCode = ArcamCodes.CommandEnum(rawValue: data[2]) else {
                print("Command: \(data[2].hexEncodedString()) not implemented.")
                return
            }
            print(String(describing: commandCode))
            
            
            
            let answerCode: UInt8 = data[3]
            
            let dataLenght: UInt8 = data[4]
            
            switch answerCode {
                /*
                  0x00 – Status update.
                  0x82 – Zone Invalid.
                  0x83 – Command not recognised.
                  0x84 – Parameter not recognised.
                  0x85 – Command invalid at this time.1 
                  0x86 – Invalid data length.
                 */
            case 0x00: print("Status update.")
            case 0x82: print("Zone Invalid.")
            case 0x83: print("Command not recognised.")
            case 0x84: print("Parameter not recognised.")
            case 0x85: print("Command invalid at this time.")
            case 0x86: print("Invalid data length.")
            default:
                print("Unkown Answer code.")
            }
            
            print("Dl: \(dataLenght) bytes")
            //let dataParameters = data[5...dataLenght + 4]
            //print(String(bytes: dataParameters, encoding: .ascii) ?? "")
        
        
    }
    
        func codeRC5(_ code: ArcamCodes.rc5) {
        let sendCode:[UInt8] = [ 0x21, 0x01, 0x08, 0x02 ] + arcam.rc5Code(code: code) + [ 0x0D ]
        sendDataToWebsocket(code: sendCode)
    }
    

    
    func sendCommand(_ command: ArcamCodes.CommandEnum) {
        switch command {
            
        case .power:
            sendDataToWebsocket(code: arcam.power)
        case .displayBrightness:
            print("to Do..")
        case .headphones:
            print("to Do..")
        case .fmGenre:
            print("to Do..")
        case .softwareVersion:
            print("to Do..")
        case .restoreFactoryDefaultSettings:
            print("to Do..")
        case .saveRestoreCopySettings:
            print("to Do..")
        case .rc5Command:
            print("to Do..")
        case .displayInformationType:
            print("to Do..")
        case .requestCurrentSource:
            print("to Do..")
        case .headphoneOverride:
            print("to Do..")
        case .selectAnalogDigital:
            print("to Do..")
        case .setRequestVolume:
            print("to Do..")
        case .requestMuteStatus:
            print("to Do..")
        case .directModeStatus:
            print("to Do..")
        case .requestDecodeModeStatas2ch:
            print("to Do..")
        case .requestDecodeModeStatasMCH:
            print("to Do..")
        case .requestRDSinformation:
            print("to Do..")
        case .requestVideoOutputResolution:
            print("to Do..")
        case .requestMenuStatus:
            print("to Do..")
        case .requestTunerPreset:
            print("to Do..")
        case .tune:
            print("to Do..")
        case .requestDABstation:
            print("to Do..")
        case .progTypeCategory:
            print("to Do..")
        case .dlsPDTinfo:
            print("to Do..")
        case .imaxEnhanched:
            print("to Do..")
        case .requestIncomingVideoParameters:
            print("to Do..")
        case .heartbeat:
            print("to Do..")
        }
    }
    
    
    func randomResponse() {
        if let random = arcam.testResponse.randomElement() {
            sendDataToWebsocket(code: random)
        }
        
    }
    
    func sendDataToWebsocket(code: [UInt8]) {
        let data = Data(code)
        self.connection.send(content: data, completion: NWConnection.SendCompletion.contentProcessed { error in
            if let error = error {
                NSLog("did send, error: %@", "\(error)")
                self.stop()
            } else {
                NSLog("did send, data: %@", data as NSData)
            }
        })
    }
    
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension UInt8 {
    func hexEncodedString() -> String {
        return { String(format: "%02hhx", self) }()
    }
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}
