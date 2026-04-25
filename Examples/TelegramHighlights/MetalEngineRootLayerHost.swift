//
//  MetalEngineRootLayerHost.swift
//  TelegramHighlights
//
//  Created by Konstantin Moskalenko on 25.04.2026.
//

import MetalEngine
import SwiftUI
import UIKit

struct MetalEngineRootLayerHost: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ViewController {
        ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        uiViewController.installRootLayerIfNeeded()
    }
    
    final class ViewController: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.isUserInteractionEnabled = false
            view.backgroundColor = .clear
            installRootLayerIfNeeded()
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            installRootLayerIfNeeded()
        }
        
        func installRootLayerIfNeeded() {
            let rootLayer = MetalEngine.shared.rootLayer
            
            if rootLayer.superlayer !== view.layer {
                rootLayer.removeFromSuperlayer()
                view.layer.addSublayer(rootLayer)
            }
        }
    }
}
