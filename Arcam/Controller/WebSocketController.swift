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
    
    @Published var volume: Int?
    
    private var zone: UInt8 = 0x01
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
                NSLog("receive: %@", data as NSData)
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
    
    
    // MARK: - Decode the incomming Data
    private func decodeData(data: Data) { // 4
        
        //print("Received: \(data.count) byte(s).")
        // print(data.bytes)
        //print(String(bytes: data, encoding: .ascii) ?? "")
        
        guard data[0] == 0x21 else { return }
        guard data.last == 0x0D else { return }
        let zoneNumber: UInt8 = data[1]
        //
//        switch zoneNumber {
//        case 0x01: print("ZN: 1")
//        case 0x02: print("ZN: 2")
//        default:
//            print("no Zone")
//        }
        guard let commandCode = ArcamCodes.CommandEnum(rawValue: data[2]) else {
            print("Command: \(data[2].hexEncodedString()) [\(data[2])] not implemented.")
            return
        }
        
        let answerCode: UInt8 = data[3]
        
        let dataLenght: UInt8 = data[4]
        guard dataLenght > 0 else { return }
        print(dataLenght)
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
        
        
        let dataParameters = data[5...dataLenght + 4]
            processCommandResponse(command: commandCode, data: dataParameters)
        //print("Dl: \(dataLenght) bytes")
        
        // NSLog("data: %@", dataParameters as NSData)
        //print(String(bytes: dataParameters, encoding: .ascii) ?? "")
        
    }
    
    func codeRC5(_ code: ArcamCodes.rc5) {
        let sendCode:[UInt8] = [ 0x21, 0x01, 0x08, 0x02 ] + arcam.rc5Code(code: code) + [ 0x0D ]
        sendDataToWebsocket(code: sendCode)
    }
    
    func processCommandResponse(command: ArcamCodes.CommandEnum, data: Data) {
        
        guard let dataFirst = data.first else { return }
//            print(data)
        
        switch command {
            
        case .power:
            print(command)
            if data.first == 0x00 {
                print("Power off")
            }
            if data.first == 0x01 {
                print("Power on")
            }
        case .displayBrightness:
            print(String(describing: command))
        case .headphones:
            print(String(describing: command))
        case .fmGenre:
            print(String(describing: command))
        case .softwareVersion:
            print (decodeVersion(data: data) ?? "")
        case .restoreFactoryDefaultSettings:
            print(String(describing: command))
        case .saveRestoreCopySettings:
            print(String(describing: command))
        case .rc5Command:
            print(String(describing: command))
        case .displayInformationType:
            print("Info")
        case .requestCurrentSource:
            print(String(describing: command))
        case .headphoneOverride:
            print(String(describing: command))
        case .selectAnalogDigital:
            print(String(describing: command))
        case .setRequestVolume:
            print("\(data) dB")
            self.volume = Int(dataFirst)
        case .requestMuteStatus:
            print(String(describing: command))
        case .directModeStatus:
            print(String(describing: command))
        case .requestDecodeModeStatus2ch:
            switch data.first {
            case 0x01: print("Stereo")
            case 0x04: print("Dolby Surround ")
            case 0x07: print("Neo:6 Cinema")
            case 0x08: print("Neo:6 Music")
            case 0x09: print("5/7 Ch Stereo")
            case 0x0A: print("DTS Neural:X")
            case 0x0B: print("Reserved")
            case 0x0C: print("DTS Virtual:X")
            case 0x0D: print("Dolby Virtual Height ")
            case 0x0E: print("Auro Native")
            case 0x0F: print("Auro-Matic 3D")
            case 0x10: print("Auro-2D")
            default:
                return
            }
        case .requestDecodeModeStatasMCH:
            print(String(describing: command))
        case .requestRDSinformation:
            print(String(describing: command))
        case .requestVideoOutputResolution:
            print(String(describing: command))
        case .requestMenuStatus:
            print(String(describing: command))
        case .requestTunerPreset:
            print(String(describing: command))
        case .tune:
            print(String(describing: command))
        case .requestDABstation:
            print(String(describing: command))
        case .progTypeCategory:
            print(String(describing: command))
        case .dlsPDTinfo:
            print(String(describing: command))
        case .imaxEnhanched:
            print(String(describing: command))
        case .requestIncomingVideoParameters:
            print(String(describing: command))
        case .heartbeat:
            print(String(describing: command))
        case .trebleEqualisation:
            print(String(describing: command))
        case .bassEqualisation:
            print(String(describing: command))
        case .roomEqualisation:
            print(String(describing: command))
        case .dolbyAudio:
            print(String(describing: command))
        case .balance:
            print(String(describing: command))
        case .subwooferTrim:
            print(String(describing: command))
        case .lipsyncDelay:
            print(String(describing: command))
        case .compression:
            print(String(describing: command))
        case .requestIncomingAudioFormat:
            switch dataFirst {
            case 0x00: print("PCM")
            case 0x01: print("Analogue Direct")
            case 0x02: print("Dolby Digital")
            case 0x03: print("Dolby Digital EX")
            case 0x04: print("Dolby Digital Surround ")
            case 0x05: print("Dolby Digital Plus")
            case 0x06: print("Dolby Digital True HD")
            case 0x07: print("DTS")
            case 0x08: print("DTS 96/24")
            case 0x09: print("DTS ES Matrix")
            case 0x0A: print("DTS ES Discrete")
            case 0x0B: print("DTS ES Matrix 96/24 ")
            case 0x0C: print("DTS ES Discrete 96/24 ")
            case 0x0D: print("DTS HD Master Audio ")
            case 0x0E: print("DTS HD High Res Audio ")
            case 0x0F: print("DTS Low Bit Rate")
            case 0x10: print("DTS Core")
            case 0x13: print("PCM Zero")
            case 0x14: print("Unsupported")
            case 0x15: print("Undetected")
            case 0x16: print("Dolby Atmos")
            case 0x17: print("DTS:X")
            case 0x18: print("IMAX ENHANCED")
            case 0x19: print("Auro 3D")

            default:
                return
            }
        case .requestIncomingAudioSampleRate:
            print(getSampleRate(data: dataFirst))
        case .requestSubStereoTrim:
            print(String(describing: command))
        case .roomEQnames:
            guard let string = String(data: data, encoding: .utf8) else { return }
            print(string)
            
            print(data)
        case .nowPlayingInformation:
            
            guard let string = String(data: data, encoding: .utf8) else { return }
            print(string)
            
        }
    }
    
    
    func requestStatus(command: ArcamCodes.CommandEnum, data: [UInt8]) {
        print(UInt8(16))
        let sendCode:[UInt8] = [ 0x21, zone, command.rawValue ] + [ UInt8(data.count) ] + data +  [ 0x0D ]
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
            requestStatus(command: ArcamCodes.CommandEnum.softwareVersion, data: [0xF1])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.softwareVersion, data: [0xF2])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.softwareVersion, data: [0xF3])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.softwareVersion, data: [0xF4])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.softwareVersion, data: [0xF5])
            }
        case .restoreFactoryDefaultSettings:
            print("to Do..")
        case .saveRestoreCopySettings:
            print("to Do..")
        case .rc5Command:
            print("to Do..")
        case .displayInformationType:
            requestStatus(command: ArcamCodes.CommandEnum.displayInformationType, data: [0xF0])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.displayInformationType, data: [0xF2])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.displayInformationType, data: [0x03])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.displayInformationType, data: [0x04])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.displayInformationType, data: [0x05])
            }
            
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
        case .requestDecodeModeStatus2ch:
            print("to Do..")
        case .requestDecodeModeStatasMCH:
            print("to Do..")
        case .trebleEqualisation:
            print("To Do")
        case .bassEqualisation:
            print("To Do")
        case .roomEqualisation:
            requestStatus(command: ArcamCodes.CommandEnum.roomEqualisation, data: [0xF0])
        case .dolbyAudio:
            print("To Do")
        case .balance:
            print("To Do")
        case .subwooferTrim:
            print("To Do")
        case .lipsyncDelay:
            print("To Do")
        case .compression:
            print("To Do")
        case .requestIncomingAudioFormat:
            print("To Do")
        case .requestIncomingAudioSampleRate:
            print("To Do")
        case .requestSubStereoTrim:
            print("To Do")
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

        case .roomEQnames:
            requestStatus(command: ArcamCodes.CommandEnum.roomEQnames, data: [0xF0])
            
        case .nowPlayingInformation:
            requestStatus(command: ArcamCodes.CommandEnum.nowPlayingInformation, data: [0xF0])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.nowPlayingInformation, data: [0xF1])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.nowPlayingInformation, data: [0xF2])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.nowPlayingInformation, data: [0xF3])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                // your code here
                self.requestStatus(command: ArcamCodes.CommandEnum.nowPlayingInformation, data: [0xF4])
            }
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
                NSLog("Send, data: %@", data as NSData)
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

func getSampleRate(data: UInt8) -> String {
    switch data {
    case 0x00: return "32 kHz"
    case 0x01: return "44.1 kHz"
    case 0x02: return "48 kHz"
    case 0x03: return "88.2 kHz"
    case 0x04: return "32 kHz"
    case 0x05: return "176.4 kHz"
    case 0x06: return "192 kHz"
    case 0x07: return "Unkown"
    case 0x08: return "Undetected"

    default:
        return ""
    }
}

func decodeVersion(data: Data) -> String? {
    
    guard let majorVersion = String(data: data, encoding: .utf8) else { return nil }
    guard let minorVersion = String(data: data, encoding: .utf8) else { return nil }
            
    switch data.first {
    case 0xF0: do {
        let returnString = String(format:"RS232: %@", data[1])
        return returnString
    }
    case 0xF1: do {
        let returnString = String(format:"Host: %@.%@", majorVersion, minorVersion)
        return returnString
    }
    case .none:
        return nil
    case .some(_):
        return nil
    }
    
}
