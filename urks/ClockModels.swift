/* /Users/drebin/Documents/software/urks/urks/ClockModels.swift */
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

typealias StoredClockColor = UrksSharedStoredColor
typealias ClockSnapshot = UrksSharedSnapshot

extension StoredClockColor {
    init(color: Color, fallback: StoredClockColor) {
        #if canImport(UIKit)
        let uiColor = UIColor(color)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            self.init(red: Double(red), green: Double(green), blue: Double(blue))
            return
        }

        if
            let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
            let converted = uiColor.cgColor.converted(to: colorSpace, intent: .defaultIntent, options: nil),
            let components = converted.components
        {
            if components.count >= 3 {
                self.init(
                    red: Double(components[0]),
                    green: Double(components[1]),
                    blue: Double(components[2])
                )
                return
            }

            if components.count == 2 {
                self.init(
                    red: Double(components[0]),
                    green: Double(components[0]),
                    blue: Double(components[0])
                )
                return
            }
        }
        #endif

        self = fallback
    }

    var hexString: String {
        let redValue = Int((red * 255.0).rounded())
        let greenValue = Int((green * 255.0).rounded())
        let blueValue = Int((blue * 255.0).rounded())
        return String(format: "#%02X%02X%02X", redValue, greenValue, blueValue)
    }

    var displayName: String {
        if let preset = ClockHandColor.matching(color: self) {
            return String(localized: preset.displayName)
        }
        return hexString
    }

    func isApproximatelyEqual(to other: StoredClockColor, tolerance: Double = 0.01) -> Bool {
        abs(red - other.red) <= tolerance &&
        abs(green - other.green) <= tolerance &&
        abs(blue - other.blue) <= tolerance
    }
}

enum ClockHandColor: String, CaseIterable, Identifiable {
    case red
    case orange
    case yellow
    case green
    case mint
    case teal
    case cyan
    case blue
    case indigo
    case purple
    case pink
    case brown
    case black
    case gray

    var id: String { rawValue }

    var displayName: LocalizedStringResource {
        switch self {
        case .red:
            return "handColor.red"
        case .orange:
            return "handColor.orange"
        case .yellow:
            return "handColor.yellow"
        case .green:
            return "handColor.green"
        case .mint:
            return "handColor.mint"
        case .teal:
            return "handColor.teal"
        case .cyan:
            return "handColor.cyan"
        case .blue:
            return "handColor.blue"
        case .indigo:
            return "handColor.indigo"
        case .purple:
            return "handColor.purple"
        case .pink:
            return "handColor.pink"
        case .brown:
            return "handColor.brown"
        case .black:
            return "handColor.black"
        case .gray:
            return "handColor.gray"
        }
    }

    var storedColor: StoredClockColor {
        switch self {
        case .red:
            return StoredClockColor(red255: 255, green255: 59, blue255: 48)
        case .orange:
            return StoredClockColor(red255: 255, green255: 149, blue255: 0)
        case .yellow:
            return StoredClockColor(red255: 255, green255: 204, blue255: 0)
        case .green:
            return StoredClockColor(red255: 52, green255: 199, blue255: 89)
        case .mint:
            return StoredClockColor(red255: 0, green255: 199, blue255: 190)
        case .teal:
            return StoredClockColor(red255: 48, green255: 176, blue255: 199)
        case .cyan:
            return StoredClockColor(red255: 50, green255: 173, blue255: 230)
        case .blue:
            return StoredClockColor(red255: 0, green255: 122, blue255: 255)
        case .indigo:
            return StoredClockColor(red255: 88, green255: 86, blue255: 214)
        case .purple:
            return StoredClockColor(red255: 175, green255: 82, blue255: 222)
        case .pink:
            return StoredClockColor(red255: 255, green255: 45, blue255: 85)
        case .brown:
            return StoredClockColor(red255: 162, green255: 132, blue255: 94)
        case .black:
            return StoredClockColor(red255: 0, green255: 0, blue255: 0)
        case .gray:
            return StoredClockColor(red255: 142, green255: 142, blue255: 147)
        }
    }

    static func matching(color: StoredClockColor) -> ClockHandColor? {
        allCases.first { $0.storedColor.isApproximatelyEqual(to: color) }
    }
}

enum ClockGeometry {
    static let dialRadiusRatio: Double = UrksSharedGeometry.dialRadiusRatio
    static let maxHandLengthRatio: Double = UrksSharedGeometry.maxHandLengthRatio
}

struct ClockSurfaceCustomization: Equatable {
    let markingColor: StoredClockColor
    let ringColor: StoredClockColor
    let dialBackgroundColor: StoredClockColor
    let appBackgroundColor: StoredClockColor
}

