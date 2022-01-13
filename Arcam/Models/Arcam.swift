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
    
    enum command: UInt8 {
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
        // TO DO
        case heartbeat = 0x25
    }
    
    enum rc5 {
        case standby, eject, one, two, three, four, five, six, seven, eight, nine
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
        
        }
    }
    
    
    let power:[UInt8] = [0x21, 0x01, 0x00, 0x01, 0xF0, 0x0D]
    let displayBrightness:[UInt8] = [0x21, 0x01, 0x01, 0x01, 0xF0, 0x0D]
    let testMessage: [UInt8] = [0x21, 0x01, 0x19, 0x00, 0x10, 0x50, 0x4F, 0x50, 0x20, 0x4D, 0x55, 0x53, 0x49, 0x43, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x0D]
    
    
    
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
