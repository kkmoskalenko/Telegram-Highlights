//
//  DustEffectView.swift
//  TelegramHighlights
//
//  Created by Konstantin Moskalenko on 25.04.2026.
//

import DustEffect
import SwiftUI
import UIKit

final class DustEffectUIView: UIView {
    
    private let imagePadding: CGFloat = 64.0
    private let imageView = UIImageView(image: .car)
    
    private var activeDustEffectLayer: DustEffectLayer?
    
    var animationSpeed: Float = 1.0 {
        didSet {
            activeDustEffectLayer?.animationSpeed = animationSpeed
        }
    }
    
    var animateDown: Bool = false {
        didSet {
            activeDustEffectLayer?.animateDown = animateDown
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        isOpaque = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 16.0
        imageView.layer.masksToBounds = true
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSide = max(0.0, min(bounds.width, bounds.height) - imagePadding)
        imageView.frame = CGRect(
            x: (bounds.width - imageSide) / 2.0,
            y: (bounds.height - imageSide) / 2.0,
            width: imageSide,
            height: imageSide
        )
    }
    
    func resetAnimation() {
        activeDustEffectLayer?.becameEmpty = nil
        activeDustEffectLayer?.removeFromSuperlayer()
        activeDustEffectLayer = nil
        imageView.isHidden = false
    }
    
    func playAnimation() {
        guard !imageView.isHidden, activeDustEffectLayer == nil else {
            return
        }
        
        layoutIfNeeded()
        
        let contentSize = imageView.bounds.size
        guard contentSize.width > 0.0, contentSize.height > 0.0 else {
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: contentSize)
        let image = renderer.image { context in
            imageView.layer.render(in: context.cgContext)
        }
        
        let effectFrame = window.map { convert($0.bounds, from: $0) } ?? bounds
        let itemFrame = imageView.frame.offsetBy(
            dx: -effectFrame.minX,
            dy: -effectFrame.minY
        )
        
        let dustEffectLayer = DustEffectLayer()
        dustEffectLayer.frame = effectFrame
        dustEffectLayer.animationSpeed = animationSpeed
        dustEffectLayer.animateDown = animateDown
        dustEffectLayer.becameEmpty = { [weak self, weak dustEffectLayer] in
            dustEffectLayer?.removeFromSuperlayer()
            if self?.activeDustEffectLayer === dustEffectLayer {
                self?.activeDustEffectLayer = nil
            }
        }
        
        layer.addSublayer(dustEffectLayer)
        activeDustEffectLayer = dustEffectLayer
        
        dustEffectLayer.addItem(frame: itemFrame, image: image)
        imageView.isHidden = true
    }
}

struct DustEffectView: UIViewRepresentable {
    
    var animationSpeed: Float
    var animateDown: Bool
    
    @Binding var isDissolved: Bool
    
    init(
        isDissolved: Binding<Bool>,
        animationSpeed: Float = 1.0,
        animateDown: Bool = false
    ) {
        self._isDissolved = isDissolved
        self.animationSpeed = animationSpeed
        self.animateDown = animateDown
    }
    
    func makeUIView(context: Context) -> DustEffectUIView {
        let view = DustEffectUIView(frame: .zero)
        view.animationSpeed = animationSpeed
        view.animateDown = animateDown
        return view
    }
    
    func updateUIView(_ uiView: DustEffectUIView, context: Context) {
        uiView.animationSpeed = animationSpeed
        uiView.animateDown = animateDown
        
        UIView.transition(with: uiView,
                          duration: 0.2,
                          options: [.transitionCrossDissolve, .curveEaseOut]) {
            if isDissolved {
                uiView.playAnimation()
            } else {
                uiView.resetAnimation()
            }
        }
    }
}

struct DustEffectDemoView: View {
    
    @State private var animationSpeed: Double = 1.0
    @State private var animateDown = false
    @State private var isDissolved = false
    
    var body: some View {
        VStack(spacing: 24.0) {
            DustEffectView(
                isDissolved: $isDissolved,
                animationSpeed: Float(animationSpeed),
                animateDown: animateDown
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 16.0) {
                Button {
                    withAnimation(.smooth) {
                        isDissolved.toggle()
                    }
                } label: {
                    Group {
                        if isDissolved {
                            Label("Reset Animation", systemImage: "arrow.counterclockwise")
                        } else {
                            Label("Play Animation", systemImage: "play.fill")
                        }
                    }
                    .font(.headline)
                    .padding(8.0)
                }
                .prominentGlassButtonStyle()
                .padding(.bottom)
                
                Slider(value: $animationSpeed, in: 0.01...2.5) {
                    Text("Animation Speed")
                } minimumValueLabel: {
                    Image(systemName: "tortoise.fill")
                        .foregroundStyle(.secondary)
                } maximumValueLabel: {
                    Image(systemName: "hare.fill")
                        .foregroundStyle(.secondary)
                }
                
                Picker("Direction", selection: $animateDown) {
                    Text("Up").tag(false)
                    Text("Down").tag(true)
                }
                .pickerStyle(.segmented)
            }
            .frame(maxWidth: 450.0)
            .padding(.horizontal, 24.0)
            .padding(.bottom, 24.0)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension View {
    
    @ViewBuilder
    func prominentGlassButtonStyle() -> some View {
        if #available(iOS 26.0, *) {
            buttonStyle(.glassProminent)
        } else {
            buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    DustEffectDemoView()
        .background(MetalEngineRootLayerHost())
}
