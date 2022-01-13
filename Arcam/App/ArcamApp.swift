//
//  ArcamApp.swift
//  Arcam
//
//  Created by Bastiaan Meelberg on 12/01/2022.
//

import SwiftUI

@main
struct ArcamApp: App {
    @StateObject var model = WebSocketController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
        
        #if os(macOS)
        Settings {
            SettingView()
        }
        #endif
    }
    
    
}
