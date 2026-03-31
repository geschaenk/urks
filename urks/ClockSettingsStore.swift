/* /Users/drebin/Documents/software/urks/urks/ClockSettingsStore.swift */
import Foundation
import SwiftUI
import Combine

private func readStoredBool(_ defaults: UserDefaults, key: String, fallback: Bool) -> Bool {
    guard let value = defaults.object(forKey: key) as? NSNumber else {
        return fallback
    }
    return value.boolValue
}

private func readStoredDouble(_ defaults: UserDefaults, key: String, fallback: Double) -> Double {
    guard let value = defaults.object(forKey: key) as? NSNumber else {
        return fallback
    }
    return value.doubleValue
}

private func readStoredInt(_ defaults: UserDefaults, key: String, fallback: Int) -> Int {
    guard let value = defaults.object(forKey: key) as? NSNumber else {
        return fallback
    }
    return value.intValue
}

private func readStoredColor(
    _ defaults: UserDefaults,
    redKey: String,
    greenKey: String,
    blueKey: String,
    fallback: StoredClockColor
) -> StoredClockColor {
    StoredClockColor(
        red: readStoredDouble(defaults, key: redKey, fallback: fallback.red),
        green: readStoredDouble(defaults, key: greenKey, fallback: fallback.green),
        blue: readStoredDouble(defaults, key: blueKey, fallback: fallback.blue)
    )
}

private func writeStoredColor(
    _ color: StoredClockColor,
    defaults: UserDefaults,
    redKey: String,
    greenKey: String,
    blueKey: String
) {
    defaults.set(color.red, forKey: redKey)
    defaults.set(color.green, forKey: greenKey)
    defaults.set(color.blue, forKey: blueKey)
}

struct ClockHandMetricState {
    var hourTensWidth: Double
    var hourOnesWidth: Double
    var minuteTensWidth: Double
    var minuteOnesWidth: Double
    var secondTensWidth: Double
    var secondOnesWidth: Double

    var hourTensLength: Double
    var hourOnesLength: Double
    var minuteTensLength: Double
    var minuteOnesLength: Double
    var secondTensLength: Double
    var secondOnesLength: Double

    init(defaults: UserDefaults = .standard) {
        hourTensWidth = readStoredDouble(defaults, key: ClockStorageKeys.hourTensWidthRatio, fallback: ClockDefaults.hourTensWidth)
        hourOnesWidth = readStoredDouble(defaults, key: ClockStorageKeys.hourOnesWidthRatio, fallback: ClockDefaults.hourOnesWidth)
        minuteTensWidth = readStoredDouble(defaults, key: ClockStorageKeys.minuteTensWidthRatio, fallback: ClockDefaults.minuteTensWidth)
        minuteOnesWidth = readStoredDouble(defaults, key: ClockStorageKeys.minuteOnesWidthRatio, fallback: ClockDefaults.minuteOnesWidth)
        secondTensWidth = readStoredDouble(defaults, key: ClockStorageKeys.secondTensWidthRatio, fallback: ClockDefaults.secondTensWidth)
        secondOnesWidth = readStoredDouble(defaults, key: ClockStorageKeys.secondOnesWidthRatio, fallback: ClockDefaults.secondOnesWidth)

        hourTensLength = readStoredDouble(defaults, key: ClockStorageKeys.hourTensLengthRatio, fallback: ClockDefaults.hourTensLength)
        hourOnesLength = readStoredDouble(defaults, key: ClockStorageKeys.hourOnesLengthRatio, fallback: ClockDefaults.hourOnesLength)
        minuteTensLength = readStoredDouble(defaults, key: ClockStorageKeys.minuteTensLengthRatio, fallback: ClockDefaults.minuteTensLength)
        minuteOnesLength = readStoredDouble(defaults, key: ClockStorageKeys.minuteOnesLengthRatio, fallback: ClockDefaults.minuteOnesLength)
        secondTensLength = readStoredDouble(defaults, key: ClockStorageKeys.secondTensLengthRatio, fallback: ClockDefaults.secondTensLength)
        secondOnesLength = readStoredDouble(defaults, key: ClockStorageKeys.secondOnesLengthRatio, fallback: ClockDefaults.secondOnesLength)
    }

