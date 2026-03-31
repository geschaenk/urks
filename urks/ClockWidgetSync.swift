/* /Users/drebin/Documents/software/urks/urks/ClockWidgetSync.swift */
import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

struct ClockWidgetSyncValues {
    let handMetrics: ClockHandMetricPreferences
    let lightHandTheme: ClockHandColorTheme
    let darkHandTheme: ClockHandColorTheme
    let lightSurfaceCustomization: ClockSurfaceCustomization
    let darkSurfaceCustomization: ClockSurfaceCustomization

    let dialMarkingModeRaw: String
    let clockModeRaw: String
    let integerOnly: Bool
    let continuousMinuteOnesInIntegerMode: Bool
    let continuousSecondOnesInIntegerMode: Bool
    let showDigits: Bool
    let showTicks: Bool
    let appearanceModeRaw: String

    let widgetPrimaryTimeZoneIdentifier: String
    let widgetPrimaryCityName: String
    let widgetSecondaryClockEnabled: Bool
    let widgetSecondaryTimeZoneIdentifier: String
    let widgetSecondaryCityName: String

    init(preferences: ClockPreferences) {
        handMetrics = preferences.handMetrics
        lightHandTheme = preferences.lightHandTheme
        darkHandTheme = preferences.darkHandTheme
        lightSurfaceCustomization = preferences.lightSurfaceCustomization
        darkSurfaceCustomization = preferences.darkSurfaceCustomization

        dialMarkingModeRaw = preferences.dialMarkingModeRaw
        clockModeRaw = preferences.clockModeRaw
        integerOnly = preferences.integerOnly
        continuousMinuteOnesInIntegerMode = preferences.continuousMinuteOnesInIntegerMode
        continuousSecondOnesInIntegerMode = preferences.continuousSecondOnesInIntegerMode
        showDigits = preferences.showDigits
        showTicks = preferences.showTicks
        appearanceModeRaw = preferences.appearanceModeRaw

        widgetPrimaryTimeZoneIdentifier = preferences.widgetPrimaryLocation.timeZoneIdentifier
        widgetPrimaryCityName = preferences.resolvedPrimaryCityName
        widgetSecondaryClockEnabled = preferences.widgetSecondaryClockEnabled
        widgetSecondaryTimeZoneIdentifier = preferences.widgetSecondaryLocation.timeZoneIdentifier
        widgetSecondaryCityName = preferences.resolvedSecondaryCityName
    }
}

