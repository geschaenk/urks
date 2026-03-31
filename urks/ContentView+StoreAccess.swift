/* /Users/drebin/Documents/software/urks/urks/ContentView+StoreAccess.swift */
import SwiftUI

extension ContentView {
    private func readRoot<Value>(_ keyPath: KeyPath<ClockSettingsState, Value>) -> Value {
        settingsStore.state[keyPath: keyPath]
    }

    private func writeRoot<Value>(_ keyPath: WritableKeyPath<ClockSettingsState, Value>, _ newValue: Value) {
        var state = settingsStore.state
        state[keyPath: keyPath] = newValue
        settingsStore.state = state
    }

    private func readGroup<Group, Value>(
        _ groupKeyPath: KeyPath<ClockSettingsState, Group>,
        _ valueKeyPath: KeyPath<Group, Value>
    ) -> Value {
        settingsStore.state[keyPath: groupKeyPath][keyPath: valueKeyPath]
    }

    private func writeGroup<Group, Value>(
        _ groupKeyPath: WritableKeyPath<ClockSettingsState, Group>,
        _ valueKeyPath: WritableKeyPath<Group, Value>,
        _ newValue: Value
    ) {
        var state = settingsStore.state
        var group = state[keyPath: groupKeyPath]
        group[keyPath: valueKeyPath] = newValue
        state[keyPath: groupKeyPath] = group
        settingsStore.state = state
    }

    var appearanceModeRaw: String {
        get { readRoot(\.appearanceModeRaw) }
        nonmutating set { writeRoot(\.appearanceModeRaw, newValue) }
    }

    var legacyShowDigits: Bool {
        get { readRoot(\.legacyShowDigits) }
        nonmutating set { writeRoot(\.legacyShowDigits, newValue) }
    }

    var legacyShowTicks: Bool {
        get { readRoot(\.legacyShowTicks) }
        nonmutating set { writeRoot(\.legacyShowTicks, newValue) }
    }

    var dialMarkingModeRaw: String {
        get { readRoot(\.dialMarkingModeRaw) }
        nonmutating set { writeRoot(\.dialMarkingModeRaw, newValue) }
    }

    var clockModeRaw: String {
        get { readRoot(\.clockModeRaw) }
        nonmutating set { writeRoot(\.clockModeRaw, newValue) }
    }

    var integerOnly: Bool {
        get { readRoot(\.integerOnly) }
        nonmutating set { writeRoot(\.integerOnly, newValue) }
    }

    var continuousMinuteOnesInIntegerMode: Bool {
        get { readRoot(\.continuousMinuteOnesInIntegerMode) }
        nonmutating set { writeRoot(\.continuousMinuteOnesInIntegerMode, newValue) }
    }

    var continuousSecondOnesInIntegerMode: Bool {
        get { readRoot(\.continuousSecondOnesInIntegerMode) }
        nonmutating set { writeRoot(\.continuousSecondOnesInIntegerMode, newValue) }
    }

    var clockColorCustomizationMigrationVersion: Int {
        get { readRoot(\.clockColorCustomizationMigrationVersion) }
        nonmutating set { writeRoot(\.clockColorCustomizationMigrationVersion, newValue) }
    }

    var hourTensWidth: Double {
        get { readGroup(\.handMetrics, \.hourTensWidth) }
        nonmutating set { writeGroup(\.handMetrics, \.hourTensWidth, newValue) }
    }

    var hourOnesWidth: Double {
        get { readGroup(\.handMetrics, \.hourOnesWidth) }
        nonmutating set { writeGroup(\.handMetrics, \.hourOnesWidth, newValue) }
    }

    var minuteTensWidth: Double {
        get { readGroup(\.handMetrics, \.minuteTensWidth) }
        nonmutating set { writeGroup(\.handMetrics, \.minuteTensWidth, newValue) }
    }

    var minuteOnesWidth: Double {
        get { readGroup(\.handMetrics, \.minuteOnesWidth) }
        nonmutating set { writeGroup(\.handMetrics, \.minuteOnesWidth, newValue) }
    }

    var secondTensWidth: Double {
        get { readGroup(\.handMetrics, \.secondTensWidth) }
        nonmutating set { writeGroup(\.handMetrics, \.secondTensWidth, newValue) }
    }

    var secondOnesWidth: Double {
        get { readGroup(\.handMetrics, \.secondOnesWidth) }
        nonmutating set { writeGroup(\.handMetrics, \.secondOnesWidth, newValue) }
    }

