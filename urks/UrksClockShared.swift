/* /Users/drebin/Documents/software/urks/urks/UrksClockShared.swift */
import SwiftUI
import Foundation

enum UrksSharedConfig {
    static let appGroupSuiteName: String? = nil
}

struct UrksSharedStoredColor: Equatable {
    let red: Double
    let green: Double
    let blue: Double

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

    private static func clamp(_ value: Double) -> Double {
        min(max(value, 0.0), 1.0)
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
        hourTensColor: UrksSharedStoredColor(red255: 0, green255: 122, blue255: 255),
        hourOnesColor: UrksSharedStoredColor(red255: 88, green255: 86, blue255: 214),
        minuteTensColor: UrksSharedStoredColor(red255: 48, green255: 176, blue255: 199),
        minuteOnesColor: UrksSharedStoredColor(red255: 52, green255: 199, blue255: 89),
        secondTensColor: UrksSharedStoredColor(red255: 255, green255: 149, blue255: 0),
        secondOnesColor: UrksSharedStoredColor(red255: 255, green255: 59, blue255: 48)
    )
}

enum UrksSharedWidgetSettings {
    static func loadHandPalette() -> UrksSharedHandPalette {
        guard
            let suiteName = UrksSharedConfig.appGroupSuiteName,
            !suiteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            let defaults = UserDefaults(suiteName: suiteName)
        else {
            return .fallback
        }

        return UrksSharedHandPalette(
            hourTensColor: readColor(
                defaults: defaults,
                redKey: "clockHourTensColorRed",
                greenKey: "clockHourTensColorGreen",
                blueKey: "clockHourTensColorBlue",
                fallback: .fallback.hourTensColor
            ),
            hourOnesColor: readColor(
                defaults: defaults,
                redKey: "clockHourOnesColorRed",
                greenKey: "clockHourOnesColorGreen",
                blueKey: "clockHourOnesColorBlue",
                fallback: .fallback.hourOnesColor
            ),
            minuteTensColor: readColor(
                defaults: defaults,
                redKey: "clockMinuteTensColorRed",
                greenKey: "clockMinuteTensColorGreen",
                blueKey: "clockMinuteTensColorBlue",
                fallback: .fallback.minuteTensColor
            ),
            minuteOnesColor: readColor(
                defaults: defaults,
                redKey: "clockMinuteOnesColorRed",
                greenKey: "clockMinuteOnesColorGreen",
                blueKey: "clockMinuteOnesColorBlue",
                fallback: .fallback.minuteOnesColor
            ),
            secondTensColor: readColor(
                defaults: defaults,
                redKey: "clockSecondTensColorRed",
                greenKey: "clockSecondTensColorGreen",
                blueKey: "clockSecondTensColorBlue",
                fallback: .fallback.secondTensColor
            ),
            secondOnesColor: readColor(
                defaults: defaults,
                redKey: "clockSecondOnesColorRed",
                greenKey: "clockSecondOnesColorGreen",
                blueKey: "clockSecondOnesColorBlue",
                fallback: .fallback.secondOnesColor
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
        String(format: "Standard %02d:%02d", hour, minute)
    }

    init(date: Date) {
        let calendar = Calendar(identifier: .gregorian)
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

        hourTensSlot = preciseHour / 10.0
        hourOnesSlot = preciseHour
        minuteTensSlot = preciseMinute / 10.0
        minuteOnesSlot = preciseMinute
        secondTensSlot = preciseSecond / 10.0
        secondOnesSlot = preciseSecond
    }
}

func urksSlotAngle(for slot: Double, rotationSlotOffset: Double = 0.0) -> Angle {
    Angle.degrees(-90.0 + (slot + rotationSlotOffset) * 36.0)
}

func urksPointOnCircle(center: CGPoint, radius: CGFloat, angle: Angle) -> CGPoint {
    let radians = CGFloat(angle.radians)
    return CGPoint(
        x: center.x + CoreGraphics.cos(radians) * radius,
        y: center.y + CoreGraphics.sin(radians) * radius
    )
}
