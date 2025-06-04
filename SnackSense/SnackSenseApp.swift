//
//  SnackSenseApp.swift
//  SnackSense
//
//  Created by Tom on 22/4/2025.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct SnackSenseApp: App {
    init() {
            FirebaseApp.configure()
        }
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