enum ClockWidgetSync {
    static func sync(values: ClockWidgetSyncValues) {
        guard let defaults = sharedDefaults() else {
            return
        }

        write(values.lightHandTheme.hourTensColor, redKey: ClockStorageKeys.hourTensColorRed, greenKey: ClockStorageKeys.hourTensColorGreen, blueKey: ClockStorageKeys.hourTensColorBlue, to: defaults)
        write(values.lightHandTheme.hourOnesColor, redKey: ClockStorageKeys.hourOnesColorRed, greenKey: ClockStorageKeys.hourOnesColorGreen, blueKey: ClockStorageKeys.hourOnesColorBlue, to: defaults)
        write(values.lightHandTheme.minuteTensColor, redKey: ClockStorageKeys.minuteTensColorRed, greenKey: ClockStorageKeys.minuteTensColorGreen, blueKey: ClockStorageKeys.minuteTensColorBlue, to: defaults)
        write(values.lightHandTheme.minuteOnesColor, redKey: ClockStorageKeys.minuteOnesColorRed, greenKey: ClockStorageKeys.minuteOnesColorGreen, blueKey: ClockStorageKeys.minuteOnesColorBlue, to: defaults)
        write(values.lightHandTheme.secondTensColor, redKey: ClockStorageKeys.secondTensColorRed, greenKey: ClockStorageKeys.secondTensColorGreen, blueKey: ClockStorageKeys.secondTensColorBlue, to: defaults)
        write(values.lightHandTheme.secondOnesColor, redKey: ClockStorageKeys.secondOnesColorRed, greenKey: ClockStorageKeys.secondOnesColorGreen, blueKey: ClockStorageKeys.secondOnesColorBlue, to: defaults)

        write(values.darkHandTheme.hourTensColor, redKey: ClockStorageKeys.darkHourTensColorRed, greenKey: ClockStorageKeys.darkHourTensColorGreen, blueKey: ClockStorageKeys.darkHourTensColorBlue, to: defaults)
        write(values.darkHandTheme.hourOnesColor, redKey: ClockStorageKeys.darkHourOnesColorRed, greenKey: ClockStorageKeys.darkHourOnesColorGreen, blueKey: ClockStorageKeys.darkHourOnesColorBlue, to: defaults)
        write(values.darkHandTheme.minuteTensColor, redKey: ClockStorageKeys.darkMinuteTensColorRed, greenKey: ClockStorageKeys.darkMinuteTensColorGreen, blueKey: ClockStorageKeys.darkMinuteTensColorBlue, to: defaults)
        write(values.darkHandTheme.minuteOnesColor, redKey: ClockStorageKeys.darkMinuteOnesColorRed, greenKey: ClockStorageKeys.darkMinuteOnesColorGreen, blueKey: ClockStorageKeys.darkMinuteOnesColorBlue, to: defaults)
        write(values.darkHandTheme.secondTensColor, redKey: ClockStorageKeys.darkSecondTensColorRed, greenKey: ClockStorageKeys.darkSecondTensColorGreen, blueKey: ClockStorageKeys.darkSecondTensColorBlue, to: defaults)
        write(values.darkHandTheme.secondOnesColor, redKey: ClockStorageKeys.darkSecondOnesColorRed, greenKey: ClockStorageKeys.darkSecondOnesColorGreen, blueKey: ClockStorageKeys.darkSecondOnesColorBlue, to: defaults)

        write(values.lightSurfaceCustomization.markingColor, redKey: ClockStorageKeys.lightMarkingColorRed, greenKey: ClockStorageKeys.lightMarkingColorGreen, blueKey: ClockStorageKeys.lightMarkingColorBlue, to: defaults)
        write(values.lightSurfaceCustomization.ringColor, redKey: ClockStorageKeys.lightRingColorRed, greenKey: ClockStorageKeys.lightRingColorGreen, blueKey: ClockStorageKeys.lightRingColorBlue, to: defaults)
        write(values.lightSurfaceCustomization.dialBackgroundColor, redKey: ClockStorageKeys.lightDialBackgroundColorRed, greenKey: ClockStorageKeys.lightDialBackgroundColorGreen, blueKey: ClockStorageKeys.lightDialBackgroundColorBlue, to: defaults)
        write(values.lightSurfaceCustomization.appBackgroundColor, redKey: ClockStorageKeys.lightAppBackgroundColorRed, greenKey: ClockStorageKeys.lightAppBackgroundColorGreen, blueKey: ClockStorageKeys.lightAppBackgroundColorBlue, to: defaults)

        write(values.darkSurfaceCustomization.markingColor, redKey: ClockStorageKeys.darkMarkingColorRed, greenKey: ClockStorageKeys.darkMarkingColorGreen, blueKey: ClockStorageKeys.darkMarkingColorBlue, to: defaults)
        write(values.darkSurfaceCustomization.ringColor, redKey: ClockStorageKeys.darkRingColorRed, greenKey: ClockStorageKeys.darkRingColorGreen, blueKey: ClockStorageKeys.darkRingColorBlue, to: defaults)
        write(values.darkSurfaceCustomization.dialBackgroundColor, redKey: ClockStorageKeys.darkDialBackgroundColorRed, greenKey: ClockStorageKeys.darkDialBackgroundColorGreen, blueKey: ClockStorageKeys.darkDialBackgroundColorBlue, to: defaults)
        write(values.darkSurfaceCustomization.appBackgroundColor, redKey: ClockStorageKeys.darkAppBackgroundColorRed, greenKey: ClockStorageKeys.darkAppBackgroundColorGreen, blueKey: ClockStorageKeys.darkAppBackgroundColorBlue, to: defaults)

        defaults.set(values.handMetrics.hourTensWidth, forKey: ClockStorageKeys.hourTensWidthRatio)
        defaults.set(values.handMetrics.hourOnesWidth, forKey: ClockStorageKeys.hourOnesWidthRatio)
        defaults.set(values.handMetrics.minuteTensWidth, forKey: ClockStorageKeys.minuteTensWidthRatio)
        defaults.set(values.handMetrics.minuteOnesWidth, forKey: ClockStorageKeys.minuteOnesWidthRatio)
        defaults.set(values.handMetrics.secondTensWidth, forKey: ClockStorageKeys.secondTensWidthRatio)
        defaults.set(values.handMetrics.secondOnesWidth, forKey: ClockStorageKeys.secondOnesWidthRatio)

        defaults.set(values.handMetrics.hourTensLength, forKey: ClockStorageKeys.hourTensLengthRatio)
        defaults.set(values.handMetrics.hourOnesLength, forKey: ClockStorageKeys.hourOnesLengthRatio)
        defaults.set(values.handMetrics.minuteTensLength, forKey: ClockStorageKeys.minuteTensLengthRatio)
        defaults.set(values.handMetrics.minuteOnesLength, forKey: ClockStorageKeys.minuteOnesLengthRatio)
        defaults.set(values.handMetrics.secondTensLength, forKey: ClockStorageKeys.secondTensLengthRatio)
        defaults.set(values.handMetrics.secondOnesLength, forKey: ClockStorageKeys.secondOnesLengthRatio)

        defaults.set(values.dialMarkingModeRaw, forKey: ClockStorageKeys.dialMarkingModeRaw)
        defaults.set(values.clockModeRaw, forKey: ClockStorageKeys.clockModeRaw)
        defaults.set(values.integerOnly, forKey: ClockStorageKeys.integerOnly)
        defaults.set(values.continuousMinuteOnesInIntegerMode, forKey: ClockStorageKeys.continuousMinuteOnesInIntegerMode)
        defaults.set(values.continuousSecondOnesInIntegerMode, forKey: ClockStorageKeys.continuousSecondOnesInIntegerMode)
        defaults.set(values.showDigits, forKey: ClockStorageKeys.legacyShowDigits)
        defaults.set(values.showTicks, forKey: ClockStorageKeys.legacyShowTicks)
        defaults.set(values.appearanceModeRaw, forKey: ClockStorageKeys.appearanceModeRaw)

        defaults.set(values.widgetPrimaryTimeZoneIdentifier, forKey: ClockStorageKeys.widgetPrimaryTimeZoneIdentifier)
        defaults.set(values.widgetPrimaryCityName, forKey: ClockStorageKeys.widgetPrimaryCityName)
        defaults.set(values.widgetSecondaryClockEnabled, forKey: ClockStorageKeys.widgetSecondaryClockEnabled)

        if values.widgetSecondaryClockEnabled {
            defaults.set(values.widgetSecondaryTimeZoneIdentifier, forKey: ClockStorageKeys.widgetSecondaryTimeZoneIdentifier)
            defaults.set(values.widgetSecondaryCityName, forKey: ClockStorageKeys.widgetSecondaryCityName)
        } else {
            defaults.removeObject(forKey: ClockStorageKeys.widgetSecondaryTimeZoneIdentifier)
            defaults.removeObject(forKey: ClockStorageKeys.widgetSecondaryCityName)
        }

        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadTimelines(ofKind: ClockWidgetConstants.kind)
        #endif
    }

    private static func sharedDefaults() -> UserDefaults? {
        guard
            let suiteName = UrksSharedConfig.appGroupSuiteName,
            !suiteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return nil
        }

        return UserDefaults(suiteName: suiteName)
    }

    private static func write(
        _ color: StoredClockColor,
        redKey: String,
        greenKey: String,
        blueKey: String,
        to defaults: UserDefaults
    ) {
        defaults.set(color.red, forKey: redKey)
        defaults.set(color.green, forKey: greenKey)
        defaults.set(color.blue, forKey: blueKey)
    }
}
