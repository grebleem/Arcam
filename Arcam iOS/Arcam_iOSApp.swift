//
//  Arcam_iOSApp.swift
//  Arcam iOS
//
//  Created by Bastiaan Meelberg on 19/03/2023.
//

import SwiftUI

@main
struct Arcam_iOSApp: App {
    @StateObject var model = WebSocketController(hostname: "192.168.1.80", port: 50000)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
