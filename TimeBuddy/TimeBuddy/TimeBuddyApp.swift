//
//  TimeBuddyApp.swift
//  TimeBuddy
//
//  Created by Jake Quinter on 1/7/23.
//

import SwiftUI

@main
struct TimeBuddyApp: App {
    var body: some Scene {
        MenuBarExtra {
            ContentView()
        } label: {
            Label("Time Buddy", systemImage: "person.badge.clock.fill")
        }
        .menuBarExtraStyle(.window)
    }
}
