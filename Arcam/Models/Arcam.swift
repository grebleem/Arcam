//
//  Arcam.swift
//  Arcam
//
//  Created by Bastiaan Meelberg on 12/01/2022.
//

import Foundation


struct ArcamCodes {
    
    enum code: UInt8 {
        case start = 0x21
        case zone1 = 0x01
        case zone2 = 0x02
        case end = 0x0D
        
    }
    struct data {
        enum power: UInt8 {
            case requestPowerState = 0xF0
        }
        enum displayBrightness: UInt8 {
            case requestBrightness = 0xF0
        }
        
        enum softwareVersion: UInt8 {
            case requestRS232 = 0xF0
            case requestHost = 0xF1
            case requestOSD = 0xF3
            case requestNET = 0xF4
            case requestIAP = 0xF5
        }
    }
    
    enum CommandEnum: UInt8 {
        case power = 0x00
        case displayBrightness = 0x01
        case headphones = 0x02
        case fmGenre = 0x03
        case softwareVersion = 0x04
        case restoreFactoryDefaultSettings = 0x05
        case saveRestoreCopySettings = 0x06
        case rc5Command = 0x08
        case displayInformationType = 0x09
        case requestCurrentSource = 0x1D
        case headphoneOverride = 0x1F
        case selectAnalogDigital = 0x0B
        case setRequestVolume = 0x0D
        case requestMuteStatus = 0x0E
        case directModeStatus = 0x0F
        case requestDecodeModeStatus2ch = 0x10
        case requestDecodeModeStatasMCH = 0x11
        case requestRDSinformation = 0x12
        case requestVideoOutputResolution = 0x13
        case requestMenuStatus = 0x14
        case requestTunerPreset = 0x15
        case tune = 0x16
        case requestDABstation = 0x18
        case progTypeCategory = 0x19
        case dlsPDTinfo = 0x1A
        case imaxEnhanched = 0x0C
        case trebleEqualisation = 0x35
        case bassEqualisation = 0x36
        case roomEqualisation = 0x37
        case dolbyAudio = 0x38
        case balance = 0x3B
        case subwooferTrim = 0x3F
        case lipsyncDelay = 0x40
        case compression = 0x41
        case requestIncomingVideoParameters = 0x42
        case requestIncomingAudioFormat = 0x43
        case requestIncomingAudioSampleRate = 0x44
        case requestSubStereoTrim = 0x45
        case roomEQnames = 0x34
        // TO DO
        
        case nowPlayingInformation = 0x64
        case heartbeat = 0x25
    }
    
    enum rc5 {
        case standby, eject, one, two, three, four, five, six, seven, eight, nine
        case volumeUp, volumeDown
        case powerOn, PowerOff
        //case sync, zero, info, rewind, fastForward, stop, pause, play, disc, menu
        
    }
    
    func rc5Code(code: rc5) -> [UInt8] {
        
        switch code {
        case .standby:
            return [ 0x10, 0x0C ]
        case .eject:
            return [ 0x10, 0x2D ]
        case .one:
            return [ 0x10, 0x01 ]
        case .two:
            return [ 0x10, 0x02 ]
        case .three:
            return [ 0x10, 0x03 ]
        case .four:
            return [ 0x10, 0x04 ]
        case .five:
            return [ 0x10, 0x05 ]
        case .six:
            return [ 0x10, 0x06 ]
        case .seven:
            return [ 0x10, 0x07 ]
        case .eight:
            return [ 0x10, 0x08 ]
        case .nine:
            return [ 0x10, 0x09 ]
        
            
        case .volumeUp:
            return [ 0x10, 0x10 ]
        case .volumeDown:
            return [ 0x10, 0x11]
        case .powerOn:
            return [ 0x10, 0x7B ]
        case .PowerOff:
            return [ 0x10, 0x7C ]
        }
    }
    
    let power:[UInt8] = [0x21, 0x01, 0x00, 0x01, 0xF0, 0x0D]
    let displayBrightness:[UInt8] = [0x21, 0x01, 0x01, 0x01, 0xF0, 0x0D]
    let testMessage: [UInt8] = [0x21, 0x01, 0x19, 0x00, 0x10, 0x50, 0x4F, 0x50, 0x20, 0x4D, 0x55, 0x53, 0x49, 0x43, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x0D]
    
    
    let testResponse: [[UInt8]] = [
    [ 0x21, 0x01, 0x04, 0x00, 0x03, 0xF0, 0x01, 0x04, 0x0D ],
    [ 0x21, 0x01, 0x03, 0x00, 0x09, 0x50, 0x4F, 0x50, 0x20, 0x4D, 0x55, 0x53, 0x49, 0x43, 0x0D ],
    [ 0x21, 0x02, 0x08, 0x00, 0x02, 0x10, 0x11, 0x0D ],
    [ 0x21, 0x01, 0x1A, 0x00, 0x80, 0x00, 0x50, 0x6C, 0x61, 0x79, 0x69, 0x6E, 0x67, 0x20, 0x79, 0x6F, 0x75, 0x72, 0x20, 0x66, 0x61, 0x76, 0x6F, 0x75, 0x72, 0x69, 0x74, 0x65, 0x20, 0x6D, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x0D ],
    [ 0x21, 0x01, 0x1B, 0x00, 0x0F, 0x01, 0x02, 0x44, 0x41, 0x42, 0x20, 0x53, 0x54, 0x41, 0x54, 0x49, 0x4F, 0x4E, 0x20, 0x32, 0x0D ],
    [ 0x21, 0x01, 0x42, 0x00, 0x08, 0x05, 0x00, 0x02, 0xD0, 0x32, 0x00, 0x02, 0x00, 0x0D ],
    [ 0x21, 0x01, 0x12, 0x00, 0x1C, 0x00, 0x50, 0x6C, 0x61, 0x79, 0x69, 0x6E, 0x67, 0x20, 0x79, 0x6F, 0x75, 0x72, 0x20, 0x66, 0x61, 0x76, 0x6F, 0x75, 0x72, 0x69, 0x74, 0x65, 0x20, 0x6D, 0x75, 0x73, 0x69, 0x63, 0x0D ],
    [ 0x21, 0x01, 0x0C, 0x00, 0x01, 0x02, 0x0D ],
    [ 0x21, 0x01, 0x16, 0x00, 0x02, 0x55, 0x05, 0x0D ]
    ]
    
    
    /*
     Power (0x00)
     Request the stand-by state of a zone.
     Example
     Command/response sequence to request the power state of zone 1 where zone 1 has power on:
     Command:   0x21 0x01 0x00 0x01 0xF0 0x0D
     Response:  0x21 0x01 0x00 0x00 0x01 0x01 0x0D
     
     */
    
    
    /*
     Each transmission by the RC is the following format: <St> <Zn> <Cc> <Dl> <Data> <Et>
      St (Start transmission): 0x21 ‘!’
      Zn (Zone number): see below.
      Cc (Command code): the code for the command
      Dl (Data length): the number of data items following this item,excluding the ETR  Data: the parameters for the command
      Et (End transmission): 0x0D
     
     */
    
}
