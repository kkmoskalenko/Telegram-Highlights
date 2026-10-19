//
//  GlassBackgroundView.swift
//  TelegramHighlights
//
//  Created by Konstantin Moskalenko on 18.10.2026.
//

import GlassBackground
import SwiftUI
import UIKit

enum GlassTint: String, CaseIterable {
    case panel = "Panel"
    case clear = "Clear"
    case blue = "Blue"

    var color: GlassBackgroundView.TintColor {
        switch self {
        case .panel: return .init(kind: .panel)
        case .clear: return .init(kind: .clear)
        case .blue: return .init(kind: .custom(style: .default, color: .systemBlue.withAlphaComponent(0.25)))
        }
    }
}

final class GlassBackgroundDemoUIView: UIView {
    struct Item {
        let image: UIImage
        let title: String
        let description: String

        static var car: Self {
            .init(image: .car, title: "A different perspective",
                  description: "A familiar scene takes on a different character as it moves beneath the glass. Watch the curved edges bend the colors and details behind them.")
        }

        static var leaves: Self {
            .init(image: .leaves, title: "Autumn in focus",
                  description: "Soft light reveals the texture of each leaf as it moves beneath the glass. Watch the colors and fine details bend along the curved edges.")
        }
    }

    private static let cardHeight: CGFloat = 160.0
    private static let cardSpacing: CGFloat = 16.0
    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    private var glassContainer: GlassBackgroundContainerView?
    private var glassView: GlassBackgroundView?
    private var favoriteGlassView: GlassBackgroundView?
    private var useCustomImplementation: Bool?
    private var tint: GlassTint = .panel
    private let symbol = UIImageView(image: UIImage(systemName: "sparkles"))
    private let label = UILabel()
    private let favoriteSymbol = UIImageView(image: UIImage(systemName: "heart"))
    private let primaryButton = UIButton(type: .custom)
    private let favoriteButton = UIButton(type: .custom)