    func persist(to defaults: UserDefaults) {
        defaults.set(hourTensWidth, forKey: ClockStorageKeys.hourTensWidthRatio)
        defaults.set(hourOnesWidth, forKey: ClockStorageKeys.hourOnesWidthRatio)
        defaults.set(minuteTensWidth, forKey: ClockStorageKeys.minuteTensWidthRatio)
        defaults.set(minuteOnesWidth, forKey: ClockStorageKeys.minuteOnesWidthRatio)
        defaults.set(secondTensWidth, forKey: ClockStorageKeys.secondTensWidthRatio)
        defaults.set(secondOnesWidth, forKey: ClockStorageKeys.secondOnesWidthRatio)

        defaults.set(hourTensLength, forKey: ClockStorageKeys.hourTensLengthRatio)
        defaults.set(hourOnesLength, forKey: ClockStorageKeys.hourOnesLengthRatio)
        defaults.set(minuteTensLength, forKey: ClockStorageKeys.minuteTensLengthRatio)
        defaults.set(minuteOnesLength, forKey: ClockStorageKeys.minuteOnesLengthRatio)
        defaults.set(secondTensLength, forKey: ClockStorageKeys.secondTensLengthRatio)
        defaults.set(secondOnesLength, forKey: ClockStorageKeys.secondOnesLengthRatio)
    }
}

struct ClockHandColorThemeState {
    var hourTensColor: StoredClockColor
    var hourOnesColor: StoredClockColor
    var minuteTensColor: StoredClockColor
    var minuteOnesColor: StoredClockColor
    var secondTensColor: StoredClockColor
    var secondOnesColor: StoredClockColor

