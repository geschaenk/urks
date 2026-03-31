/* /Users/drebin/Documents/software/urks/urks/ContentView+SettingsActions.swift */
import Foundation

extension ContentView {
    func applyDefaults() {
        let destinationSection: SettingsSection =
            (selectedHandForEditing == nil && selectedSurfaceRoleForEditing == nil) ? settingsSection : .design
        let customization = ClockPreset.standard.customization

        performBatchedWidgetSync {
            appearanceModeRaw = ClockDefaults.appearanceMode.rawValue
            setDialMarkingMode(ClockDefaults.showDigits ? .digits : .ticks)
            clockModeRaw = ClockDefaults.displayMode.rawValue
            integerOnly = ClockDefaults.integerOnly
            continuousMinuteOnesInIntegerMode = ClockDefaults.continuousMinuteOnesInIntegerMode
            continuousSecondOnesInIntegerMode = ClockDefaults.continuousSecondOnesInIntegerMode

            for kind in ClockHandKind.allCases {
                let adjustment = customization.adjustment(for: kind)
                setHandAdjustment(adjustment, for: kind, mode: .light)
                setHandAdjustment(adjustment, for: kind, mode: .dark)
            }

            setSurfaceColor(ClockDefaults.lightMarkingColor, for: .markings, mode: .light)
            setSurfaceColor(ClockDefaults.lightRingColor, for: .ring, mode: .light)
            setSurfaceColor(ClockDefaults.lightDialBackgroundColor, for: .dialBackground, mode: .light)
            setSurfaceColor(ClockDefaults.lightAppBackgroundColor, for: .appBackground, mode: .light)

            setSurfaceColor(ClockDefaults.darkMarkingColor, for: .markings, mode: .dark)
            setSurfaceColor(ClockDefaults.darkRingColor, for: .ring, mode: .dark)
            setSurfaceColor(ClockDefaults.darkDialBackgroundColor, for: .dialBackground, mode: .dark)
            setSurfaceColor(ClockDefaults.darkAppBackgroundColor, for: .appBackground, mode: .dark)

            widgetPrimaryTimeZoneIdentifier = TimeZone.current.identifier
            widgetPrimaryCityName = widgetDefaultCityName(for: widgetPrimaryTimeZoneIdentifier)
            widgetSecondaryClockEnabled = false
            widgetSecondaryTimeZoneIdentifier = "UTC"
            widgetSecondaryCityName = ""

            primaryCitySearchModel.setDisplayText(widgetPrimaryCityName)
            secondaryCitySearchModel.clear()

            selectedHandForEditing = nil
            selectedSurfaceRoleForEditing = nil
            appearanceSettingsExpanded = false
            colorSettingsExpanded = false
            handColorsExpanded = false
            dialColorsExpanded = false
            settingsSection = destinationSection
        }
    }

    var widgetSyncValues: ClockWidgetSyncValues {
        ClockWidgetSyncValues(preferences: currentPreferences)
    }

    func performBatchedWidgetSync(_ updates: () -> Void) {
        suppressWidgetSync = true
        settingsStore.performTransaction {
            updates()
        }
        suppressWidgetSync = false
        syncWidgetSharedDefaults()
    }

    func syncWidgetSharedDefaults() {
        guard !suppressWidgetSync else { return }
        ClockWidgetSync.sync(values: widgetSyncValues)
    }
}
