//
//  WebSocketController.swift
//  Arcam
//
//  Created by Bastiaan Meelberg on 12/01/2022.
//

import Combine
import Foundation


final class WebSocketController: ObservableObject {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var arcam = ArcamCodes()
    
    func connect() {
        let url = URL(string: "ws://192.168.1.74:10000")!
        
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>){

        webSocketTask?.receive(completionHandler: onReceive)
        
        if case .success(let message) = incoming { // 2
            onMessage(message: message)
        }
        else if case .failure(let error) = incoming { // 3
            print("Error", error)
        }
    }
    
    private func onMessage(message: URLSessionWebSocketTask.Message) { // 4

        if case .data(let data) = message {
            print("Received: \(data.count) byte(s).")
            print(data.bytes)
            print(String(bytes: data, encoding: .ascii) ?? "")
            
            guard data[0] == 0x21 else { return }
            let zoneNumber: UInt8 = data[1] 
            switch zoneNumber {
            case 0x01: print("zone 1")
            case 0x02: print("zone 2")
            default:
                print("no Zone")
            }
            let command: UInt8 = data[2]
            
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
        
    }
    
    func codeRC5(_ code: ArcamCodes.rc5) {
        let sendCode:[UInt8] = [ 0x21, 0x01, 0x08, 0x02 ] + arcam.rc5Code(code: code) + [ 0x0D ]
        sendDataToWebsocket(code: sendCode)
    }
    
    func sendCommand(_ command: ArcamCodes.command) {
        
    }
    
    func sendDataToWebsocket(code: [UInt8]) {
        let data = Data(code)
        webSocketTask?.send(.data(data)) { error in
            if let error = error {
                print("Error in sending message", error)
            }
        }
    }
    
    func heartBeat() {
        
        // let message: [UInt8] = [0x21, 0x01, 0x25, 0x01, 0xF0, 0x0D]
        
        let data = Data(arcam.testMessage)
        webSocketTask?.send(.data(data)) { error in
            if let error = error {
                print("Error in sending message", error)
            }
        }
    }
    deinit {
        disconnect()
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}
