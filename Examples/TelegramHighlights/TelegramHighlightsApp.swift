//
//  TelegramHighlightsApp.swift
//  TelegramHighlights
//
//  Created by Konstantin Moskalenko on 20.03.2026.
//

import SwiftUI

@main
struct TelegramHighlightsApp: App {
    @State private var selection: Highlight?
    
    var body: some Scene {
        WindowGroup(appTitle) {
            NavigationSplitView {
                List(Highlight.allCases, id: \.self, selection: $selection) { highlight in
                    NavigationLink(highlight.title, value: highlight)
                }
                .navigationTitle(appTitle)
            } detail: {
                switch selection {
                case .helloWorld:
                    ContentView()
                case nil:
                    EmptyView()
                }
            }
        }
    }
    
    private var appTitle: String {
        "Telegram Highlights"
    }
}
