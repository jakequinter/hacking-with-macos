//
//  CowsAndBullsApp.swift
//  CowsAndBulls
//
//  Created by Jake Quinter on 12/28/22.
//

import SwiftUI

@main
struct CowsAndBullsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
        
        Settings(content: SettingsView.init)
    }
}