    init(defaults: UserDefaults = .standard, usesDarkKeys: Bool) {
        if usesDarkKeys {
            hourTensColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.darkHourTensColorRed,
                greenKey: ClockStorageKeys.darkHourTensColorGreen,
                blueKey: ClockStorageKeys.darkHourTensColorBlue,
                fallback: ClockDefaults.hourTensColor
            )
            hourOnesColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.darkHourOnesColorRed,
                greenKey: ClockStorageKeys.darkHourOnesColorGreen,
                blueKey: ClockStorageKeys.darkHourOnesColorBlue,
                fallback: ClockDefaults.hourOnesColor
            )
            minuteTensColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.darkMinuteTensColorRed,
                greenKey: ClockStorageKeys.darkMinuteTensColorGreen,
                blueKey: ClockStorageKeys.darkMinuteTensColorBlue,
                fallback: ClockDefaults.minuteTensColor
            )
            minuteOnesColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.darkMinuteOnesColorRed,
                greenKey: ClockStorageKeys.darkMinuteOnesColorGreen,
                blueKey: ClockStorageKeys.darkMinuteOnesColorBlue,
                fallback: ClockDefaults.minuteOnesColor
            )
            secondTensColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.darkSecondTensColorRed,
                greenKey: ClockStorageKeys.darkSecondTensColorGreen,
                blueKey: ClockStorageKeys.darkSecondTensColorBlue,
                fallback: ClockDefaults.secondTensColor
            )
            secondOnesColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.darkSecondOnesColorRed,
                greenKey: ClockStorageKeys.darkSecondOnesColorGreen,
                blueKey: ClockStorageKeys.darkSecondOnesColorBlue,
                fallback: ClockDefaults.secondOnesColor
            )
        } else {
            hourTensColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.hourTensColorRed,
                greenKey: ClockStorageKeys.hourTensColorGreen,
                blueKey: ClockStorageKeys.hourTensColorBlue,
                fallback: ClockDefaults.hourTensColor
            )
            hourOnesColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.hourOnesColorRed,
                greenKey: ClockStorageKeys.hourOnesColorGreen,
                blueKey: ClockStorageKeys.hourOnesColorBlue,
                fallback: ClockDefaults.hourOnesColor
            )
            minuteTensColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.minuteTensColorRed,
                greenKey: ClockStorageKeys.minuteTensColorGreen,
                blueKey: ClockStorageKeys.minuteTensColorBlue,
                fallback: ClockDefaults.minuteTensColor
            )
            minuteOnesColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.minuteOnesColorRed,
                greenKey: ClockStorageKeys.minuteOnesColorGreen,
                blueKey: ClockStorageKeys.minuteOnesColorBlue,
                fallback: ClockDefaults.minuteOnesColor
            )
            secondTensColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.secondTensColorRed,
                greenKey: ClockStorageKeys.secondTensColorGreen,
                blueKey: ClockStorageKeys.secondTensColorBlue,
                fallback: ClockDefaults.secondTensColor
            )
            secondOnesColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.secondOnesColorRed,
                greenKey: ClockStorageKeys.secondOnesColorGreen,
                blueKey: ClockStorageKeys.secondOnesColorBlue,
                fallback: ClockDefaults.secondOnesColor
            )
        }
    }

    func persist(to defaults: UserDefaults, usesDarkKeys: Bool) {
        if usesDarkKeys {
            writeStoredColor(
                hourTensColor,
                defaults: defaults,
                redKey: ClockStorageKeys.darkHourTensColorRed,
                greenKey: ClockStorageKeys.darkHourTensColorGreen,
                blueKey: ClockStorageKeys.darkHourTensColorBlue
            )
            writeStoredColor(
                hourOnesColor,
                defaults: defaults,
                redKey: ClockStorageKeys.darkHourOnesColorRed,
                greenKey: ClockStorageKeys.darkHourOnesColorGreen,
                blueKey: ClockStorageKeys.darkHourOnesColorBlue
            )
            writeStoredColor(
                minuteTensColor,
                defaults: defaults,
                redKey: ClockStorageKeys.darkMinuteTensColorRed,
                greenKey: ClockStorageKeys.darkMinuteTensColorGreen,
                blueKey: ClockStorageKeys.darkMinuteTensColorBlue
            )
            writeStoredColor(
                minuteOnesColor,
                defaults: defaults,
                redKey: ClockStorageKeys.darkMinuteOnesColorRed,
                greenKey: ClockStorageKeys.darkMinuteOnesColorGreen,
                blueKey: ClockStorageKeys.darkMinuteOnesColorBlue
            )
            writeStoredColor(
                secondTensColor,
                defaults: defaults,
                redKey: ClockStorageKeys.darkSecondTensColorRed,
                greenKey: ClockStorageKeys.darkSecondTensColorGreen,
                blueKey: ClockStorageKeys.darkSecondTensColorBlue
            )
            writeStoredColor(
                secondOnesColor,
                defaults: defaults,
                redKey: ClockStorageKeys.darkSecondOnesColorRed,
                greenKey: ClockStorageKeys.darkSecondOnesColorGreen,
                blueKey: ClockStorageKeys.darkSecondOnesColorBlue
            )
        } else {
            writeStoredColor(
                hourTensColor,
                defaults: defaults,
                redKey: ClockStorageKeys.hourTensColorRed,
                greenKey: ClockStorageKeys.hourTensColorGreen,
                blueKey: ClockStorageKeys.hourTensColorBlue
            )
            writeStoredColor(
                hourOnesColor,
                defaults: defaults,
                redKey: ClockStorageKeys.hourOnesColorRed,
                greenKey: ClockStorageKeys.hourOnesColorGreen,
                blueKey: ClockStorageKeys.hourOnesColorBlue
            )
            writeStoredColor(
                minuteTensColor,
                defaults: defaults,
                redKey: ClockStorageKeys.minuteTensColorRed,
                greenKey: ClockStorageKeys.minuteTensColorGreen,
                blueKey: ClockStorageKeys.minuteTensColorBlue
            )
            writeStoredColor(
                minuteOnesColor,
                defaults: defaults,
                redKey: ClockStorageKeys.minuteOnesColorRed,
                greenKey: ClockStorageKeys.minuteOnesColorGreen,
                blueKey: ClockStorageKeys.minuteOnesColorBlue
            )
            writeStoredColor(
                secondTensColor,
                defaults: defaults,
                redKey: ClockStorageKeys.secondTensColorRed,
                greenKey: ClockStorageKeys.secondTensColorGreen,
                blueKey: ClockStorageKeys.secondTensColorBlue
            )
            writeStoredColor(
                secondOnesColor,
                defaults: defaults,
                redKey: ClockStorageKeys.secondOnesColorRed,
                greenKey: ClockStorageKeys.secondOnesColorGreen,
                blueKey: ClockStorageKeys.secondOnesColorBlue
            )
        }
    }
}

