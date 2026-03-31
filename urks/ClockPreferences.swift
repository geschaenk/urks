/* /Users/drebin/Documents/software/urks/urks/ClockPreferences.swift */
import SwiftUI
import Foundation

struct ClockHandMetricPreferences: Equatable {
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

    func customization(with theme: ClockHandColorTheme) -> HandCustomization {
        HandCustomization(
            hourTensWidth: hourTensWidth,
            hourOnesWidth: hourOnesWidth,
            minuteTensWidth: minuteTensWidth,
            minuteOnesWidth: minuteOnesWidth,
            secondTensWidth: secondTensWidth,
            secondOnesWidth: secondOnesWidth,
            hourTensLength: hourTensLength,
            hourOnesLength: hourOnesLength,
            minuteTensLength: minuteTensLength,
            minuteOnesLength: minuteOnesLength,
            secondTensLength: secondTensLength,
            secondOnesLength: secondOnesLength,
            hourTensColor: theme.hourTensColor,
            hourOnesColor: theme.hourOnesColor,
            minuteTensColor: theme.minuteTensColor,
            minuteOnesColor: theme.minuteOnesColor,
            secondTensColor: theme.secondTensColor,
            secondOnesColor: theme.secondOnesColor
        )
    }
}

struct ClockHandColorTheme: Equatable {
    let hourTensColor: StoredClockColor
    let hourOnesColor: StoredClockColor
    let minuteTensColor: StoredClockColor
    let minuteOnesColor: StoredClockColor
    let secondTensColor: StoredClockColor
    let secondOnesColor: StoredClockColor
}

struct ClockWidgetLocationPreferences: Equatable {
    let cityName: String
    let timeZoneIdentifier: String

    var resolvedCityName: String {
        let trimmed = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? widgetDefaultCityName(for: timeZoneIdentifier) : trimmed
    }
}

struct ClockPreferences: Equatable {
    let appearanceModeRaw: String
    let legacyShowDigits: Bool
    let legacyShowTicks: Bool
    let dialMarkingModeRaw: String
    let clockModeRaw: String
    let integerOnly: Bool
    let continuousMinuteOnesInIntegerMode: Bool
    let continuousSecondOnesInIntegerMode: Bool

    let handMetrics: ClockHandMetricPreferences
    let lightHandTheme: ClockHandColorTheme
    let darkHandTheme: ClockHandColorTheme
    let lightSurfaceCustomization: ClockSurfaceCustomization
    let darkSurfaceCustomization: ClockSurfaceCustomization

    let widgetPrimaryLocation: ClockWidgetLocationPreferences
    let widgetSecondaryClockEnabled: Bool
    let widgetSecondaryLocation: ClockWidgetLocationPreferences

    static func resolvedDialMarkingMode(
        dialMarkingModeRaw: String,
        legacyShowDigits: Bool,
        legacyShowTicks: Bool
    ) -> ClockDialMarkingMode {
        if let storedMode = ClockDialMarkingMode(rawValue: dialMarkingModeRaw) {
            return storedMode
        }

        if legacyShowTicks && !legacyShowDigits {
            return .ticks
        }

        return .digits
    }

    var appearanceMode: ClockAppearanceMode {
        ClockAppearanceMode(rawValue: appearanceModeRaw) ?? .system
    }

    var dialMarkingMode: ClockDialMarkingMode {
        Self.resolvedDialMarkingMode(
            dialMarkingModeRaw: dialMarkingModeRaw,
            legacyShowDigits: legacyShowDigits,
            legacyShowTicks: legacyShowTicks
        )
    }

    var displayMode: ClockDisplayMode {
        ClockDisplayMode(rawValue: clockModeRaw) ?? .sixHands
    }

    var showDigits: Bool {
        dialMarkingMode == .digits
    }

    var showTicks: Bool {
        dialMarkingMode == .ticks
    }

    var lightHandCustomization: HandCustomization {
        handMetrics.customization(with: lightHandTheme)
    }

    var darkHandCustomization: HandCustomization {
        handMetrics.customization(with: darkHandTheme)
    }

    var resolvedPrimaryCityName: String {
        widgetPrimaryLocation.resolvedCityName
    }

    var resolvedSecondaryCityName: String {
        widgetSecondaryLocation.resolvedCityName
    }

