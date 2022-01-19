//
//  Setting.swift
//  Arcam
//
//  Created by Bastiaan Meelberg on 12/01/2022.
//

import SwiftUI

struct SettingView: View {
    
    @AppStorage("ipAddress")
    private var ipAddress = "192.168.1.80"
    
    var body: some View {
        VStack {
            Text("Enter Control IP")
                .font(.callout)
                .bold()
            TextField("Enter Control IP...", text: $ipAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .frame(width: 300)
        .navigationTitle("Arcam Settings")
        .padding(80)
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