struct ClockSurfaceColorThemeState {
    var markingColor: StoredClockColor
    var ringColor: StoredClockColor
    var dialBackgroundColor: StoredClockColor
    var appBackgroundColor: StoredClockColor

    init(defaults: UserDefaults = .standard, usesDarkKeys: Bool) {
        if usesDarkKeys {
            markingColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.darkMarkingColorRed,
                greenKey: ClockStorageKeys.darkMarkingColorGreen,
                blueKey: ClockStorageKeys.darkMarkingColorBlue,
                fallback: ClockDefaults.darkMarkingColor
            )
            ringColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.darkRingColorRed,
                greenKey: ClockStorageKeys.darkRingColorGreen,
                blueKey: ClockStorageKeys.darkRingColorBlue,
                fallback: ClockDefaults.darkRingColor
            )
            dialBackgroundColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.darkDialBackgroundColorRed,
                greenKey: ClockStorageKeys.darkDialBackgroundColorGreen,
                blueKey: ClockStorageKeys.darkDialBackgroundColorBlue,
                fallback: ClockDefaults.darkDialBackgroundColor
            )
            appBackgroundColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.darkAppBackgroundColorRed,
                greenKey: ClockStorageKeys.darkAppBackgroundColorGreen,
                blueKey: ClockStorageKeys.darkAppBackgroundColorBlue,
                fallback: ClockDefaults.darkAppBackgroundColor
            )
        } else {
            markingColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.lightMarkingColorRed,
                greenKey: ClockStorageKeys.lightMarkingColorGreen,
                blueKey: ClockStorageKeys.lightMarkingColorBlue,
                fallback: ClockDefaults.lightMarkingColor
            )
            ringColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.lightRingColorRed,
                greenKey: ClockStorageKeys.lightRingColorGreen,
                blueKey: ClockStorageKeys.lightRingColorBlue,
                fallback: ClockDefaults.lightRingColor
            )
            dialBackgroundColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.lightDialBackgroundColorRed,
                greenKey: ClockStorageKeys.lightDialBackgroundColorGreen,
                blueKey: ClockStorageKeys.lightDialBackgroundColorBlue,
                fallback: ClockDefaults.lightDialBackgroundColor
            )
            appBackgroundColor = readStoredColor(
                defaults,
                redKey: ClockStorageKeys.lightAppBackgroundColorRed,
                greenKey: ClockStorageKeys.lightAppBackgroundColorGreen,
                blueKey: ClockStorageKeys.lightAppBackgroundColorBlue,
                fallback: ClockDefaults.lightAppBackgroundColor
            )
        }
    }

    func persist(to defaults: UserDefaults, usesDarkKeys: Bool) {
        if usesDarkKeys {
            writeStoredColor(
                markingColor,
                defaults: defaults,
                redKey: ClockStorageKeys.darkMarkingColorRed,
                greenKey: ClockStorageKeys.darkMarkingColorGreen,
                blueKey: ClockStorageKeys.darkMarkingColorBlue
            )
            writeStoredColor(
                ringColor,
                defaults: defaults,
                redKey: ClockStorageKeys.darkRingColorRed,
                greenKey: ClockStorageKeys.darkRingColorGreen,
                blueKey: ClockStorageKeys.darkRingColorBlue
            )
            writeStoredColor(
                dialBackgroundColor,
                defaults: defaults,
                redKey: ClockStorageKeys.darkDialBackgroundColorRed,
                greenKey: ClockStorageKeys.darkDialBackgroundColorGreen,
                blueKey: ClockStorageKeys.darkDialBackgroundColorBlue
            )
            writeStoredColor(
                appBackgroundColor,
                defaults: defaults,
                redKey: ClockStorageKeys.darkAppBackgroundColorRed,
                greenKey: ClockStorageKeys.darkAppBackgroundColorGreen,
                blueKey: ClockStorageKeys.darkAppBackgroundColorBlue
            )
        } else {
            writeStoredColor(
                markingColor,
                defaults: defaults,
                redKey: ClockStorageKeys.lightMarkingColorRed,
                greenKey: ClockStorageKeys.lightMarkingColorGreen,
                blueKey: ClockStorageKeys.lightMarkingColorBlue
            )
            writeStoredColor(
                ringColor,
                defaults: defaults,
                redKey: ClockStorageKeys.lightRingColorRed,
                greenKey: ClockStorageKeys.lightRingColorGreen,
                blueKey: ClockStorageKeys.lightRingColorBlue
            )
            writeStoredColor(
                dialBackgroundColor,
                defaults: defaults,
                redKey: ClockStorageKeys.lightDialBackgroundColorRed,
                greenKey: ClockStorageKeys.lightDialBackgroundColorGreen,
                blueKey: ClockStorageKeys.lightDialBackgroundColorBlue
            )
            writeStoredColor(
                appBackgroundColor,
                defaults: defaults,
                redKey: ClockStorageKeys.lightAppBackgroundColorRed,
                greenKey: ClockStorageKeys.lightAppBackgroundColorGreen,
                blueKey: ClockStorageKeys.lightAppBackgroundColorBlue
            )
        }
    }
}

