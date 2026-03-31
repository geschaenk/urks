/* /Users/drebin/Documents/software/urks/urks/ContentView+StyleEditing.swift */
import SwiftUI

extension ContentView {
    func handWidthBinding(for kind: ClockHandKind) -> Binding<Double> {
        switch kind {
        case .hourTens:
            return Binding(
                get: { hourTensWidth },
                set: { hourTensWidth = $0 }
            )
        case .hourOnes:
            return Binding(
                get: { hourOnesWidth },
                set: { hourOnesWidth = $0 }
            )
        case .minuteTens:
            return Binding(
                get: { minuteTensWidth },
                set: { minuteTensWidth = $0 }
            )
        case .minuteOnes:
            return Binding(
                get: { minuteOnesWidth },
                set: { minuteOnesWidth = $0 }
            )
        case .secondTens:
            return Binding(
                get: { secondTensWidth },
                set: { secondTensWidth = $0 }
            )
        case .secondOnes:
            return Binding(
                get: { secondOnesWidth },
                set: { secondOnesWidth = $0 }
            )
        }
    }

    func handLengthBinding(for kind: ClockHandKind) -> Binding<Double> {
        switch kind {
        case .hourTens:
            return Binding(
                get: { hourTensLength },
                set: { hourTensLength = $0 }
            )
        case .hourOnes:
            return Binding(
                get: { hourOnesLength },
                set: { hourOnesLength = $0 }
            )
        case .minuteTens:
            return Binding(
                get: { minuteTensLength },
                set: { minuteTensLength = $0 }
            )
        case .minuteOnes:
            return Binding(
                get: { minuteOnesLength },
                set: { minuteOnesLength = $0 }
            )
        case .secondTens:
            return Binding(
                get: { secondTensLength },
                set: { secondTensLength = $0 }
            )
        case .secondOnes:
            return Binding(
                get: { secondOnesLength },
                set: { secondOnesLength = $0 }
            )
        }
    }

    func currentHandAdjustment(for kind: ClockHandKind) -> HandAdjustment {
        HandAdjustment(
            width: handWidthBinding(for: kind).wrappedValue,
            length: handLengthBinding(for: kind).wrappedValue,
            color: handColor(for: kind, mode: activeColorEditingMode)
        )
    }

    func handColor(for kind: ClockHandKind, mode: ClockColorEditingMode? = nil) -> StoredClockColor {
        let resolvedMode = mode ?? activeColorEditingMode

        switch resolvedMode {
        case .light:
            switch kind {
            case .hourTens:
                return StoredClockColor(red: hourTensColorRed, green: hourTensColorGreen, blue: hourTensColorBlue)
            case .hourOnes:
                return StoredClockColor(red: hourOnesColorRed, green: hourOnesColorGreen, blue: hourOnesColorBlue)
            case .minuteTens:
                return StoredClockColor(red: minuteTensColorRed, green: minuteTensColorGreen, blue: minuteTensColorBlue)
            case .minuteOnes:
                return StoredClockColor(red: minuteOnesColorRed, green: minuteOnesColorGreen, blue: minuteOnesColorBlue)
            case .secondTens:
                return StoredClockColor(red: secondTensColorRed, green: secondTensColorGreen, blue: secondTensColorBlue)
            case .secondOnes:
                return StoredClockColor(red: secondOnesColorRed, green: secondOnesColorGreen, blue: secondOnesColorBlue)
            }
        case .dark:
            switch kind {
            case .hourTens:
                return StoredClockColor(red: darkHourTensColorRed, green: darkHourTensColorGreen, blue: darkHourTensColorBlue)
            case .hourOnes:
                return StoredClockColor(red: darkHourOnesColorRed, green: darkHourOnesColorGreen, blue: darkHourOnesColorBlue)
            case .minuteTens:
                return StoredClockColor(red: darkMinuteTensColorRed, green: darkMinuteTensColorGreen, blue: darkMinuteTensColorBlue)
            case .minuteOnes:
                return StoredClockColor(red: darkMinuteOnesColorRed, green: darkMinuteOnesColorGreen, blue: darkMinuteOnesColorBlue)
            case .secondTens:
                return StoredClockColor(red: darkSecondTensColorRed, green: darkSecondTensColorGreen, blue: darkSecondTensColorBlue)
            case .secondOnes:
                return StoredClockColor(red: darkSecondOnesColorRed, green: darkSecondOnesColorGreen, blue: darkSecondOnesColorBlue)
            }
        }
    }

