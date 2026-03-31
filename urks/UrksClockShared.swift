/* /Users/drebin/Documents/software/urks/urks/UrksClockShared.swift */
import SwiftUI
import Foundation

private func localizedUrksSharedValue(_ key: String, fallback: String) -> String {
    let value = NSLocalizedString(key, comment: "")
    return value == key ? fallback : value
}

private func localizedUrksSharedFormat(_ key: String, fallback: String) -> String {
    localizedUrksSharedValue(key, fallback: fallback)
}

enum UrksSharedConfig {
    static let appGroupSuiteName: String? = "group.social.rsch.urks"
}

enum UrksDeepLink {
    static let scheme = "urks"
    static let configureSecondClockHost = "widget"
    static let configureSecondClockPath = "/configure-second-clock"

    static var configureSecondClockURL: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = configureSecondClockHost
        components.path = configureSecondClockPath
        return components.url
    }

    static func isConfigureSecondClockURL(_ url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }

        return components.scheme == scheme &&
            components.host == configureSecondClockHost &&
            components.path == configureSecondClockPath
    }
}

struct UrksSharedStoredColor: Equatable {
    let red: Double
    let green: Double
    let blue: Double

    static let white = UrksSharedStoredColor(red255: 255, green255: 255, blue255: 255)
    static let black = UrksSharedStoredColor(red255: 0, green255: 0, blue255: 0)

    init(red: Double, green: Double, blue: Double) {
        self.red = Self.clamp(red)
        self.green = Self.clamp(green)
        self.blue = Self.clamp(blue)
    }

    init(red255: Int, green255: Int, blue255: Int) {
        self.init(
            red: Double(red255) / 255.0,
            green: Double(green255) / 255.0,
            blue: Double(blue255) / 255.0
        )
    }

    var color: Color {
        Color(red: red, green: green, blue: blue)
    }

    func mixed(with other: UrksSharedStoredColor, amount: Double) -> UrksSharedStoredColor {
        let clampedAmount = Self.clamp(amount)
        let inverse = 1.0 - clampedAmount

        return UrksSharedStoredColor(
            red: (red * inverse) + (other.red * clampedAmount),
            green: (green * inverse) + (other.green * clampedAmount),
            blue: (blue * inverse) + (other.blue * clampedAmount)
        )
    }

    private static func clamp(_ value: Double) -> Double {
        min(max(value, 0.0), 1.0)
    }
}

enum UrksSharedGeometry {
    static let dialRadiusRatio: Double = 0.40
    static let maxHandLengthRatio: Double = dialRadiusRatio

    static func slotAngle(for slot: Double, rotationSlotOffset: Double = 0.0) -> Angle {
        Angle.degrees(-90.0 + (slot + rotationSlotOffset) * 36.0)
    }

    static func pointOnCircle(center: CGPoint, radius: CGFloat, angle: Angle) -> CGPoint {
        let radians = CGFloat(angle.radians)
        return CGPoint(
            x: center.x + CoreGraphics.cos(radians) * radius,
            y: center.y + CoreGraphics.sin(radians) * radius
        )
    }
}

struct UrksSharedHandPalette: Equatable {
    let hourTensColor: UrksSharedStoredColor
    let hourOnesColor: UrksSharedStoredColor
    let minuteTensColor: UrksSharedStoredColor
    let minuteOnesColor: UrksSharedStoredColor
    let secondTensColor: UrksSharedStoredColor
    let secondOnesColor: UrksSharedStoredColor

    static let fallback = UrksSharedHandPalette(
        hourTensColor: UrksSharedStoredColor(red255: 88, green255: 86, blue255: 214),
        hourOnesColor: UrksSharedStoredColor(red255: 0, green255: 122, blue255: 255),
        minuteTensColor: UrksSharedStoredColor(red255: 52, green255: 199, blue255: 89),
        minuteOnesColor: UrksSharedStoredColor(red255: 255, green255: 204, blue255: 0),
        secondTensColor: UrksSharedStoredColor(red255: 255, green255: 149, blue255: 0),
        secondOnesColor: UrksSharedStoredColor(red255: 255, green255: 59, blue255: 48)
    )
}