struct ClockWidgetLocationState {
    var timeZoneIdentifier: String
    var cityName: String

    init(timeZoneIdentifier: String, cityName: String) {
        self.timeZoneIdentifier = timeZoneIdentifier
        self.cityName = cityName
    }

    init(defaults: UserDefaults = .standard, timeZoneKey: String, cityKey: String, fallbackTimeZoneIdentifier: String, fallbackCityName: String) {
        timeZoneIdentifier = defaults.string(forKey: timeZoneKey) ?? fallbackTimeZoneIdentifier
        cityName = defaults.string(forKey: cityKey) ?? fallbackCityName
    }

    func persist(to defaults: UserDefaults, timeZoneKey: String, cityKey: String) {
        defaults.set(timeZoneIdentifier, forKey: timeZoneKey)
        defaults.set(cityName, forKey: cityKey)
    }
}

struct ClockSettingsState {
    var appearanceModeRaw: String
    var legacyShowDigits: Bool
    var legacyShowTicks: Bool
    var dialMarkingModeRaw: String
    var clockModeRaw: String
    var integerOnly: Bool
    var continuousMinuteOnesInIntegerMode: Bool
    var continuousSecondOnesInIntegerMode: Bool
    var clockColorCustomizationMigrationVersion: Int

    var handMetrics: ClockHandMetricState
    var lightHandTheme: ClockHandColorThemeState
    var darkHandTheme: ClockHandColorThemeState
    var lightSurfaceTheme: ClockSurfaceColorThemeState
    var darkSurfaceTheme: ClockSurfaceColorThemeState

    var widgetPrimaryLocation: ClockWidgetLocationState
    var widgetSecondaryClockEnabled: Bool
    var widgetSecondaryLocation: ClockWidgetLocationState

