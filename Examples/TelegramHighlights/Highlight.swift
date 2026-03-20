//
//  Highlight.swift
//  TelegramHighlights
//
//  Created by Konstantin Moskalenko on 20.03.2026.
//

enum Highlight: CaseIterable {
    case helloWorld
    
    var title: String {
        switch self {
        case .helloWorld:
            "Hello World"
        }
    }
}