struct UrksSharedSurfacePalette: Equatable {
    let markingColor: UrksSharedStoredColor
    let ringColor: UrksSharedStoredColor
    let dialBackgroundColor: UrksSharedStoredColor
    let appBackgroundColor: UrksSharedStoredColor

    static let lightFallback = UrksSharedSurfacePalette(
        markingColor: UrksSharedStoredColor(red255: 112, green255: 112, blue255: 118),
        ringColor: UrksSharedStoredColor(red255: 170, green255: 170, blue255: 176),
        dialBackgroundColor: UrksSharedStoredColor(red255: 244, green255: 246, blue255: 250),
        appBackgroundColor: UrksSharedStoredColor(red255: 230, green255: 237, blue255: 250)
    )

    static let darkFallback = UrksSharedSurfacePalette(
        markingColor: UrksSharedStoredColor(red255: 198, green255: 206, blue255: 218),
        ringColor: UrksSharedStoredColor(red255: 150, green255: 160, blue255: 176),
        dialBackgroundColor: UrksSharedStoredColor(red255: 33, green255: 41, blue255: 56),
        appBackgroundColor: UrksSharedStoredColor(red255: 22, green255: 30, blue255: 42)
    )
}

struct UrksSharedHandMetrics: Equatable {
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

    static let fallback = UrksSharedHandMetrics(
        hourTensWidth: 0.024,
        hourOnesWidth: 0.024,
        minuteTensWidth: 0.018,
        minuteOnesWidth: 0.018,
        secondTensWidth: 0.009,
        secondOnesWidth: 0.0055,
        hourTensLength: 0.30,
        hourOnesLength: 0.34,
        minuteTensLength: 0.30,
        minuteOnesLength: 0.34,
        secondTensLength: 0.38,
        secondOnesLength: 0.40
    )
}

enum UrksSharedDisplayMode: String {
    case sixHands
    case fourHands

    var showsSecondHands: Bool {
        switch self {
        case .sixHands:
            return true
        case .fourHands:
            return false
        }
    }
}

enum UrksSharedAppearanceMode: String {
    case system
    case light
    case dark

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

enum UrksSharedDialMarkingMode: String {
    case digits
    case ticks
}

struct UrksSharedClockLocation: Equatable {
    let cityName: String
    let timeZoneIdentifier: String

    var timeZone: TimeZone {
        TimeZone(identifier: timeZoneIdentifier) ?? .current
    }
}

struct UrksSharedWidgetOptions: Equatable {
    let displayModeRaw: String
    let integerOnly: Bool
    let continuousMinuteOnesInIntegerMode: Bool
    let continuousSecondOnesInIntegerMode: Bool
    let dialMarkingModeRaw: String
    let legacyShowDigits: Bool
    let legacyShowTicks: Bool
    let appearanceModeRaw: String

    let primaryCityName: String
    let primaryTimeZoneIdentifier: String
    let widgetSecondaryClockEnabled: Bool
    let secondaryCityName: String?
    let secondaryTimeZoneIdentifier: String?

    static let fallback = UrksSharedWidgetOptions(
        displayModeRaw: "sixHands",
        integerOnly: false,
        continuousMinuteOnesInIntegerMode: false,
        continuousSecondOnesInIntegerMode: false,
        dialMarkingModeRaw: "digits",
        legacyShowDigits: true,
        legacyShowTicks: false,
        appearanceModeRaw: "system",
        primaryCityName: UrksSharedWidgetOptions.defaultCityName(for: TimeZone.current),
        primaryTimeZoneIdentifier: TimeZone.current.identifier,
        widgetSecondaryClockEnabled: false,
        secondaryCityName: nil,
        secondaryTimeZoneIdentifier: nil
    )

    var displayMode: UrksSharedDisplayMode {
        UrksSharedDisplayMode(rawValue: displayModeRaw) ?? .sixHands
    }

    var appearanceMode: UrksSharedAppearanceMode {
        UrksSharedAppearanceMode(rawValue: appearanceModeRaw) ?? .system
    }

    var dialMarkingMode: UrksSharedDialMarkingMode {
        if let storedMode = UrksSharedDialMarkingMode(rawValue: dialMarkingModeRaw) {
            return storedMode
        }

        if legacyShowTicks && !legacyShowDigits {
            return .ticks
        }

        return .digits
    }

