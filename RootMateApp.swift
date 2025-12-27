//
//  RootMateApp.swift
//  RootMate
//
//  Created on $(date)
//

import SwiftUI

@main
struct RootMateApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onOpenURL { url in
                    handleDeepLink(url: url)
                }
        }
    }
    
    private func handleDeepLink(url: URL) {
        // Handle rootmate://plant/{plantId} URLs
        // URL format: rootmate://plant/{uuid}
        guard url.scheme == "rootmate" else { return }
        
        // Parse: rootmate://plant/{uuid}
        // host = "plant", path = "/{uuid}"
        if url.host == "plant" {
            let path = url.path
            // Remove leading slash
            let plantIdString = path.hasPrefix("/") ? String(path.dropFirst()) : path
            if let plantId = UUID(uuidString: plantIdString) {
                appState.selectedPlantId = plantId
            }
        }
    }
}

// App state for handling deep links
class AppState: ObservableObject {
    @Published var selectedPlantId: UUID?
}

