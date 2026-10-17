//
//  GlassBackgroundView.swift
//  TelegramHighlights
//
//  This source file is derived from Telegram iOS:
//  https://github.com/TelegramMessenger/Telegram-iOS
//
//  Modified for this package on 17.10.2026.
//
//  Distributed under the terms of the GNU General Public License,
//  version 2 or any later version. See the LICENSE file for details.
//

import UIKit

public class GlassBackgroundView: UIView {

    public struct CornerRadii: Equatable {
        public let topLeft: CGFloat
        public let topRight: CGFloat
        public let bottomLeft: CGFloat
        public let bottomRight: CGFloat

        public init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
            self.topLeft = topLeft
            self.topRight = topRight
            self.bottomLeft = bottomLeft
            self.bottomRight = bottomRight
        }

        public init(radius: CGFloat) {
            self.init(topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius)
        }

        fileprivate func insetBy(_ value: CGFloat) -> CornerRadii {
            return CornerRadii(
                topLeft: max(0.0, self.topLeft - value),
                topRight: max(0.0, self.topRight - value),
                bottomLeft: max(0.0, self.bottomLeft - value),
                bottomRight: max(0.0, self.bottomRight - value)
            )
        }

        fileprivate var maximum: CGFloat {
            return max(max(self.topLeft, self.topRight), max(self.bottomLeft, self.bottomRight))
        }
    }

    public enum Shape: Equatable {
        case roundedRect(cornerRadius: CGFloat)
        case customRoundedRect(cornerRadii: CornerRadii)

        fileprivate func cornerRadii(for size: CGSize) -> CornerRadii {
            switch self {
            case let .roundedRect(cornerRadius):
                return GlassBackgroundView.clampedCornerRadii(size: size, cornerRadii: CornerRadii(radius: cornerRadius))
            case let .customRoundedRect(cornerRadii):
                return GlassBackgroundView.clampedCornerRadii(size: size, cornerRadii: cornerRadii)
            }
        }

        func maximumCornerRadius(for size: CGSize) -> CGFloat {
            return self.cornerRadii(for: size).maximum
        }
    }

    static func clampedCornerRadii(size: CGSize, cornerRadii: CornerRadii) -> CornerRadii {
        let size = CGSize(width: max(0.0, size.width), height: max(0.0, size.height))
        var cornerRadii = CornerRadii(
            topLeft: max(0.0, cornerRadii.topLeft),
            topRight: max(0.0, cornerRadii.topRight),
            bottomLeft: max(0.0, cornerRadii.bottomLeft),
            bottomRight: max(0.0, cornerRadii.bottomRight)
        )

        func scaleFor(edgeLength: CGFloat, _ lhs: CGFloat, _ rhs: CGFloat) -> CGFloat {
            let sum = lhs + rhs
            if sum <= edgeLength || sum.isZero {
                return 1.0
            }
            return edgeLength / sum
        }

        let scale = min(
            1.0,
            scaleFor(edgeLength: size.width, cornerRadii.topLeft, cornerRadii.topRight),
            scaleFor(edgeLength: size.width, cornerRadii.bottomLeft, cornerRadii.bottomRight),
            scaleFor(edgeLength: size.height, cornerRadii.topLeft, cornerRadii.bottomLeft),
            scaleFor(edgeLength: size.height, cornerRadii.topRight, cornerRadii.bottomRight)
        )

        if scale < 1.0 {
            cornerRadii = CornerRadii(
                topLeft: cornerRadii.topLeft * scale,
                topRight: cornerRadii.topRight * scale,
                bottomLeft: cornerRadii.bottomLeft * scale,
                bottomRight: cornerRadii.bottomRight * scale
            )
        }

        return cornerRadii
    }

    static func generateRoundedRectPath(rect: CGRect, cornerRadii: CornerRadii) -> CGPath {
        let cornerRadii = self.clampedCornerRadii(size: rect.size, cornerRadii: cornerRadii)
        let path = CGMutablePath()

        func addCorner(tangent1End: CGPoint, tangent2End: CGPoint, radius: CGFloat) {
            if radius > CGFloat.ulpOfOne {
                path.addArc(tangent1End: tangent1End, tangent2End: tangent2End, radius: radius)
            } else {
                path.addLine(to: tangent1End)
                path.addLine(to: tangent2End)
            }
        }

        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadii.topLeft))
        addCorner(
            tangent1End: CGPoint(x: rect.minX, y: rect.minY),
            tangent2End: CGPoint(x: rect.minX + cornerRadii.topLeft, y: rect.minY),
            radius: cornerRadii.topLeft
        )
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadii.topRight, y: rect.minY))
        addCorner(
            tangent1End: CGPoint(x: rect.maxX, y: rect.minY),
            tangent2End: CGPoint(x: rect.maxX, y: rect.minY + cornerRadii.topRight),
            radius: cornerRadii.topRight
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadii.bottomRight))
        addCorner(
            tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
            tangent2End: CGPoint(x: rect.maxX - cornerRadii.bottomRight, y: rect.maxY),
            radius: cornerRadii.bottomRight
        )
        path.addLine(to: CGPoint(x: rect.minX + cornerRadii.bottomLeft, y: rect.maxY))
        addCorner(
            tangent1End: CGPoint(x: rect.minX, y: rect.maxY),
            tangent2End: CGPoint(x: rect.minX, y: rect.maxY - cornerRadii.bottomLeft),
            radius: cornerRadii.bottomLeft
        )
        path.closeSubpath()

        return path
    }

    static func generateRoundedRectPath(size: CGSize, cornerRadii: CornerRadii) -> CGPath {
        return self.generateRoundedRectPath(rect: CGRect(origin: CGPoint(), size: size), cornerRadii: cornerRadii)
    }
}
