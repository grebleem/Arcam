//
//  RoomEqView.swift
//  Arcam
//
//  Created by Bastiaan Meelberg on 20/01/2022.
//

import SwiftUI

struct RoomEqView: View {
    @EnvironmentObject var model: WebSocketController
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button {
                model.sendCommand(.roomEqualisation)
                model.sendCommand(.roomEQnames)
            } label: {
                Text("Request Room EQ")
            }

        }
        .padding()
    }
}

struct RoomEqView_Previews: PreviewProvider {
    static var previews: some View {
        RoomEqView()
    }
}
