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
                    NavigationLink(value: highlight) {
                        VStack(alignment: .leading) {
                            Text(highlight.title)
                                .font(.headline)
                            Text(highlight.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .navigationTitle(appTitle)
            } detail: {
                switch selection {
                case .dustEffect:
                    DustEffectDemoView()
                case .glassBackground:
                    GlassBackgroundDemoView()
                case nil:
                    EmptyView()
                }
            }
            .background(MetalEngineRootLayerHost())
        }
    }
    
    private var appTitle: String {
        "Telegram Highlights"
    }
}
