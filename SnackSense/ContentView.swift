//
//  ContentView.swift
//  SnackSense
//
//  Created by Tom on 22/4/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var isLoggedIn: Bool = false

    //Homeview
    var body: some View {
        NavigationStack {
            if isLoggedIn {
                StartView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            // Check for login state
            isLoggedIn = checkIfUserIsLoggedIn()
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }

    private func checkIfUserIsLoggedIn() -> Bool {
        // Replace this with actual auth logic (e.g., check Keychain or stored token)
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