    func makeClockSettings(systemColorScheme: ColorScheme) -> ClockSettings {
        let resolvedAppearanceMode = appearanceMode
        let effectiveColorScheme = resolvedAppearanceMode.resolvedColorScheme(system: systemColorScheme)

        return ClockSettings(
            appearanceMode: resolvedAppearanceMode,
            effectiveColorScheme: effectiveColorScheme,
            showDigits: showDigits,
            showTicks: showTicks,
            useGradientBackground: true,
            centerDotScale: 1.0,
            dialInset: 48.0,
            displayMode: displayMode,
            integerOnly: integerOnly,
            continuousMinuteOnesInIntegerMode: continuousMinuteOnesInIntegerMode,
            continuousSecondOnesInIntegerMode: continuousSecondOnesInIntegerMode,
            lightHandCustomization: lightHandCustomization,
            darkHandCustomization: darkHandCustomization,
            lightSurfaceCustomization: lightSurfaceCustomization,
            darkSurfaceCustomization: darkSurfaceCustomization
        )
    }
}

extension ContentView {
    var currentPreferences: ClockPreferences {
        let state = settingsStore.state

        return ClockPreferences(
            appearanceModeRaw: state.appearanceModeRaw,
            legacyShowDigits: state.legacyShowDigits,
            legacyShowTicks: state.legacyShowTicks,
            dialMarkingModeRaw: state.dialMarkingModeRaw,
            clockModeRaw: state.clockModeRaw,
            integerOnly: state.integerOnly,
            continuousMinuteOnesInIntegerMode: state.continuousMinuteOnesInIntegerMode,
            continuousSecondOnesInIntegerMode: state.continuousSecondOnesInIntegerMode,
            handMetrics: ClockHandMetricPreferences(
                hourTensWidth: state.handMetrics.hourTensWidth,
                hourOnesWidth: state.handMetrics.hourOnesWidth,
                minuteTensWidth: state.handMetrics.minuteTensWidth,
                minuteOnesWidth: state.handMetrics.minuteOnesWidth,
                secondTensWidth: state.handMetrics.secondTensWidth,
                secondOnesWidth: state.handMetrics.secondOnesWidth,
                hourTensLength: state.handMetrics.hourTensLength,
                hourOnesLength: state.handMetrics.hourOnesLength,
                minuteTensLength: state.handMetrics.minuteTensLength,
                minuteOnesLength: state.handMetrics.minuteOnesLength,
                secondTensLength: state.handMetrics.secondTensLength,
                secondOnesLength: state.handMetrics.secondOnesLength
            ),
            lightHandTheme: ClockHandColorTheme(
                hourTensColor: state.lightHandTheme.hourTensColor,
                hourOnesColor: state.lightHandTheme.hourOnesColor,
                minuteTensColor: state.lightHandTheme.minuteTensColor,
                minuteOnesColor: state.lightHandTheme.minuteOnesColor,
                secondTensColor: state.lightHandTheme.secondTensColor,
                secondOnesColor: state.lightHandTheme.secondOnesColor
            ),
            darkHandTheme: ClockHandColorTheme(
                hourTensColor: state.darkHandTheme.hourTensColor,
                hourOnesColor: state.darkHandTheme.hourOnesColor,
                minuteTensColor: state.darkHandTheme.minuteTensColor,
                minuteOnesColor: state.darkHandTheme.minuteOnesColor,
                secondTensColor: state.darkHandTheme.secondTensColor,
                secondOnesColor: state.darkHandTheme.secondOnesColor
            ),
            lightSurfaceCustomization: ClockSurfaceCustomization(
                markingColor: state.lightSurfaceTheme.markingColor,
                ringColor: state.lightSurfaceTheme.ringColor,
                dialBackgroundColor: state.lightSurfaceTheme.dialBackgroundColor,
                appBackgroundColor: state.lightSurfaceTheme.appBackgroundColor
            ),
            darkSurfaceCustomization: ClockSurfaceCustomization(
                markingColor: state.darkSurfaceTheme.markingColor,
                ringColor: state.darkSurfaceTheme.ringColor,
                dialBackgroundColor: state.darkSurfaceTheme.dialBackgroundColor,
                appBackgroundColor: state.darkSurfaceTheme.appBackgroundColor
            ),
            widgetPrimaryLocation: ClockWidgetLocationPreferences(
                cityName: state.widgetPrimaryLocation.cityName,
                timeZoneIdentifier: state.widgetPrimaryLocation.timeZoneIdentifier
            ),
            widgetSecondaryClockEnabled: state.widgetSecondaryClockEnabled,
            widgetSecondaryLocation: ClockWidgetLocationPreferences(
                cityName: state.widgetSecondaryLocation.cityName,
                timeZoneIdentifier: state.widgetSecondaryLocation.timeZoneIdentifier
            )
        )
    }
}