    init(frame: CGRect, items: [Item] = [.car, .leaves]) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 24.0
        layer.cornerCurve = .continuous
        clipsToBounds = true

        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.accessibilityIdentifier = "glassPreviewScrollView"
        addSubview(scrollView)
        stack.axis = .vertical
        stack.spacing = Self.cardSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20.0),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20.0),
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20.0),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -92.0),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40.0)
        ])

        for _ in 0..<4 {
            let section = UIStackView()
            section.axis = .vertical
            section.spacing = Self.cardSpacing
            for item in items {
                let imageView = UIImageView(image: item.image)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 16.0
                imageView.heightAnchor.constraint(equalToConstant: Self.cardHeight).isActive = true
                section.addArrangedSubview(imageView)
                section.addArrangedSubview(text(item.title, font: .headline))
                section.addArrangedSubview(text(item.description, font: .subheadline))
            }
            stack.addArrangedSubview(section)
        }

        symbol.contentMode = .scaleAspectFit
        symbol.tintColor = .label
        symbol.isAccessibilityElement = false
        label.text = "Liquid Glass"
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        favoriteSymbol.contentMode = .scaleAspectFit
        favoriteSymbol.tintColor = .label
        favoriteSymbol.isAccessibilityElement = false
        primaryButton.accessibilityLabel = "Liquid Glass"
        primaryButton.accessibilityHint = "Touch and drag for glass feedback"
        primaryButton.accessibilityIdentifier = "interactiveGlassButton"
        favoriteButton.accessibilityLabel = "Favorite"
        favoriteButton.accessibilityHint = "Touch and drag for glass feedback"
        favoriteButton.accessibilityIdentifier = "favoriteGlassButton"
        configure(useCustomImplementation: true, tint: .panel)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func text(_ value: String, font: UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.text = value
        label.font = .preferredFont(forTextStyle: font)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = font == .subheadline ? 4 : 0
        return label
    }

    func configure(useCustomImplementation: Bool, tint: GlassTint) {
        if self.useCustomImplementation != useCustomImplementation {
            let previous = GlassBackgroundView.useCustomGlassImpl
            GlassBackgroundView.useCustomGlassImpl = useCustomImplementation
            defer { GlassBackgroundView.useCustomGlassImpl = previous }

            let container = GlassBackgroundContainerView(spacing: 16.0)
            let primaryGlass = GlassBackgroundView(frame: .zero)
            let favoriteGlass = GlassBackgroundView(frame: .zero)
            glassContainer?.removeFromSuperview()
            glassContainer = container
            glassView = primaryGlass
            favoriteGlassView = favoriteGlass
            self.useCustomImplementation = useCustomImplementation
            addSubview(container)
            container.contentView.addSubview(primaryGlass)
            container.contentView.addSubview(favoriteGlass)
            primaryGlass.contentView.addSubview(symbol)
            primaryGlass.contentView.addSubview(label)
            primaryGlass.contentView.addSubview(primaryButton)
            favoriteGlass.contentView.addSubview(favoriteSymbol)
            favoriteGlass.contentView.addSubview(favoriteButton)
        }
        self.tint = tint
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        let groupSize = CGSize(width: max(0.0, min(280.0, bounds.width - 72.0)), height: 56.0)
        let isDark = traitCollection.userInterfaceStyle == .dark
        glassContainer?.frame = CGRect(
            x: (bounds.width - groupSize.width) / 2.0,
            y: bounds.height - groupSize.height - 16.0,
            width: groupSize.width,
            height: groupSize.height
        )
        glassContainer?.update(size: groupSize, isDark: isDark)

        let favoriteWidth = min(56.0, groupSize.width)
        let spacing = min(12.0, max(0.0, groupSize.width - favoriteWidth))
        let primarySize = CGSize(width: max(0.0, groupSize.width - favoriteWidth - spacing), height: groupSize.height)
        let favoriteSize = CGSize(width: favoriteWidth, height: groupSize.height)
        glassView?.frame = CGRect(origin: .zero, size: primarySize)
        favoriteGlassView?.frame = CGRect(x: primarySize.width + spacing, y: 0.0, width: favoriteSize.width, height: favoriteSize.height)
        glassView?.update(size: primarySize, cornerRadius: 28.0, isDark: isDark,
                          tintColor: tint.color, isInteractive: true)
        favoriteGlassView?.update(size: favoriteSize, cornerRadius: 28.0, isDark: isDark,
                                  tintColor: tint.color, isInteractive: true)
        symbol.frame = CGRect(x: 20.0, y: 16.0, width: 24.0, height: 24.0)
        label.frame = CGRect(x: 56.0, y: 0.0, width: max(0.0, primarySize.width - 72.0), height: primarySize.height)
        primaryButton.frame = CGRect(origin: .zero, size: primarySize)
        favoriteSymbol.frame = CGRect(x: (favoriteSize.width - 24.0) / 2.0, y: 16.0, width: 24.0, height: 24.0)
        favoriteButton.frame = CGRect(origin: .zero, size: favoriteSize)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsLayout()
    }
}

private struct GlassBackgroundPreview: UIViewRepresentable {
    var useCustomImplementation = true
    var tint: GlassTint = .panel

    func makeUIView(context: Context) -> GlassBackgroundDemoUIView {
        GlassBackgroundDemoUIView(frame: .zero)
    }

    func updateUIView(_ uiView: GlassBackgroundDemoUIView, context: Context) {
        uiView.configure(useCustomImplementation: useCustomImplementation, tint: tint)
    }
}

struct GlassBackgroundDemoView: View {
    @State private var useCustomImplementation = true
    @State private var tint: GlassTint = .panel

    var body: some View {
        VStack(spacing: 24.0) {
            GlassBackgroundPreview(useCustomImplementation: useCustomImplementation, tint: tint)
                .frame(maxWidth: 600.0, maxHeight: .infinity)
            VStack(alignment: .leading, spacing: 12.0) {
                if #available(iOS 26.0, *) {
                    Toggle(isOn: $useCustomImplementation) {
                        VStack(alignment: .leading, spacing: 4.0) {
                            Text("Custom Liquid Glass")
                            Text("Switch between system and custom Liquid Glass.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                Text("Tint").font(.subheadline).foregroundStyle(.secondary)
                Picker("Tint", selection: $tint) {
                    ForEach(GlassTint.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                Text("Press or drag the glass controls to explore their feedback.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: 450.0)
        }
        .padding(24.0)
        .navigationTitle("Glass Background")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    GlassBackgroundDemoView()
}