enum ClockDefaults {
    static let showSettings = false
    static let appearanceMode = ClockAppearanceMode.system
    static let showDigits = true
    static let showTicks = false
    static let centerDotScale = 1.0
    static let dialInset = 48.0
    static let displayMode = ClockDisplayMode.sixHands
    static let integerOnly = false
    static let continuousMinuteOnesInIntegerMode = false
    static let continuousSecondOnesInIntegerMode = false

    static let hourTensWidth = 0.024
    static let hourOnesWidth = 0.024
    static let minuteTensWidth = 0.018
    static let minuteOnesWidth = 0.018
    static let secondTensWidth = 0.009
    static let secondOnesWidth = 0.0055

    static let hourTensLength = 0.30
    static let hourOnesLength = 0.34
    static let minuteTensLength = 0.30
    static let minuteOnesLength = 0.34
    static let secondTensLength = 0.38
    static let secondOnesLength = 0.40

    static let hourTensColor = ClockHandColor.indigo.storedColor
    static let hourOnesColor = ClockHandColor.blue.storedColor
    static let minuteTensColor = ClockHandColor.green.storedColor
    static let minuteOnesColor = ClockHandColor.yellow.storedColor
    static let secondTensColor = ClockHandColor.orange.storedColor
    static let secondOnesColor = ClockHandColor.red.storedColor

    static let lightMarkingColor = StoredClockColor(red255: 112, green255: 112, blue255: 118)
    static let lightRingColor = StoredClockColor(red255: 170, green255: 170, blue255: 176)
    static let lightDialBackgroundColor = StoredClockColor(red255: 244, green255: 246, blue255: 250)
    static let lightAppBackgroundColor = StoredClockColor(red255: 230, green255: 237, blue255: 250)

    static let darkMarkingColor = StoredClockColor(red255: 198, green255: 206, blue255: 218)
    static let darkRingColor = StoredClockColor(red255: 150, green255: 160, blue255: 176)
    static let darkDialBackgroundColor = StoredClockColor(red255: 33, green255: 41, blue255: 56)
    static let darkAppBackgroundColor = StoredClockColor(red255: 22, green255: 30, blue255: 42)

    static let lightSurfaceCustomization = ClockSurfaceCustomization(
        markingColor: lightMarkingColor,
        ringColor: lightRingColor,
        dialBackgroundColor: lightDialBackgroundColor,
        appBackgroundColor: lightAppBackgroundColor
    )

    static let darkSurfaceCustomization = ClockSurfaceCustomization(
        markingColor: darkMarkingColor,
        ringColor: darkRingColor,
        dialBackgroundColor: darkDialBackgroundColor,
        appBackgroundColor: darkAppBackgroundColor
    )
}

enum ClockHandKind: String, CaseIterable, Identifiable {
    case hourTens
    case hourOnes
    case minuteTens
    case minuteOnes
    case secondTens
    case secondOnes

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .hourTens:
            return "hand.kind.hourTens"
        case .hourOnes:
            return "hand.kind.hourOnes"
        case .minuteTens:
            return "hand.kind.minuteTens"
        case .minuteOnes:
            return "hand.kind.minuteOnes"
        case .secondTens:
            return "hand.kind.secondTens"
        case .secondOnes:
            return "hand.kind.secondOnes"
        }
    }

    var isSecondHand: Bool {
        switch self {
        case .secondTens, .secondOnes:
            return true
        case .hourTens, .hourOnes, .minuteTens, .minuteOnes:
            return false
        }
    }
}

struct HandAdjustment {
    let width: Double
    let length: Double
    let color: StoredClockColor
}

enum ClockPreset: String, CaseIterable, Identifiable {
    case standard

    var id: String { rawValue }

    var displayName: LocalizedStringResource {
        "preset.standard"
    }

    var customization: HandCustomization {
        HandCustomization(
            hourTensWidth: ClockDefaults.hourTensWidth,
            hourOnesWidth: ClockDefaults.hourOnesWidth,
            minuteTensWidth: ClockDefaults.minuteTensWidth,
            minuteOnesWidth: ClockDefaults.minuteOnesWidth,
            secondTensWidth: ClockDefaults.secondTensWidth,
            secondOnesWidth: ClockDefaults.secondOnesWidth,
            hourTensLength: ClockDefaults.hourTensLength,
            hourOnesLength: ClockDefaults.hourOnesLength,
            minuteTensLength: ClockDefaults.minuteTensLength,
            minuteOnesLength: ClockDefaults.minuteOnesLength,
            secondTensLength: ClockDefaults.secondTensLength,
            secondOnesLength: ClockDefaults.secondOnesLength,
            hourTensColor: ClockDefaults.hourTensColor,
            hourOnesColor: ClockDefaults.hourOnesColor,
            minuteTensColor: ClockDefaults.minuteTensColor,
            minuteOnesColor: ClockDefaults.minuteOnesColor,
            secondTensColor: ClockDefaults.secondTensColor,
            secondOnesColor: ClockDefaults.secondOnesColor
        )
    }
}

