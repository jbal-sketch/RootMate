//
//  ContentView.swift
//  RootMate
//
//  Created on $(date)
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        MyRootmatesView()
            .environmentObject(appState)
    }
}

#Preview {
    ContentView()
}

