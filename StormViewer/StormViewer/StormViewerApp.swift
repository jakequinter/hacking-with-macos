//
//  StormViewerApp.swift
//  StormViewer
//
//  Created by Jake Quinter on 12/27/22.
//

import SwiftUI

@main
struct StormViewerApp: App {
    var body: some Scene {
        Window("Storm Viewer", id: "main") {
            ContentView()
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .undoRedo) { }
            CommandGroup(replacing: .pasteboard) { }
        }
    }
}