    func handColorPickerBinding(for kind: ClockHandKind) -> Binding<Color> {
        Binding(
            get: {
                handColor(for: kind).color
            },
            set: { newColor in
                let current = handColor(for: kind)
                let storedColor = StoredClockColor(color: newColor, fallback: current)
                setHandColor(storedColor, for: kind)
            }
        )
    }

    func setHandColor(_ color: StoredClockColor, for kind: ClockHandKind, mode: ClockColorEditingMode? = nil) {
        setStoredColor(color, for: kind, mode: mode)
        syncWidgetSharedDefaults()
    }

    func setStoredColor(_ color: StoredClockColor, for kind: ClockHandKind, mode: ClockColorEditingMode? = nil) {
        let resolvedMode = mode ?? activeColorEditingMode

        switch resolvedMode {
        case .light:
            switch kind {
            case .hourTens:
                hourTensColorRed = color.red
                hourTensColorGreen = color.green
                hourTensColorBlue = color.blue
            case .hourOnes:
                hourOnesColorRed = color.red
                hourOnesColorGreen = color.green
                hourOnesColorBlue = color.blue
            case .minuteTens:
                minuteTensColorRed = color.red
                minuteTensColorGreen = color.green
                minuteTensColorBlue = color.blue
            case .minuteOnes:
                minuteOnesColorRed = color.red
                minuteOnesColorGreen = color.green
                minuteOnesColorBlue = color.blue
            case .secondTens:
                secondTensColorRed = color.red
                secondTensColorGreen = color.green
                secondTensColorBlue = color.blue
            case .secondOnes:
                secondOnesColorRed = color.red
                secondOnesColorGreen = color.green
                secondOnesColorBlue = color.blue
            }
        case .dark:
            switch kind {
            case .hourTens:
                darkHourTensColorRed = color.red
                darkHourTensColorGreen = color.green
                darkHourTensColorBlue = color.blue
            case .hourOnes:
                darkHourOnesColorRed = color.red
                darkHourOnesColorGreen = color.green
                darkHourOnesColorBlue = color.blue
            case .minuteTens:
                darkMinuteTensColorRed = color.red
                darkMinuteTensColorGreen = color.green
                darkMinuteTensColorBlue = color.blue
            case .minuteOnes:
                darkMinuteOnesColorRed = color.red
                darkMinuteOnesColorGreen = color.green
                darkMinuteOnesColorBlue = color.blue
            case .secondTens:
                darkSecondTensColorRed = color.red
                darkSecondTensColorGreen = color.green
                darkSecondTensColorBlue = color.blue
            case .secondOnes:
                darkSecondOnesColorRed = color.red
                darkSecondOnesColorGreen = color.green
                darkSecondOnesColorBlue = color.blue
            }
        }
    }

    func setHandAdjustment(_ adjustment: HandAdjustment, for kind: ClockHandKind, mode: ClockColorEditingMode? = nil) {
        switch kind {
        case .hourTens:
            hourTensWidth = adjustment.width
            hourTensLength = adjustment.length
        case .hourOnes:
            hourOnesWidth = adjustment.width
            hourOnesLength = adjustment.length
        case .minuteTens:
            minuteTensWidth = adjustment.width
            minuteTensLength = adjustment.length
        case .minuteOnes:
            minuteOnesWidth = adjustment.width
            minuteOnesLength = adjustment.length
        case .secondTens:
            secondTensWidth = adjustment.width
            secondTensLength = adjustment.length
        case .secondOnes:
            secondOnesWidth = adjustment.width
            secondOnesLength = adjustment.length
        }

        setStoredColor(adjustment.color, for: kind, mode: mode)
        syncWidgetSharedDefaults()
    }

    func resetHand(_ kind: ClockHandKind) {
        let adjustment = ClockPreset.standard.customization.adjustment(for: kind)
        setHandAdjustment(adjustment, for: kind)
    }