func localizedNumber(_ value: Double, fractionDigits: Int) -> String {
    value.formatted(.number.precision(.fractionLength(fractionDigits)))
}

extension HandCustomization {
    func adjustment(for kind: ClockHandKind) -> HandAdjustment {
        switch kind {
        case .hourTens:
            return HandAdjustment(width: hourTensWidth, length: hourTensLength, color: hourTensColor)
        case .hourOnes:
            return HandAdjustment(width: hourOnesWidth, length: hourOnesLength, color: hourOnesColor)
        case .minuteTens:
            return HandAdjustment(width: minuteTensWidth, length: minuteTensLength, color: minuteTensColor)
        case .minuteOnes:
            return HandAdjustment(width: minuteOnesWidth, length: minuteOnesLength, color: minuteOnesColor)
        case .secondTens:
            return HandAdjustment(width: secondTensWidth, length: secondTensLength, color: secondTensColor)
        case .secondOnes:
            return HandAdjustment(width: secondOnesWidth, length: secondOnesLength, color: secondOnesColor)
        }
    }
}

extension ClockDisplayMode {
    var visibleHandKinds: [ClockHandKind] {
        switch self {
        case .sixHands:
            return ClockHandKind.allCases
        case .fourHands:
            return ClockHandKind.allCases.filter { !$0.isSecondHand }
        }
    }
}

struct HandSpec: Identifiable {
    let id: String
    let slotValue: Double
    let color: Color
    let lengthRatio: CGFloat
    let lineWidthRatio: CGFloat
}

struct ClockSettings {
    let appearanceMode: ClockAppearanceMode
    let effectiveColorScheme: ColorScheme
    let showDigits: Bool
    let showTicks: Bool
    let useGradientBackground: Bool
    let centerDotScale: Double
    let dialInset: Double
    let displayMode: ClockDisplayMode
    let integerOnly: Bool
    let continuousMinuteOnesInIntegerMode: Bool
    let continuousSecondOnesInIntegerMode: Bool
    let lightHandCustomization: HandCustomization
    let darkHandCustomization: HandCustomization
    let lightSurfaceCustomization: ClockSurfaceCustomization
    let darkSurfaceCustomization: ClockSurfaceCustomization

    var preferredColorSchemeOverride: ColorScheme? {
        appearanceMode.preferredColorScheme
    }

    var handCustomization: HandCustomization {
        switch effectiveColorScheme {
        case .light:
            return lightHandCustomization
        case .dark:
            return darkHandCustomization
        @unknown default:
            return lightHandCustomization
        }
    }

    var surfaceCustomization: ClockSurfaceCustomization {
        switch effectiveColorScheme {
        case .light:
            return lightSurfaceCustomization
        case .dark:
            return darkSurfaceCustomization
        @unknown default:
            return lightSurfaceCustomization
        }
    }

    var resolvedPalette: ClockPalette {
        ClockPalette.palette(for: effectiveColorScheme, surfaceColors: surfaceCustomization)
    }

    var appearanceDescription: String {
        switch appearanceMode {
        case .system:
            switch effectiveColorScheme {
            case .light:
                return String(localized: "settings.appearanceDescription.system.light")
            case .dark:
                return String(localized: "settings.appearanceDescription.system.dark")
            @unknown default:
                return String(localized: "settings.appearanceDescription.system.light")
            }
        case .light:
            return String(localized: "settings.appearanceDescription.fixedLight")
        case .dark:
            return String(localized: "settings.appearanceDescription.fixedDark")
        }
    }
}

struct HandCustomization: Equatable {
    let hourTensWidth: Double
    let hourOnesWidth: Double
    let minuteTensWidth: Double
    let minuteOnesWidth: Double
    let secondTensWidth: Double
    let secondOnesWidth: Double

    let hourTensLength: Double
    let hourOnesLength: Double
    let minuteTensLength: Double
    let minuteOnesLength: Double
    let secondTensLength: Double
    let secondOnesLength: Double