    var showDigits: Bool {
        dialMarkingMode == .digits
    }

    var showTicks: Bool {
        dialMarkingMode == .ticks
    }

    var primaryClockLocation: UrksSharedClockLocation {
        let timeZone = TimeZone(identifier: primaryTimeZoneIdentifier) ?? .current
        let city = primaryCityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? Self.defaultCityName(for: timeZone)
            : primaryCityName

        return UrksSharedClockLocation(
            cityName: city,
            timeZoneIdentifier: timeZone.identifier
        )
    }

    var secondaryClockLocation: UrksSharedClockLocation? {
        guard widgetSecondaryClockEnabled else {
            return nil
        }

        guard
            let identifier = secondaryTimeZoneIdentifier?.trimmingCharacters(in: .whitespacesAndNewlines),
            !identifier.isEmpty,
            let timeZone = TimeZone(identifier: identifier)
        else {
            return nil
        }

        let city = (secondaryCityName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false)
            ? secondaryCityName!.trimmingCharacters(in: .whitespacesAndNewlines)
            : Self.defaultCityName(for: timeZone)

        if timeZone.identifier == primaryClockLocation.timeZoneIdentifier {
            return nil
        }

        return UrksSharedClockLocation(
            cityName: city,
            timeZoneIdentifier: timeZone.identifier
        )
    }

