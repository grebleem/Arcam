//
//  ConvertHexCodeView.swift
//  Arcam
//
//  Created by Bastiaan Meelberg on 13/01/2022.
//

import SwiftUI

struct ConvertHexCodeView: View {
    
    @State var convertString = ""
    var body: some View {
        VStack{
            TextField("HEX", text: $convertString)
        }
        .frame(width: 300)
        .navigationTitle("Landmark Settings")
        .padding(80)
    }
}

struct ConvertHexCodeView_Previews: PreviewProvider {
    static var previews: some View {
        ConvertHexCodeView()
    }
}
