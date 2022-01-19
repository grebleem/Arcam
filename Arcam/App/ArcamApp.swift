//
//  ArcamApp.swift
//  Arcam
//
//  Created by Bastiaan Meelberg on 12/01/2022.
//

import SwiftUI

@main
struct ArcamApp: App {
    @StateObject var model = WebSocketController(hostname: "192.168.1.80", port: 50000)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }.commands {
            MenuCommands()
        }
        
        #if os(macOS)
        Settings {
            SettingView()
        }
        #endif

    }
    
    
}
