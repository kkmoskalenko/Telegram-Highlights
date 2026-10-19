//
//  Highlight.swift
//  TelegramHighlights
//
//  Created by Konstantin Moskalenko on 20.03.2026.
//

enum Highlight: CaseIterable {
    case dustEffect
    case glassBackground
    
    var title: String {
        switch self {
        case .dustEffect:
            "Dust Effect"
        case .glassBackground:
            "Glass Background"
        }
    }
    
    var description: String {
        switch self {
        case .dustEffect:
            "A.K.A. Thanos Snap"
        case .glassBackground:
            "Custom Liquid Glass"
        }
    }
}