    var hourTensLength: Double {
        get { readGroup(\.handMetrics, \.hourTensLength) }
        nonmutating set { writeGroup(\.handMetrics, \.hourTensLength, newValue) }
    }

    var hourOnesLength: Double {
        get { readGroup(\.handMetrics, \.hourOnesLength) }
        nonmutating set { writeGroup(\.handMetrics, \.hourOnesLength, newValue) }
    }

    var minuteTensLength: Double {
        get { readGroup(\.handMetrics, \.minuteTensLength) }
        nonmutating set { writeGroup(\.handMetrics, \.minuteTensLength, newValue) }
    }

    var minuteOnesLength: Double {
        get { readGroup(\.handMetrics, \.minuteOnesLength) }
        nonmutating set { writeGroup(\.handMetrics, \.minuteOnesLength, newValue) }
    }

    var secondTensLength: Double {
        get { readGroup(\.handMetrics, \.secondTensLength) }
        nonmutating set { writeGroup(\.handMetrics, \.secondTensLength, newValue) }
    }

    var secondOnesLength: Double {
        get { readGroup(\.handMetrics, \.secondOnesLength) }
        nonmutating set { writeGroup(\.handMetrics, \.secondOnesLength, newValue) }
    }

    var hourTensColorRed: Double {
        get { readGroup(\.lightHandTheme, \.hourTensColor).red }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.hourTensColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.lightHandTheme, \.hourTensColor, color)
        }
    }

    var hourTensColorGreen: Double {
        get { readGroup(\.lightHandTheme, \.hourTensColor).green }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.hourTensColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.lightHandTheme, \.hourTensColor, color)
        }
    }

    var hourTensColorBlue: Double {
        get { readGroup(\.lightHandTheme, \.hourTensColor).blue }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.hourTensColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.lightHandTheme, \.hourTensColor, color)
        }
    }

    var hourOnesColorRed: Double {
        get { readGroup(\.lightHandTheme, \.hourOnesColor).red }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.hourOnesColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.lightHandTheme, \.hourOnesColor, color)
        }
    }

    var hourOnesColorGreen: Double {
        get { readGroup(\.lightHandTheme, \.hourOnesColor).green }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.hourOnesColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.lightHandTheme, \.hourOnesColor, color)
        }
    }

    var hourOnesColorBlue: Double {
        get { readGroup(\.lightHandTheme, \.hourOnesColor).blue }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.hourOnesColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.lightHandTheme, \.hourOnesColor, color)
        }
    }

    var minuteTensColorRed: Double {
        get { readGroup(\.lightHandTheme, \.minuteTensColor).red }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.minuteTensColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.lightHandTheme, \.minuteTensColor, color)
        }
    }

    var minuteTensColorGreen: Double {
        get { readGroup(\.lightHandTheme, \.minuteTensColor).green }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.minuteTensColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.lightHandTheme, \.minuteTensColor, color)
        }
    }

    var minuteTensColorBlue: Double {
        get { readGroup(\.lightHandTheme, \.minuteTensColor).blue }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.minuteTensColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.lightHandTheme, \.minuteTensColor, color)
        }
    }

    var minuteOnesColorRed: Double {
        get { readGroup(\.lightHandTheme, \.minuteOnesColor).red }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.minuteOnesColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.lightHandTheme, \.minuteOnesColor, color)
        }
    }

    var minuteOnesColorGreen: Double {
        get { readGroup(\.lightHandTheme, \.minuteOnesColor).green }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.minuteOnesColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.lightHandTheme, \.minuteOnesColor, color)
        }
    }

    var minuteOnesColorBlue: Double {
        get { readGroup(\.lightHandTheme, \.minuteOnesColor).blue }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.minuteOnesColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.lightHandTheme, \.minuteOnesColor, color)
        }
    }

    var secondTensColorRed: Double {
        get { readGroup(\.lightHandTheme, \.secondTensColor).red }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.secondTensColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.lightHandTheme, \.secondTensColor, color)
        }
    }

    var secondTensColorGreen: Double {
        get { readGroup(\.lightHandTheme, \.secondTensColor).green }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.secondTensColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.lightHandTheme, \.secondTensColor, color)
        }
    }

    var secondTensColorBlue: Double {
        get { readGroup(\.lightHandTheme, \.secondTensColor).blue }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.secondTensColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.lightHandTheme, \.secondTensColor, color)
        }
    }

    var secondOnesColorRed: Double {
        get { readGroup(\.lightHandTheme, \.secondOnesColor).red }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.secondOnesColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.lightHandTheme, \.secondOnesColor, color)
        }
    }

    var secondOnesColorGreen: Double {
        get { readGroup(\.lightHandTheme, \.secondOnesColor).green }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.secondOnesColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.lightHandTheme, \.secondOnesColor, color)
        }
    }

    var secondOnesColorBlue: Double {
        get { readGroup(\.lightHandTheme, \.secondOnesColor).blue }
        nonmutating set {
            var color = readGroup(\.lightHandTheme, \.secondOnesColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.lightHandTheme, \.secondOnesColor, color)
        }
    }

    var darkHourTensColorRed: Double {
        get { readGroup(\.darkHandTheme, \.hourTensColor).red }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.hourTensColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.darkHandTheme, \.hourTensColor, color)
        }
    }

    var darkHourTensColorGreen: Double {
        get { readGroup(\.darkHandTheme, \.hourTensColor).green }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.hourTensColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.darkHandTheme, \.hourTensColor, color)
        }
    }

    var darkHourTensColorBlue: Double {
        get { readGroup(\.darkHandTheme, \.hourTensColor).blue }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.hourTensColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.darkHandTheme, \.hourTensColor, color)
        }
    }

    var darkHourOnesColorRed: Double {
        get { readGroup(\.darkHandTheme, \.hourOnesColor).red }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.hourOnesColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.darkHandTheme, \.hourOnesColor, color)
        }
    }

    var darkHourOnesColorGreen: Double {
        get { readGroup(\.darkHandTheme, \.hourOnesColor).green }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.hourOnesColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.darkHandTheme, \.hourOnesColor, color)
        }
    }

    var darkHourOnesColorBlue: Double {
        get { readGroup(\.darkHandTheme, \.hourOnesColor).blue }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.hourOnesColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.darkHandTheme, \.hourOnesColor, color)
        }
    }

    var darkMinuteTensColorRed: Double {
        get { readGroup(\.darkHandTheme, \.minuteTensColor).red }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.minuteTensColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.darkHandTheme, \.minuteTensColor, color)
        }
    }

    var darkMinuteTensColorGreen: Double {
        get { readGroup(\.darkHandTheme, \.minuteTensColor).green }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.minuteTensColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.darkHandTheme, \.minuteTensColor, color)
        }
    }

    var darkMinuteTensColorBlue: Double {
        get { readGroup(\.darkHandTheme, \.minuteTensColor).blue }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.minuteTensColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.darkHandTheme, \.minuteTensColor, color)
        }
    }

    var darkMinuteOnesColorRed: Double {
        get { readGroup(\.darkHandTheme, \.minuteOnesColor).red }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.minuteOnesColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.darkHandTheme, \.minuteOnesColor, color)
        }
    }

    var darkMinuteOnesColorGreen: Double {
        get { readGroup(\.darkHandTheme, \.minuteOnesColor).green }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.minuteOnesColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.darkHandTheme, \.minuteOnesColor, color)
        }
    }

    var darkMinuteOnesColorBlue: Double {
        get { readGroup(\.darkHandTheme, \.minuteOnesColor).blue }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.minuteOnesColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.darkHandTheme, \.minuteOnesColor, color)
        }
    }

    var darkSecondTensColorRed: Double {
        get { readGroup(\.darkHandTheme, \.secondTensColor).red }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.secondTensColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.darkHandTheme, \.secondTensColor, color)
        }
    }

    var darkSecondTensColorGreen: Double {
        get { readGroup(\.darkHandTheme, \.secondTensColor).green }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.secondTensColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.darkHandTheme, \.secondTensColor, color)
        }
    }

    var darkSecondTensColorBlue: Double {
        get { readGroup(\.darkHandTheme, \.secondTensColor).blue }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.secondTensColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.darkHandTheme, \.secondTensColor, color)
        }
    }

    var darkSecondOnesColorRed: Double {
        get { readGroup(\.darkHandTheme, \.secondOnesColor).red }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.secondOnesColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.darkHandTheme, \.secondOnesColor, color)
        }
    }

    var darkSecondOnesColorGreen: Double {
        get { readGroup(\.darkHandTheme, \.secondOnesColor).green }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.secondOnesColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.darkHandTheme, \.secondOnesColor, color)
        }
    }

    var darkSecondOnesColorBlue: Double {
        get { readGroup(\.darkHandTheme, \.secondOnesColor).blue }
        nonmutating set {
            var color = readGroup(\.darkHandTheme, \.secondOnesColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.darkHandTheme, \.secondOnesColor, color)
        }
    }

    var lightMarkingColorRed: Double {
        get { readGroup(\.lightSurfaceTheme, \.markingColor).red }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.markingColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.lightSurfaceTheme, \.markingColor, color)
        }
    }

    var lightMarkingColorGreen: Double {
        get { readGroup(\.lightSurfaceTheme, \.markingColor).green }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.markingColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.lightSurfaceTheme, \.markingColor, color)
        }
    }

    var lightMarkingColorBlue: Double {
        get { readGroup(\.lightSurfaceTheme, \.markingColor).blue }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.markingColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.lightSurfaceTheme, \.markingColor, color)
        }
    }

    var lightRingColorRed: Double {
        get { readGroup(\.lightSurfaceTheme, \.ringColor).red }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.ringColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.lightSurfaceTheme, \.ringColor, color)
        }
    }

    var lightRingColorGreen: Double {
        get { readGroup(\.lightSurfaceTheme, \.ringColor).green }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.ringColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.lightSurfaceTheme, \.ringColor, color)
        }
    }

    var lightRingColorBlue: Double {
        get { readGroup(\.lightSurfaceTheme, \.ringColor).blue }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.ringColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.lightSurfaceTheme, \.ringColor, color)
        }
    }

    var lightDialBackgroundColorRed: Double {
        get { readGroup(\.lightSurfaceTheme, \.dialBackgroundColor).red }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.dialBackgroundColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.lightSurfaceTheme, \.dialBackgroundColor, color)
        }
    }

    var lightDialBackgroundColorGreen: Double {
        get { readGroup(\.lightSurfaceTheme, \.dialBackgroundColor).green }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.dialBackgroundColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.lightSurfaceTheme, \.dialBackgroundColor, color)
        }
    }

    var lightDialBackgroundColorBlue: Double {
        get { readGroup(\.lightSurfaceTheme, \.dialBackgroundColor).blue }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.dialBackgroundColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.lightSurfaceTheme, \.dialBackgroundColor, color)
        }
    }

    var lightAppBackgroundColorRed: Double {
        get { readGroup(\.lightSurfaceTheme, \.appBackgroundColor).red }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.appBackgroundColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.lightSurfaceTheme, \.appBackgroundColor, color)
        }
    }

    var lightAppBackgroundColorGreen: Double {
        get { readGroup(\.lightSurfaceTheme, \.appBackgroundColor).green }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.appBackgroundColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.lightSurfaceTheme, \.appBackgroundColor, color)
        }
    }

    var lightAppBackgroundColorBlue: Double {
        get { readGroup(\.lightSurfaceTheme, \.appBackgroundColor).blue }
        nonmutating set {
            var color = readGroup(\.lightSurfaceTheme, \.appBackgroundColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.lightSurfaceTheme, \.appBackgroundColor, color)
        }
    }

    var darkMarkingColorRed: Double {
        get { readGroup(\.darkSurfaceTheme, \.markingColor).red }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.markingColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.darkSurfaceTheme, \.markingColor, color)
        }
    }

    var darkMarkingColorGreen: Double {
        get { readGroup(\.darkSurfaceTheme, \.markingColor).green }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.markingColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.darkSurfaceTheme, \.markingColor, color)
        }
    }

    var darkMarkingColorBlue: Double {
        get { readGroup(\.darkSurfaceTheme, \.markingColor).blue }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.markingColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.darkSurfaceTheme, \.markingColor, color)
        }
    }

    var darkRingColorRed: Double {
        get { readGroup(\.darkSurfaceTheme, \.ringColor).red }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.ringColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.darkSurfaceTheme, \.ringColor, color)
        }
    }

    var darkRingColorGreen: Double {
        get { readGroup(\.darkSurfaceTheme, \.ringColor).green }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.ringColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.darkSurfaceTheme, \.ringColor, color)
        }
    }

    var darkRingColorBlue: Double {
        get { readGroup(\.darkSurfaceTheme, \.ringColor).blue }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.ringColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.darkSurfaceTheme, \.ringColor, color)
        }
    }

    var darkDialBackgroundColorRed: Double {
        get { readGroup(\.darkSurfaceTheme, \.dialBackgroundColor).red }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.dialBackgroundColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.darkSurfaceTheme, \.dialBackgroundColor, color)
        }
    }

    var darkDialBackgroundColorGreen: Double {
        get { readGroup(\.darkSurfaceTheme, \.dialBackgroundColor).green }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.dialBackgroundColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.darkSurfaceTheme, \.dialBackgroundColor, color)
        }
    }

    var darkDialBackgroundColorBlue: Double {
        get { readGroup(\.darkSurfaceTheme, \.dialBackgroundColor).blue }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.dialBackgroundColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.darkSurfaceTheme, \.dialBackgroundColor, color)
        }
    }

    var darkAppBackgroundColorRed: Double {
        get { readGroup(\.darkSurfaceTheme, \.appBackgroundColor).red }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.appBackgroundColor)
            color = StoredClockColor(red: newValue, green: color.green, blue: color.blue)
            writeGroup(\.darkSurfaceTheme, \.appBackgroundColor, color)
        }
    }

    var darkAppBackgroundColorGreen: Double {
        get { readGroup(\.darkSurfaceTheme, \.appBackgroundColor).green }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.appBackgroundColor)
            color = StoredClockColor(red: color.red, green: newValue, blue: color.blue)
            writeGroup(\.darkSurfaceTheme, \.appBackgroundColor, color)
        }
    }

    var darkAppBackgroundColorBlue: Double {
        get { readGroup(\.darkSurfaceTheme, \.appBackgroundColor).blue }
        nonmutating set {
            var color = readGroup(\.darkSurfaceTheme, \.appBackgroundColor)
            color = StoredClockColor(red: color.red, green: color.green, blue: newValue)
            writeGroup(\.darkSurfaceTheme, \.appBackgroundColor, color)
        }
    }

    var widgetPrimaryTimeZoneIdentifier: String {
        get { readGroup(\.widgetPrimaryLocation, \.timeZoneIdentifier) }
        nonmutating set { writeGroup(\.widgetPrimaryLocation, \.timeZoneIdentifier, newValue) }
    }

    var widgetPrimaryCityName: String {
        get { readGroup(\.widgetPrimaryLocation, \.cityName) }
        nonmutating set { writeGroup(\.widgetPrimaryLocation, \.cityName, newValue) }
    }

    var widgetSecondaryClockEnabled: Bool {
        get { readRoot(\.widgetSecondaryClockEnabled) }
        nonmutating set { writeRoot(\.widgetSecondaryClockEnabled, newValue) }
    }

    var widgetSecondaryTimeZoneIdentifier: String {
        get { readGroup(\.widgetSecondaryLocation, \.timeZoneIdentifier) }
        nonmutating set { writeGroup(\.widgetSecondaryLocation, \.timeZoneIdentifier, newValue) }
    }

    var widgetSecondaryCityName: String {
        get { readGroup(\.widgetSecondaryLocation, \.cityName) }
        nonmutating set { writeGroup(\.widgetSecondaryLocation, \.cityName, newValue) }
    }

    var appearanceModeRawBinding: Binding<String> {
        Binding(
            get: { appearanceModeRaw },
            set: { appearanceModeRaw = $0 }
        )
    }

    var clockModeRawBinding: Binding<String> {
        Binding(
            get: { clockModeRaw },
            set: { clockModeRaw = $0 }
        )
    }

    var integerOnlyBinding: Binding<Bool> {
        Binding(
            get: { integerOnly },
            set: { integerOnly = $0 }
        )
    }

    var continuousMinuteOnesInIntegerModeBinding: Binding<Bool> {
        Binding(
            get: { continuousMinuteOnesInIntegerMode },
            set: { continuousMinuteOnesInIntegerMode = $0 }
        )
    }

    var continuousSecondOnesInIntegerModeBinding: Binding<Bool> {
        Binding(
            get: { continuousSecondOnesInIntegerMode },
            set: { continuousSecondOnesInIntegerMode = $0 }
        )
    }

    var widgetSecondaryClockEnabledBinding: Binding<Bool> {
        Binding(
            get: { widgetSecondaryClockEnabled },
            set: { widgetSecondaryClockEnabled = $0 }
        )
    }
}
