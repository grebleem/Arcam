//
//  MenuCommands.swift
//  Arcam
//
//  Created by Bastiaan Meelberg on 13/01/2022.
//

import SwiftUI

struct MenuCommands: Commands {
    var body: some Commands {
        // 2
        CommandGroup(before: CommandGroupPlacement.help) {
            // 3
            Button("Markdown Cheatsheet") {
                showCheatSheet()
            }
            // 4
            .keyboardShortcut("/", modifiers: .command)
            
            Divider()
            
            
        }
        
        CommandMenu("Tools", content: {
            Button("Convert HEX") {
                //
            }
            .keyboardShortcut("K", modifiers: .command)
        })
        
        // more menu items will go here
    }
    
    // 5
    func showCheatSheet() {
        let cheatSheetAddress = "https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet"
        guard let url = URL(string: cheatSheetAddress) else {
            // 6
            fatalError("Invalid cheatsheet URL")
        }
        NSWorkspace.shared.open(url)
    }
}