    static func defaultCityName(for timeZone: TimeZone) -> String {
        let identifier = timeZone.identifier

        if identifier == "UTC" || identifier == "GMT" {
            return "UTC"
        }

        let components = identifier.split(separator: "/")
        if let last = components.last, !last.isEmpty {
            return last.replacingOccurrences(of: "_", with: " ")
        }

        return localizedUrksSharedValue("city.default.local", fallback: "Lokal")
    }
}

enum UrksSharedWidgetSettings {
    static func loadHandPalette(for colorScheme: ColorScheme) -> UrksSharedHandPalette {
        guard
            let suiteName = UrksSharedConfig.appGroupSuiteName,
            !suiteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            let defaults = UserDefaults(suiteName: suiteName)
        else {
            return .fallback
        }

        switch colorScheme {
        case .light:
            return UrksSharedHandPalette(
                hourTensColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.hourTensColorRed,
                    greenKey: ClockStorageKeys.hourTensColorGreen,
                    blueKey: ClockStorageKeys.hourTensColorBlue,
                    fallback: UrksSharedHandPalette.fallback.hourTensColor
                ),
                hourOnesColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.hourOnesColorRed,
                    greenKey: ClockStorageKeys.hourOnesColorGreen,
                    blueKey: ClockStorageKeys.hourOnesColorBlue,
                    fallback: UrksSharedHandPalette.fallback.hourOnesColor
                ),
                minuteTensColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.minuteTensColorRed,
                    greenKey: ClockStorageKeys.minuteTensColorGreen,
                    blueKey: ClockStorageKeys.minuteTensColorBlue,
                    fallback: UrksSharedHandPalette.fallback.minuteTensColor
                ),
                minuteOnesColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.minuteOnesColorRed,
                    greenKey: ClockStorageKeys.minuteOnesColorGreen,
                    blueKey: ClockStorageKeys.minuteOnesColorBlue,
                    fallback: UrksSharedHandPalette.fallback.minuteOnesColor
                ),
                secondTensColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.secondTensColorRed,
                    greenKey: ClockStorageKeys.secondTensColorGreen,
                    blueKey: ClockStorageKeys.secondTensColorBlue,
                    fallback: UrksSharedHandPalette.fallback.secondTensColor
                ),
                secondOnesColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.secondOnesColorRed,
                    greenKey: ClockStorageKeys.secondOnesColorGreen,
                    blueKey: ClockStorageKeys.secondOnesColorBlue,
                    fallback: UrksSharedHandPalette.fallback.secondOnesColor
                )
            )
        case .dark:
            return UrksSharedHandPalette(
                hourTensColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.darkHourTensColorRed,
                    greenKey: ClockStorageKeys.darkHourTensColorGreen,
                    blueKey: ClockStorageKeys.darkHourTensColorBlue,
                    fallback: readColor(
                        defaults: defaults,
                        redKey: ClockStorageKeys.hourTensColorRed,
                        greenKey: ClockStorageKeys.hourTensColorGreen,
                        blueKey: ClockStorageKeys.hourTensColorBlue,
                        fallback: UrksSharedHandPalette.fallback.hourTensColor
                    )
                ),
                hourOnesColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.darkHourOnesColorRed,
                    greenKey: ClockStorageKeys.darkHourOnesColorGreen,
                    blueKey: ClockStorageKeys.darkHourOnesColorBlue,
                    fallback: readColor(
                        defaults: defaults,
                        redKey: ClockStorageKeys.hourOnesColorRed,
                        greenKey: ClockStorageKeys.hourOnesColorGreen,
                        blueKey: ClockStorageKeys.hourOnesColorBlue,
                        fallback: UrksSharedHandPalette.fallback.hourOnesColor
                    )
                ),
                minuteTensColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.darkMinuteTensColorRed,
                    greenKey: ClockStorageKeys.darkMinuteTensColorGreen,
                    blueKey: ClockStorageKeys.darkMinuteTensColorBlue,
                    fallback: readColor(
                        defaults: defaults,
                        redKey: ClockStorageKeys.minuteTensColorRed,
                        greenKey: ClockStorageKeys.minuteTensColorGreen,
                        blueKey: ClockStorageKeys.minuteTensColorBlue,
                        fallback: UrksSharedHandPalette.fallback.minuteTensColor
                    )
                ),
                minuteOnesColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.darkMinuteOnesColorRed,
                    greenKey: ClockStorageKeys.darkMinuteOnesColorGreen,
                    blueKey: ClockStorageKeys.darkMinuteOnesColorBlue,
                    fallback: readColor(
                        defaults: defaults,
                        redKey: ClockStorageKeys.minuteOnesColorRed,
                        greenKey: ClockStorageKeys.minuteOnesColorGreen,
                        blueKey: ClockStorageKeys.minuteOnesColorBlue,
                        fallback: UrksSharedHandPalette.fallback.minuteOnesColor
                    )
                ),
                secondTensColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.darkSecondTensColorRed,
                    greenKey: ClockStorageKeys.darkSecondTensColorGreen,
                    blueKey: ClockStorageKeys.darkSecondTensColorBlue,
                    fallback: readColor(
                        defaults: defaults,
                        redKey: ClockStorageKeys.secondTensColorRed,
                        greenKey: ClockStorageKeys.secondTensColorGreen,
                        blueKey: ClockStorageKeys.secondTensColorBlue,
                        fallback: UrksSharedHandPalette.fallback.secondTensColor
                    )
                ),
                secondOnesColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.darkSecondOnesColorRed,
                    greenKey: ClockStorageKeys.darkSecondOnesColorGreen,
                    blueKey: ClockStorageKeys.darkSecondOnesColorBlue,
                    fallback: readColor(
                        defaults: defaults,
                        redKey: ClockStorageKeys.secondOnesColorRed,
                        greenKey: ClockStorageKeys.secondOnesColorGreen,
                        blueKey: ClockStorageKeys.secondOnesColorBlue,
                        fallback: UrksSharedHandPalette.fallback.secondOnesColor
                    )
                )
            )
        @unknown default:
            return loadHandPalette(for: .light)
        }
    }

    static func loadSurfacePalette(for colorScheme: ColorScheme) -> UrksSharedSurfacePalette {
        guard
            let suiteName = UrksSharedConfig.appGroupSuiteName,
            !suiteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            let defaults = UserDefaults(suiteName: suiteName)
        else {
            return colorScheme == .dark ? .darkFallback : .lightFallback
        }

        switch colorScheme {
        case .light:
            return UrksSharedSurfacePalette(
                markingColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.lightMarkingColorRed,
                    greenKey: ClockStorageKeys.lightMarkingColorGreen,
                    blueKey: ClockStorageKeys.lightMarkingColorBlue,
                    fallback: UrksSharedSurfacePalette.lightFallback.markingColor
                ),
                ringColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.lightRingColorRed,
                    greenKey: ClockStorageKeys.lightRingColorGreen,
                    blueKey: ClockStorageKeys.lightRingColorBlue,
                    fallback: UrksSharedSurfacePalette.lightFallback.ringColor
                ),
                dialBackgroundColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.lightDialBackgroundColorRed,
                    greenKey: ClockStorageKeys.lightDialBackgroundColorGreen,
                    blueKey: ClockStorageKeys.lightDialBackgroundColorBlue,
                    fallback: UrksSharedSurfacePalette.lightFallback.dialBackgroundColor
                ),
                appBackgroundColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.lightAppBackgroundColorRed,
                    greenKey: ClockStorageKeys.lightAppBackgroundColorGreen,
                    blueKey: ClockStorageKeys.lightAppBackgroundColorBlue,
                    fallback: UrksSharedSurfacePalette.lightFallback.appBackgroundColor
                )
            )
        case .dark:
            return UrksSharedSurfacePalette(
                markingColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.darkMarkingColorRed,
                    greenKey: ClockStorageKeys.darkMarkingColorGreen,
                    blueKey: ClockStorageKeys.darkMarkingColorBlue,
                    fallback: UrksSharedSurfacePalette.darkFallback.markingColor
                ),
                ringColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.darkRingColorRed,
                    greenKey: ClockStorageKeys.darkRingColorGreen,
                    blueKey: ClockStorageKeys.darkRingColorBlue,
                    fallback: UrksSharedSurfacePalette.darkFallback.ringColor
                ),
                dialBackgroundColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.darkDialBackgroundColorRed,
                    greenKey: ClockStorageKeys.darkDialBackgroundColorGreen,
                    blueKey: ClockStorageKeys.darkDialBackgroundColorBlue,
                    fallback: UrksSharedSurfacePalette.darkFallback.dialBackgroundColor
                ),
                appBackgroundColor: readColor(
                    defaults: defaults,
                    redKey: ClockStorageKeys.darkAppBackgroundColorRed,
                    greenKey: ClockStorageKeys.darkAppBackgroundColorGreen,
                    blueKey: ClockStorageKeys.darkAppBackgroundColorBlue,
                    fallback: UrksSharedSurfacePalette.darkFallback.appBackgroundColor
                )
            )
        @unknown default:
            return loadSurfacePalette(for: .light)
        }
    }

    static func loadHandMetrics() -> UrksSharedHandMetrics {
        guard
            let suiteName = UrksSharedConfig.appGroupSuiteName,
            !suiteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            let defaults = UserDefaults(suiteName: suiteName)
        else {
            return .fallback
        }

        return UrksSharedHandMetrics(
            hourTensWidth: readDouble(defaults: defaults, key: ClockStorageKeys.hourTensWidthRatio, fallback: UrksSharedHandMetrics.fallback.hourTensWidth),
            hourOnesWidth: readDouble(defaults: defaults, key: ClockStorageKeys.hourOnesWidthRatio, fallback: UrksSharedHandMetrics.fallback.hourOnesWidth),
            minuteTensWidth: readDouble(defaults: defaults, key: ClockStorageKeys.minuteTensWidthRatio, fallback: UrksSharedHandMetrics.fallback.minuteTensWidth),
            minuteOnesWidth: readDouble(defaults: defaults, key: ClockStorageKeys.minuteOnesWidthRatio, fallback: UrksSharedHandMetrics.fallback.minuteOnesWidth),
            secondTensWidth: readDouble(defaults: defaults, key: ClockStorageKeys.secondTensWidthRatio, fallback: UrksSharedHandMetrics.fallback.secondTensWidth),
            secondOnesWidth: readDouble(defaults: defaults, key: ClockStorageKeys.secondOnesWidthRatio, fallback: UrksSharedHandMetrics.fallback.secondOnesWidth),
            hourTensLength: readDouble(defaults: defaults, key: ClockStorageKeys.hourTensLengthRatio, fallback: UrksSharedHandMetrics.fallback.hourTensLength),
            hourOnesLength: readDouble(defaults: defaults, key: ClockStorageKeys.hourOnesLengthRatio, fallback: UrksSharedHandMetrics.fallback.hourOnesLength),
            minuteTensLength: readDouble(defaults: defaults, key: ClockStorageKeys.minuteTensLengthRatio, fallback: UrksSharedHandMetrics.fallback.minuteTensLength),
            minuteOnesLength: readDouble(defaults: defaults, key: ClockStorageKeys.minuteOnesLengthRatio, fallback: UrksSharedHandMetrics.fallback.minuteOnesLength),
            secondTensLength: readDouble(defaults: defaults, key: ClockStorageKeys.secondTensLengthRatio, fallback: UrksSharedHandMetrics.fallback.secondTensLength),
            secondOnesLength: readDouble(defaults: defaults, key: ClockStorageKeys.secondOnesLengthRatio, fallback: UrksSharedHandMetrics.fallback.secondOnesLength)
        )
    }

    static func loadWidgetOptions() -> UrksSharedWidgetOptions {
        guard
            let suiteName = UrksSharedConfig.appGroupSuiteName,
            !suiteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            let defaults = UserDefaults(suiteName: suiteName)
        else {
            return .fallback
        }

        let fallbackPrimaryTimeZone = TimeZone.current.identifier
        let fallbackPrimaryCity = UrksSharedWidgetOptions.defaultCityName(for: TimeZone.current)

        return UrksSharedWidgetOptions(
            displayModeRaw: readString(
                defaults: defaults,
                key: ClockStorageKeys.clockModeRaw,
                fallback: UrksSharedWidgetOptions.fallback.displayModeRaw
            ),
            integerOnly: readBool(
                defaults: defaults,
                key: ClockStorageKeys.integerOnly,
                fallback: UrksSharedWidgetOptions.fallback.integerOnly
            ),
            continuousMinuteOnesInIntegerMode: readBool(
                defaults: defaults,
                key: ClockStorageKeys.continuousMinuteOnesInIntegerMode,
                fallback: UrksSharedWidgetOptions.fallback.continuousMinuteOnesInIntegerMode
            ),
            continuousSecondOnesInIntegerMode: readBool(
                defaults: defaults,
                key: ClockStorageKeys.continuousSecondOnesInIntegerMode,
                fallback: UrksSharedWidgetOptions.fallback.continuousSecondOnesInIntegerMode
            ),
            dialMarkingModeRaw: readString(
                defaults: defaults,
                key: ClockStorageKeys.dialMarkingModeRaw,
                fallback: UrksSharedWidgetOptions.fallback.dialMarkingModeRaw
            ),
            legacyShowDigits: readBool(
                defaults: defaults,
                key: ClockStorageKeys.legacyShowDigits,
                fallback: UrksSharedWidgetOptions.fallback.legacyShowDigits
            ),
            legacyShowTicks: readBool(
                defaults: defaults,
                key: ClockStorageKeys.legacyShowTicks,
                fallback: UrksSharedWidgetOptions.fallback.legacyShowTicks
            ),
            appearanceModeRaw: readString(
                defaults: defaults,
                key: ClockStorageKeys.appearanceModeRaw,
                fallback: UrksSharedWidgetOptions.fallback.appearanceModeRaw
            ),
            primaryCityName: readString(
                defaults: defaults,
                key: ClockStorageKeys.widgetPrimaryCityName,
                fallback: fallbackPrimaryCity
            ),
            primaryTimeZoneIdentifier: readString(
                defaults: defaults,
                key: ClockStorageKeys.widgetPrimaryTimeZoneIdentifier,
                fallback: fallbackPrimaryTimeZone
            ),
            widgetSecondaryClockEnabled: readBool(
                defaults: defaults,
                key: ClockStorageKeys.widgetSecondaryClockEnabled,
                fallback: UrksSharedWidgetOptions.fallback.widgetSecondaryClockEnabled
            ),
            secondaryCityName: readOptionalString(
                defaults: defaults,
                key: ClockStorageKeys.widgetSecondaryCityName
            ),
            secondaryTimeZoneIdentifier: readOptionalString(
                defaults: defaults,
                key: ClockStorageKeys.widgetSecondaryTimeZoneIdentifier
            )
        )
    }

    private static func readColor(
        defaults: UserDefaults,
        redKey: String,
        greenKey: String,
        blueKey: String,
        fallback: UrksSharedStoredColor
    ) -> UrksSharedStoredColor {
        guard
            let redValue = defaults.object(forKey: redKey) as? NSNumber,
            let greenValue = defaults.object(forKey: greenKey) as? NSNumber,
            let blueValue = defaults.object(forKey: blueKey) as? NSNumber
        else {
            return fallback
        }

        return UrksSharedStoredColor(
            red: redValue.doubleValue,
            green: greenValue.doubleValue,
            blue: blueValue.doubleValue
        )
    }

    private static func readBool(
        defaults: UserDefaults,
        key: String,
        fallback: Bool
    ) -> Bool {
        guard let number = defaults.object(forKey: key) as? NSNumber else {
            return fallback
        }
        return number.boolValue
    }

    private static func readDouble(
        defaults: UserDefaults,
        key: String,
        fallback: Double
    ) -> Double {
        guard let number = defaults.object(forKey: key) as? NSNumber else {
            return fallback
        }
        return number.doubleValue
    }

    private static func readString(
        defaults: UserDefaults,
        key: String,
        fallback: String
    ) -> String {
        defaults.string(forKey: key) ?? fallback
    }

    private static func readOptionalString(
        defaults: UserDefaults,
        key: String
    ) -> String? {
        guard let value = defaults.string(forKey: key) else {
            return nil
        }

        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}