    init(defaults: UserDefaults = .standard) {
        appearanceModeRaw = defaults.string(forKey: ClockStorageKeys.appearanceModeRaw) ?? ClockDefaults.appearanceMode.rawValue
        legacyShowDigits = readStoredBool(defaults, key: ClockStorageKeys.legacyShowDigits, fallback: ClockDefaults.showDigits)
        legacyShowTicks = readStoredBool(defaults, key: ClockStorageKeys.legacyShowTicks, fallback: ClockDefaults.showTicks)
        dialMarkingModeRaw = defaults.string(forKey: ClockStorageKeys.dialMarkingModeRaw)
            ?? (ClockDefaults.showDigits ? ClockDialMarkingMode.digits.rawValue : ClockDialMarkingMode.ticks.rawValue)
        clockModeRaw = defaults.string(forKey: ClockStorageKeys.clockModeRaw) ?? ClockDefaults.displayMode.rawValue
        integerOnly = readStoredBool(defaults, key: ClockStorageKeys.integerOnly, fallback: ClockDefaults.integerOnly)
        continuousMinuteOnesInIntegerMode = readStoredBool(
            defaults,
            key: ClockStorageKeys.continuousMinuteOnesInIntegerMode,
            fallback: ClockDefaults.continuousMinuteOnesInIntegerMode
        )
        continuousSecondOnesInIntegerMode = readStoredBool(
            defaults,
            key: ClockStorageKeys.continuousSecondOnesInIntegerMode,
            fallback: ClockDefaults.continuousSecondOnesInIntegerMode
        )
        clockColorCustomizationMigrationVersion = readStoredInt(
            defaults,
            key: ClockStorageKeys.colorCustomizationMigrationVersion,
            fallback: 0
        )

        handMetrics = ClockHandMetricState(defaults: defaults)
        lightHandTheme = ClockHandColorThemeState(defaults: defaults, usesDarkKeys: false)
        darkHandTheme = ClockHandColorThemeState(defaults: defaults, usesDarkKeys: true)
        lightSurfaceTheme = ClockSurfaceColorThemeState(defaults: defaults, usesDarkKeys: false)
        darkSurfaceTheme = ClockSurfaceColorThemeState(defaults: defaults, usesDarkKeys: true)

        let primaryTimeZone = defaults.string(forKey: ClockStorageKeys.widgetPrimaryTimeZoneIdentifier) ?? TimeZone.current.identifier
        let primaryCity = defaults.string(forKey: ClockStorageKeys.widgetPrimaryCityName) ?? widgetDefaultCityName(for: primaryTimeZone)
        widgetPrimaryLocation = ClockWidgetLocationState(
            timeZoneIdentifier: primaryTimeZone,
            cityName: primaryCity
        )

        widgetSecondaryClockEnabled = readStoredBool(
            defaults,
            key: ClockStorageKeys.widgetSecondaryClockEnabled,
            fallback: false
        )
        widgetSecondaryLocation = ClockWidgetLocationState(
            timeZoneIdentifier: defaults.string(forKey: ClockStorageKeys.widgetSecondaryTimeZoneIdentifier) ?? "UTC",
            cityName: defaults.string(forKey: ClockStorageKeys.widgetSecondaryCityName) ?? ""
        )
    }

    func persist(to defaults: UserDefaults) {
        defaults.set(appearanceModeRaw, forKey: ClockStorageKeys.appearanceModeRaw)
        defaults.set(legacyShowDigits, forKey: ClockStorageKeys.legacyShowDigits)
        defaults.set(legacyShowTicks, forKey: ClockStorageKeys.legacyShowTicks)
        defaults.set(dialMarkingModeRaw, forKey: ClockStorageKeys.dialMarkingModeRaw)
        defaults.set(clockModeRaw, forKey: ClockStorageKeys.clockModeRaw)
        defaults.set(integerOnly, forKey: ClockStorageKeys.integerOnly)
        defaults.set(continuousMinuteOnesInIntegerMode, forKey: ClockStorageKeys.continuousMinuteOnesInIntegerMode)
        defaults.set(continuousSecondOnesInIntegerMode, forKey: ClockStorageKeys.continuousSecondOnesInIntegerMode)
        defaults.set(clockColorCustomizationMigrationVersion, forKey: ClockStorageKeys.colorCustomizationMigrationVersion)

        handMetrics.persist(to: defaults)
        lightHandTheme.persist(to: defaults, usesDarkKeys: false)
        darkHandTheme.persist(to: defaults, usesDarkKeys: true)
        lightSurfaceTheme.persist(to: defaults, usesDarkKeys: false)
        darkSurfaceTheme.persist(to: defaults, usesDarkKeys: true)

        widgetPrimaryLocation.persist(
            to: defaults,
            timeZoneKey: ClockStorageKeys.widgetPrimaryTimeZoneIdentifier,
            cityKey: ClockStorageKeys.widgetPrimaryCityName
        )
        defaults.set(widgetSecondaryClockEnabled, forKey: ClockStorageKeys.widgetSecondaryClockEnabled)
        widgetSecondaryLocation.persist(
            to: defaults,
            timeZoneKey: ClockStorageKeys.widgetSecondaryTimeZoneIdentifier,
            cityKey: ClockStorageKeys.widgetSecondaryCityName
        )
    }
}

@MainActor
final class ClockSettingsStore: ObservableObject {
    @Published var state: ClockSettingsState {
        didSet {
            guard !suppressPersistence else {
                return
            }
            state.persist(to: defaults)
        }
    }

    private let defaults: UserDefaults
    private var suppressPersistence = false

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.state = ClockSettingsState(defaults: defaults)
    }

    func performTransaction(_ updates: () -> Void) {
        suppressPersistence = true
        updates()
        suppressPersistence = false
        state.persist(to: defaults)
    }
}