    let hourTensColor: StoredClockColor
    let hourOnesColor: StoredClockColor
    let minuteTensColor: StoredClockColor
    let minuteOnesColor: StoredClockColor
    let secondTensColor: StoredClockColor
    let secondOnesColor: StoredClockColor
}

enum ClockAppearanceMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var displayName: LocalizedStringResource {
        switch self {
        case .system:
            return "appearance.system"
        case .light:
            return "appearance.light"
        case .dark:
            return "appearance.dark"
        }
    }

    var preferredColorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    func resolvedColorScheme(system: ColorScheme) -> ColorScheme {
        switch self {
        case .system:
            return system
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

enum ClockDisplayMode: String, CaseIterable, Identifiable {
    case sixHands
    case fourHands

    var id: String { rawValue }

    var displayName: LocalizedStringResource {
        switch self {
        case .sixHands:
            return "displayMode.sixHands"
        case .fourHands:
            return "displayMode.fourHands"
        }
    }
}

struct ClockPalette {
    let backgroundGradient: [Color]
    let dialGradient: [Color]
    let ringColor: Color
    let markingColor: Color
    let centerOuterFill: Color
    let centerInnerFill: Color
    let overlayScrim: Color
    let panelBackground: Color
    let panelStroke: Color
    let panelShadow: Color
    let sectionBackground: Color
    let sectionStroke: Color
    let controlTint: Color

    static func palette(
        for colorScheme: ColorScheme,
        surfaceColors: ClockSurfaceCustomization
    ) -> ClockPalette {
        switch colorScheme {
        case .light:
            return ClockPalette(
                backgroundGradient: [
                    surfaceColors.appBackgroundColor.mixed(with: .white, amount: 0.16).color,
                    surfaceColors.appBackgroundColor.color,
                    surfaceColors.appBackgroundColor.mixed(with: .white, amount: 0.28).color
                ],
                dialGradient: [
                    surfaceColors.dialBackgroundColor.mixed(with: .white, amount: 0.18).color,
                    surfaceColors.dialBackgroundColor.color,
                    surfaceColors.dialBackgroundColor.mixed(with: .black, amount: 0.08).color
                ],
                ringColor: surfaceColors.ringColor.color,
                markingColor: surfaceColors.markingColor.color,
                centerOuterFill: Color.black.opacity(0.16),
                centerInnerFill: surfaceColors.dialBackgroundColor.mixed(with: .white, amount: 0.28).color,
                overlayScrim: Color.black.opacity(0.22),
                panelBackground: Color.white.opacity(0.52),
                panelStroke: Color.white.opacity(0.55),
                panelShadow: Color.black.opacity(0.18),
                sectionBackground: Color.white.opacity(0.58),
                sectionStroke: Color.black.opacity(0.06),
                controlTint: Color.blue
            )
        case .dark:
            return ClockPalette(
                backgroundGradient: [
                    surfaceColors.appBackgroundColor.mixed(with: .white, amount: 0.08).color,
                    surfaceColors.appBackgroundColor.color,
                    surfaceColors.appBackgroundColor.mixed(with: .black, amount: 0.14).color
                ],
                dialGradient: [
                    surfaceColors.dialBackgroundColor.mixed(with: .white, amount: 0.08).color,
                    surfaceColors.dialBackgroundColor.color,
                    surfaceColors.dialBackgroundColor.mixed(with: .black, amount: 0.18).color
                ],
                ringColor: surfaceColors.ringColor.color,
                markingColor: surfaceColors.markingColor.color,
                centerOuterFill: Color.white.opacity(0.18),
                centerInnerFill: surfaceColors.dialBackgroundColor.mixed(with: .white, amount: 0.52).color,
                overlayScrim: Color.black.opacity(0.42),
                panelBackground: Color(red: 0.09, green: 0.12, blue: 0.18).opacity(0.72),
                panelStroke: Color.white.opacity(0.12),
                panelShadow: Color.black.opacity(0.42),
                sectionBackground: Color.white.opacity(0.055),
                sectionStroke: Color.white.opacity(0.10),
                controlTint: Color(red: 0.48, green: 0.66, blue: 1.00)
            )
        @unknown default:
            return palette(for: .light, surfaceColors: surfaceColors)
        }
    }
}

func slotAngle(for slot: Double, rotationSlotOffset: Double = 0.0) -> Angle {
    UrksSharedGeometry.slotAngle(for: slot, rotationSlotOffset: rotationSlotOffset)
}

func pointOnCircle(center: CGPoint, radius: CGFloat, angle: Angle) -> CGPoint {
    UrksSharedGeometry.pointOnCircle(center: center, radius: radius, angle: angle)
}