struct UrksSharedSnapshot {
    let hour: Int
    let minute: Int
    let second: Int

    let hourTensDigit: Int
    let hourOnesDigit: Int
    let minuteTensDigit: Int
    let minuteOnesDigit: Int
    let secondTensDigit: Int
    let secondOnesDigit: Int

    let hourTensSlot: Double
    let hourOnesSlot: Double
    let minuteTensSlot: Double
    let minuteOnesSlot: Double
    let secondTensSlot: Double
    let secondOnesSlot: Double

    var hourMinuteText: String {
        String(format: "%02d:%02d", hour, minute)
    }

    var standardTimeText: String {
        let format = localizedUrksSharedFormat("widget.standardTimeFormat", fallback: "Standard %1$02d:%2$02d")
        return String(format: format, locale: Locale.current, hour, minute)
    }

    init(
        date: Date,
        timeZone: TimeZone = .current,
        integerOnly: Bool = false,
        continuousMinuteOnesInIntegerMode: Bool = false,
        continuousSecondOnesInIntegerMode: Bool = false
    ) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone

        let components = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: date)

        let resolvedHour = components.hour ?? 0
        let resolvedMinute = components.minute ?? 0
        let resolvedSecond = components.second ?? 0
        let resolvedNanosecond = components.nanosecond ?? 0

        hour = resolvedHour
        minute = resolvedMinute
        second = resolvedSecond

        hourTensDigit = resolvedHour / 10
        hourOnesDigit = resolvedHour % 10
        minuteTensDigit = resolvedMinute / 10
        minuteOnesDigit = resolvedMinute % 10
        secondTensDigit = resolvedSecond / 10
        secondOnesDigit = resolvedSecond % 10

        let fractionalSecond = max(0.0, min(0.999_999, Double(resolvedNanosecond) / 1_000_000_000.0))
        let preciseSecond = Double(resolvedSecond) + fractionalSecond
        let preciseMinute = Double(resolvedMinute) + preciseSecond / 60.0
        let preciseHour = Double(resolvedHour) + preciseMinute / 60.0

        if integerOnly {
            hourTensSlot = Double(hourTensDigit)
            hourOnesSlot = Double(hourOnesDigit)
            minuteTensSlot = Double(minuteTensDigit)
            minuteOnesSlot = continuousMinuteOnesInIntegerMode ? preciseMinute : Double(minuteOnesDigit)
            secondTensSlot = Double(secondTensDigit)
            secondOnesSlot = continuousSecondOnesInIntegerMode ? preciseSecond : Double(secondOnesDigit)
        } else {
            hourTensSlot = preciseHour / 10.0
            hourOnesSlot = preciseHour
            minuteTensSlot = preciseMinute / 10.0
            minuteOnesSlot = preciseMinute
            secondTensSlot = preciseSecond / 10.0
            secondOnesSlot = preciseSecond
        }
    }
}

func urksSlotAngle(for slot: Double, rotationSlotOffset: Double = 0.0) -> Angle {
    UrksSharedGeometry.slotAngle(for: slot, rotationSlotOffset: rotationSlotOffset)
}

func urksPointOnCircle(center: CGPoint, radius: CGFloat, angle: Angle) -> CGPoint {
    UrksSharedGeometry.pointOnCircle(center: center, radius: radius, angle: angle)
}