    func surfaceColor(for role: ClockSurfaceColorRole, mode: ClockColorEditingMode? = nil) -> StoredClockColor {
        let resolvedMode = mode ?? activeColorEditingMode

        switch (resolvedMode, role) {
        case (.light, .markings):
            return StoredClockColor(red: lightMarkingColorRed, green: lightMarkingColorGreen, blue: lightMarkingColorBlue)
        case (.light, .ring):
            return StoredClockColor(red: lightRingColorRed, green: lightRingColorGreen, blue: lightRingColorBlue)
        case (.light, .dialBackground):
            return StoredClockColor(red: lightDialBackgroundColorRed, green: lightDialBackgroundColorGreen, blue: lightDialBackgroundColorBlue)
        case (.light, .appBackground):
            return StoredClockColor(red: lightAppBackgroundColorRed, green: lightAppBackgroundColorGreen, blue: lightAppBackgroundColorBlue)
        case (.dark, .markings):
            return StoredClockColor(red: darkMarkingColorRed, green: darkMarkingColorGreen, blue: darkMarkingColorBlue)
        case (.dark, .ring):
            return StoredClockColor(red: darkRingColorRed, green: darkRingColorGreen, blue: darkRingColorBlue)
        case (.dark, .dialBackground):
            return StoredClockColor(red: darkDialBackgroundColorRed, green: darkDialBackgroundColorGreen, blue: darkDialBackgroundColorBlue)
        case (.dark, .appBackground):
            return StoredClockColor(red: darkAppBackgroundColorRed, green: darkAppBackgroundColorGreen, blue: darkAppBackgroundColorBlue)
        }
    }

    func surfaceColorPickerBinding(for role: ClockSurfaceColorRole) -> Binding<Color> {
        Binding(
            get: {
                surfaceColor(for: role).color
            },
            set: { newColor in
                let current = surfaceColor(for: role)
                let storedColor = StoredClockColor(color: newColor, fallback: current)
                setSurfaceColor(storedColor, for: role)
            }
        )
    }

    func setSurfaceColor(_ color: StoredClockColor, for role: ClockSurfaceColorRole, mode: ClockColorEditingMode? = nil) {
        let resolvedMode = mode ?? activeColorEditingMode

        switch (resolvedMode, role) {
        case (.light, .markings):
            lightMarkingColorRed = color.red
            lightMarkingColorGreen = color.green
            lightMarkingColorBlue = color.blue
        case (.light, .ring):
            lightRingColorRed = color.red
            lightRingColorGreen = color.green
            lightRingColorBlue = color.blue
        case (.light, .dialBackground):
            lightDialBackgroundColorRed = color.red
            lightDialBackgroundColorGreen = color.green
            lightDialBackgroundColorBlue = color.blue
        case (.light, .appBackground):
            lightAppBackgroundColorRed = color.red
            lightAppBackgroundColorGreen = color.green
            lightAppBackgroundColorBlue = color.blue
        case (.dark, .markings):
            darkMarkingColorRed = color.red
            darkMarkingColorGreen = color.green
            darkMarkingColorBlue = color.blue
        case (.dark, .ring):
            darkRingColorRed = color.red
            darkRingColorGreen = color.green
            darkRingColorBlue = color.blue
        case (.dark, .dialBackground):
            darkDialBackgroundColorRed = color.red
            darkDialBackgroundColorGreen = color.green
            darkDialBackgroundColorBlue = color.blue
        case (.dark, .appBackground):
            darkAppBackgroundColorRed = color.red
            darkAppBackgroundColorGreen = color.green
            darkAppBackgroundColorBlue = color.blue
        }

        syncWidgetSharedDefaults()
    }

    func defaultSurfaceColor(for role: ClockSurfaceColorRole, mode: ClockColorEditingMode) -> StoredClockColor {
        switch (mode, role) {
        case (.light, .markings):
            return ClockDefaults.lightMarkingColor
        case (.light, .ring):
            return ClockDefaults.lightRingColor
        case (.light, .dialBackground):
            return ClockDefaults.lightDialBackgroundColor
        case (.light, .appBackground):
            return ClockDefaults.lightAppBackgroundColor
        case (.dark, .markings):
            return ClockDefaults.darkMarkingColor
        case (.dark, .ring):
            return ClockDefaults.darkRingColor
        case (.dark, .dialBackground):
            return ClockDefaults.darkDialBackgroundColor
        case (.dark, .appBackground):
            return ClockDefaults.darkAppBackgroundColor
        }
    }

    func resetSurfaceRole(_ role: ClockSurfaceColorRole) {
        let mode = activeColorEditingMode
        setSurfaceColor(defaultSurfaceColor(for: role, mode: mode), for: role, mode: mode)
    }
}
