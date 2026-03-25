/* /Users/drebin/Documents/software/urks/urks/ContentView.swift */
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct StoredClockColor: Equatable {
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

    var color: Color {
        Color(red: red, green: green, blue: blue)
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

    private static func clamp(_ value: Double) -> Double {
        min(max(value, 0.0), 1.0)
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

private enum ClockDefaults {
    static let showSettings = false
    static let preset = ClockPreset.standard
    static let appearanceMode = ClockAppearanceMode.system
    static let showDigits = true
    static let showTicks = true
    static let useGradientBackground = true
    static let centerDotScale = 1.0
    static let dialInset = 24.0
    static let displayMode = ClockDisplayMode.sixHands
    static let integerOnly = false
    static let continuousMinuteOnesInIntegerMode = false
    static let continuousSecondOnesInIntegerMode = false
    static let elenaEnabled = false

    static let hourTensWidth = 1.0
    static let hourOnesWidth = 1.0
    static let minuteTensWidth = 1.0
    static let minuteOnesWidth = 1.0
    static let secondTensWidth = 1.0
    static let secondOnesWidth = 1.0

    static let hourTensLength = 1.0
    static let hourOnesLength = 1.0
    static let minuteTensLength = 1.0
    static let minuteOnesLength = 1.0
    static let secondTensLength = 1.0
    static let secondOnesLength = 1.0

    static let hourTensColor = ClockHandColor.blue.storedColor
    static let hourOnesColor = ClockHandColor.indigo.storedColor
    static let minuteTensColor = ClockHandColor.teal.storedColor
    static let minuteOnesColor = ClockHandColor.green.storedColor
    static let secondTensColor = ClockHandColor.orange.storedColor
    static let secondOnesColor = ClockHandColor.red.storedColor
}

private enum ClockHandKind: String, Identifiable {
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
}

private struct HandAdjustment {
    let width: Double
    let length: Double
    let color: StoredClockColor
}

private enum ClockPreset: String, CaseIterable, Identifiable {
    case standard
    case compact
    case contrast
    case fine
    case technical
    case custom

    var id: String { rawValue }

    var displayName: LocalizedStringResource {
        switch self {
        case .standard:
            return "preset.standard"
        case .compact:
            return "preset.compact"
        case .contrast:
            return "preset.contrast"
        case .fine:
            return "preset.fine"
        case .technical:
            return "preset.technical"
        case .custom:
            return "preset.custom"
        }
    }

    var customization: HandCustomization {
        switch self {
        case .standard:
            return HandCustomization(
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

        case .compact:
            return HandCustomization(
                hourTensWidth: 0.90,
                hourOnesWidth: 0.90,
                minuteTensWidth: 0.88,
                minuteOnesWidth: 0.86,
                secondTensWidth: 0.84,
                secondOnesWidth: 0.82,
                hourTensLength: 0.92,
                hourOnesLength: 0.92,
                minuteTensLength: 0.90,
                minuteOnesLength: 0.90,
                secondTensLength: 0.88,
                secondOnesLength: 0.88,
                hourTensColor: ClockHandColor.blue.storedColor,
                hourOnesColor: ClockHandColor.indigo.storedColor,
                minuteTensColor: ClockHandColor.teal.storedColor,
                minuteOnesColor: ClockHandColor.green.storedColor,
                secondTensColor: ClockHandColor.orange.storedColor,
                secondOnesColor: ClockHandColor.red.storedColor
            )

        case .contrast:
            return HandCustomization(
                hourTensWidth: 1.24,
                hourOnesWidth: 1.20,
                minuteTensWidth: 1.14,
                minuteOnesWidth: 1.10,
                secondTensWidth: 1.04,
                secondOnesWidth: 1.00,
                hourTensLength: 1.00,
                hourOnesLength: 1.04,
                minuteTensLength: 1.08,
                minuteOnesLength: 1.12,
                secondTensLength: 1.16,
                secondOnesLength: 1.20,
                hourTensColor: ClockHandColor.blue.storedColor,
                hourOnesColor: ClockHandColor.purple.storedColor,
                minuteTensColor: ClockHandColor.green.storedColor,
                minuteOnesColor: ClockHandColor.orange.storedColor,
                secondTensColor: ClockHandColor.pink.storedColor,
                secondOnesColor: ClockHandColor.red.storedColor
            )

        case .fine:
            return HandCustomization(
                hourTensWidth: 0.76,
                hourOnesWidth: 0.72,
                minuteTensWidth: 0.66,
                minuteOnesWidth: 0.62,
                secondTensWidth: 0.56,
                secondOnesWidth: 0.52,
                hourTensLength: 1.00,
                hourOnesLength: 1.05,
                minuteTensLength: 1.10,
                minuteOnesLength: 1.15,
                secondTensLength: 1.20,
                secondOnesLength: 1.25,
                hourTensColor: ClockHandColor.indigo.storedColor,
                hourOnesColor: ClockHandColor.blue.storedColor,
                minuteTensColor: ClockHandColor.teal.storedColor,
                minuteOnesColor: ClockHandColor.mint.storedColor,
                secondTensColor: ClockHandColor.orange.storedColor,
                secondOnesColor: ClockHandColor.red.storedColor
            )

        case .technical:
            return HandCustomization(
                hourTensWidth: 0.96,
                hourOnesWidth: 0.92,
                minuteTensWidth: 0.86,
                minuteOnesWidth: 0.82,
                secondTensWidth: 0.76,
                secondOnesWidth: 0.72,
                hourTensLength: 0.96,
                hourOnesLength: 1.00,
                minuteTensLength: 1.06,
                minuteOnesLength: 1.12,
                secondTensLength: 1.18,
                secondOnesLength: 1.24,
                hourTensColor: ClockHandColor.gray.storedColor,
                hourOnesColor: ClockHandColor.blue.storedColor,
                minuteTensColor: ClockHandColor.cyan.storedColor,
                minuteOnesColor: ClockHandColor.teal.storedColor,
                secondTensColor: ClockHandColor.orange.storedColor,
                secondOnesColor: ClockHandColor.red.storedColor
            )

        case .custom:
            return ClockDefaults.preset.customization
        }
    }

    static var selectableCases: [ClockPreset] {
        allCases.filter { $0 != .custom }
    }
}

private func localizedNumber(_ value: Double, fractionDigits: Int) -> String {
    value.formatted(.number.precision(.fractionLength(fractionDigits)))
}

private extension HandCustomization {
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

    func approximatelyMatches(
        _ other: HandCustomization,
        valueTolerance: Double = 0.0001,
        colorTolerance: Double = 0.01
    ) -> Bool {
        abs(hourTensWidth - other.hourTensWidth) <= valueTolerance &&
        abs(hourOnesWidth - other.hourOnesWidth) <= valueTolerance &&
        abs(minuteTensWidth - other.minuteTensWidth) <= valueTolerance &&
        abs(minuteOnesWidth - other.minuteOnesWidth) <= valueTolerance &&
        abs(secondTensWidth - other.secondTensWidth) <= valueTolerance &&
        abs(secondOnesWidth - other.secondOnesWidth) <= valueTolerance &&
        abs(hourTensLength - other.hourTensLength) <= valueTolerance &&
        abs(hourOnesLength - other.hourOnesLength) <= valueTolerance &&
        abs(minuteTensLength - other.minuteTensLength) <= valueTolerance &&
        abs(minuteOnesLength - other.minuteOnesLength) <= valueTolerance &&
        abs(secondTensLength - other.secondTensLength) <= valueTolerance &&
        abs(secondOnesLength - other.secondOnesLength) <= valueTolerance &&
        hourTensColor.isApproximatelyEqual(to: other.hourTensColor, tolerance: colorTolerance) &&
        hourOnesColor.isApproximatelyEqual(to: other.hourOnesColor, tolerance: colorTolerance) &&
        minuteTensColor.isApproximatelyEqual(to: other.minuteTensColor, tolerance: colorTolerance) &&
        minuteOnesColor.isApproximatelyEqual(to: other.minuteOnesColor, tolerance: colorTolerance) &&
        secondTensColor.isApproximatelyEqual(to: other.secondTensColor, tolerance: colorTolerance) &&
        secondOnesColor.isApproximatelyEqual(to: other.secondOnesColor, tolerance: colorTolerance)
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) private var systemColorScheme

    @State private var suppressPresetTracking = false
    @State private var presetDialogPresented = false

    @AppStorage("clockShowSettings") private var showSettings = ClockDefaults.showSettings
    @AppStorage("clockPresetRaw") private var presetRaw = ClockDefaults.preset.rawValue
    @AppStorage("clockAppearanceModeRaw") private var appearanceModeRaw = ClockDefaults.appearanceMode.rawValue
    @AppStorage("clockShowDigits") private var showDigits = ClockDefaults.showDigits
    @AppStorage("clockShowTicks") private var showTicks = ClockDefaults.showTicks
    @AppStorage("clockUseGradientBackground") private var useGradientBackground = ClockDefaults.useGradientBackground
    @AppStorage("clockCenterDotScale") private var centerDotScale = ClockDefaults.centerDotScale
    @AppStorage("clockDialInset") private var dialInset = ClockDefaults.dialInset
    @AppStorage("clockModeRaw") private var clockModeRaw = ClockDefaults.displayMode.rawValue
    @AppStorage("clockIntegerOnly") private var integerOnly = ClockDefaults.integerOnly
    @AppStorage("clockContinuousMinuteOnesInIntegerMode") private var continuousMinuteOnesInIntegerMode = ClockDefaults.continuousMinuteOnesInIntegerMode
    @AppStorage("clockContinuousSecondOnesInIntegerMode") private var continuousSecondOnesInIntegerMode = ClockDefaults.continuousSecondOnesInIntegerMode
    @AppStorage("clockElenaEnabled") private var elenaEnabled = ClockDefaults.elenaEnabled

    @AppStorage("clockHourTensWidth") private var hourTensWidth = ClockDefaults.hourTensWidth
    @AppStorage("clockHourOnesWidth") private var hourOnesWidth = ClockDefaults.hourOnesWidth
    @AppStorage("clockMinuteTensWidth") private var minuteTensWidth = ClockDefaults.minuteTensWidth
    @AppStorage("clockMinuteOnesWidth") private var minuteOnesWidth = ClockDefaults.minuteOnesWidth
    @AppStorage("clockSecondTensWidth") private var secondTensWidth = ClockDefaults.secondTensWidth
    @AppStorage("clockSecondOnesWidth") private var secondOnesWidth = ClockDefaults.secondOnesWidth

    @AppStorage("clockHourTensLength") private var hourTensLength = ClockDefaults.hourTensLength
    @AppStorage("clockHourOnesLength") private var hourOnesLength = ClockDefaults.hourOnesLength
    @AppStorage("clockMinuteTensLength") private var minuteTensLength = ClockDefaults.minuteTensLength
    @AppStorage("clockMinuteOnesLength") private var minuteOnesLength = ClockDefaults.minuteOnesLength
    @AppStorage("clockSecondTensLength") private var secondTensLength = ClockDefaults.secondTensLength
    @AppStorage("clockSecondOnesLength") private var secondOnesLength = ClockDefaults.secondOnesLength

    @AppStorage("clockHourTensColorRed") private var hourTensColorRed = ClockDefaults.hourTensColor.red
    @AppStorage("clockHourTensColorGreen") private var hourTensColorGreen = ClockDefaults.hourTensColor.green
    @AppStorage("clockHourTensColorBlue") private var hourTensColorBlue = ClockDefaults.hourTensColor.blue

    @AppStorage("clockHourOnesColorRed") private var hourOnesColorRed = ClockDefaults.hourOnesColor.red
    @AppStorage("clockHourOnesColorGreen") private var hourOnesColorGreen = ClockDefaults.hourOnesColor.green
    @AppStorage("clockHourOnesColorBlue") private var hourOnesColorBlue = ClockDefaults.hourOnesColor.blue

    @AppStorage("clockMinuteTensColorRed") private var minuteTensColorRed = ClockDefaults.minuteTensColor.red
    @AppStorage("clockMinuteTensColorGreen") private var minuteTensColorGreen = ClockDefaults.minuteTensColor.green
    @AppStorage("clockMinuteTensColorBlue") private var minuteTensColorBlue = ClockDefaults.minuteTensColor.blue

    @AppStorage("clockMinuteOnesColorRed") private var minuteOnesColorRed = ClockDefaults.minuteOnesColor.red
    @AppStorage("clockMinuteOnesColorGreen") private var minuteOnesColorGreen = ClockDefaults.minuteOnesColor.green
    @AppStorage("clockMinuteOnesColorBlue") private var minuteOnesColorBlue = ClockDefaults.minuteOnesColor.blue

    @AppStorage("clockSecondTensColorRed") private var secondTensColorRed = ClockDefaults.secondTensColor.red
    @AppStorage("clockSecondTensColorGreen") private var secondTensColorGreen = ClockDefaults.secondTensColor.green
    @AppStorage("clockSecondTensColorBlue") private var secondTensColorBlue = ClockDefaults.secondTensColor.blue

    @AppStorage("clockSecondOnesColorRed") private var secondOnesColorRed = ClockDefaults.secondOnesColor.red
    @AppStorage("clockSecondOnesColorGreen") private var secondOnesColorGreen = ClockDefaults.secondOnesColor.green
    @AppStorage("clockSecondOnesColorBlue") private var secondOnesColorBlue = ClockDefaults.secondOnesColor.blue

    private var selectedPreset: ClockPreset {
        ClockPreset(rawValue: presetRaw) ?? .standard
    }

    private var currentHandCustomization: HandCustomization {
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
            hourTensColor: StoredClockColor(
                red: hourTensColorRed,
                green: hourTensColorGreen,
                blue: hourTensColorBlue
            ),
            hourOnesColor: StoredClockColor(
                red: hourOnesColorRed,
                green: hourOnesColorGreen,
                blue: hourOnesColorBlue
            ),
            minuteTensColor: StoredClockColor(
                red: minuteTensColorRed,
                green: minuteTensColorGreen,
                blue: minuteTensColorBlue
            ),
            minuteOnesColor: StoredClockColor(
                red: minuteOnesColorRed,
                green: minuteOnesColorGreen,
                blue: minuteOnesColorBlue
            ),
            secondTensColor: StoredClockColor(
                red: secondTensColorRed,
                green: secondTensColorGreen,
                blue: secondTensColorBlue
            ),
            secondOnesColor: StoredClockColor(
                red: secondOnesColorRed,
                green: secondOnesColorGreen,
                blue: secondOnesColorBlue
            )
        )
    }

    var body: some View {
        let appearanceMode = ClockAppearanceMode(rawValue: appearanceModeRaw) ?? .system
        let effectiveColorScheme = appearanceMode.resolvedColorScheme(system: systemColorScheme)

        let settings = ClockSettings(
            appearanceMode: appearanceMode,
            effectiveColorScheme: effectiveColorScheme,
            showDigits: showDigits,
            showTicks: showTicks,
            useGradientBackground: useGradientBackground,
            centerDotScale: centerDotScale,
            dialInset: dialInset,
            displayMode: ClockDisplayMode(rawValue: clockModeRaw) ?? .sixHands,
            integerOnly: integerOnly,
            continuousMinuteOnesInIntegerMode: continuousMinuteOnesInIntegerMode,
            continuousSecondOnesInIntegerMode: continuousSecondOnesInIntegerMode,
            elenaEnabled: elenaEnabled,
            handCustomization: currentHandCustomization
        )

        TimelineView(PeriodicTimelineSchedule(from: .now, by: 1.0 / 30.0)) { context in
            let snapshot = ClockSnapshot(
                date: context.date,
                integerOnly: settings.integerOnly,
                continuousMinuteOnesInIntegerMode: settings.continuousMinuteOnesInIntegerMode,
                continuousSecondOnesInIntegerMode: settings.continuousSecondOnesInIntegerMode
            )

            ZStack {
                AppBackground(settings: settings)
                    .ignoresSafeArea()

                CombinedDialFace(snapshot: snapshot, settings: settings)
                    .padding(settings.dialInset)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showSettings.toggle()
                        }
                    }

                if showSettings {
                    settingsOverlay(settings: settings)
                        .transition(.opacity.combined(with: .scale(scale: 0.96)))
                        .zIndex(10)
                }
            }
        }
        .preferredColorScheme(settings.preferredColorSchemeOverride)
    }

    @ViewBuilder
    private func settingsOverlay(settings: ClockSettings) -> some View {
        let palette = settings.resolvedPalette

        ZStack {
            palette.overlayScrim
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showSettings = false
                    }
                }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("settings.title")
                                .font(.system(.title3, design: .rounded, weight: .bold))

                            Text(settings.appearanceDescription)
                                .font(.system(.footnote, design: .rounded))
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showSettings = false
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(Text("action.close"))
                    }

                    settingsCard(palette: palette) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("settings.section.appearance")
                                .font(.system(.headline, design: .rounded))

                            Picker("settings.appearance", selection: $appearanceModeRaw) {
                                ForEach(ClockAppearanceMode.allCases) { mode in
                                    Text(mode.displayName).tag(mode.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("settings.section.mode")
                                .font(.system(.headline, design: .rounded))

                            Picker("settings.mode", selection: $clockModeRaw) {
                                ForEach(ClockDisplayMode.allCases) { mode in
                                    Text(mode.displayName).tag(mode.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("settings.section.presets")
                                .font(.system(.headline, design: .rounded))

                            Button {
                                presetDialogPresented = true
                            } label: {
                                HStack(spacing: 12) {
                                    Text("settings.preset")
                                        .foregroundStyle(.primary)

                                    Spacer()

                                    Text(selectedPreset.displayName)
                                        .foregroundStyle(.secondary)

                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(palette.sectionBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(palette.sectionStroke, lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        Divider()

                        Toggle("settings.showDigits", isOn: $showDigits)
                        Toggle("settings.showTicks", isOn: $showTicks)
                        Toggle("settings.useGradientBackground", isOn: $useGradientBackground)
                        Toggle("settings.integerOnly", isOn: $integerOnly)

                        if integerOnly {
                            Toggle("settings.continuousMinuteOnesInIntegerMode", isOn: $continuousMinuteOnesInIntegerMode)
                            Toggle("settings.continuousSecondOnesInIntegerMode", isOn: $continuousSecondOnesInIntegerMode)
                        }

                        Toggle("settings.elena", isOn: $elenaEnabled)

                        Divider()

                        sliderRow(
                            title: "settings.centerDotScale",
                            value: $centerDotScale,
                            range: 0.6...1.8,
                            step: 0.05,
                            fractionDigits: 2
                        )

                        sliderRow(
                            title: "settings.dialInset",
                            value: $dialInset,
                            range: 8...48,
                            step: 1,
                            fractionDigits: 0
                        )
                    }

                    handSection(
                        kind: .hourTens,
                        width: $hourTensWidth,
                        length: $hourTensLength,
                        palette: palette
                    )

                    handSection(
                        kind: .hourOnes,
                        width: $hourOnesWidth,
                        length: $hourOnesLength,
                        palette: palette
                    )

                    handSection(
                        kind: .minuteTens,
                        width: $minuteTensWidth,
                        length: $minuteTensLength,
                        palette: palette
                    )

                    handSection(
                        kind: .minuteOnes,
                        width: $minuteOnesWidth,
                        length: $minuteOnesLength,
                        palette: palette
                    )

                    if settings.displayMode == .sixHands {
                        handSection(
                            kind: .secondTens,
                            width: $secondTensWidth,
                            length: $secondTensLength,
                            palette: palette
                        )

                        handSection(
                            kind: .secondOnes,
                            width: $secondOnesWidth,
                            length: $secondOnesLength,
                            palette: palette
                        )
                    }

                    settingsCard(palette: palette) {
                        HStack {
                            Button {
                                applyDefaults()
                            } label: {
                                Text("action.resetDefaults")
                            }
                            .buttonStyle(.bordered)

                            Spacer()

                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showSettings = false
                                }
                            } label: {
                                Text("action.done")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .padding(20)
                .tint(palette.controlTint)
            }
            .frame(maxWidth: 480, maxHeight: 780)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.ultraThinMaterial)

                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(palette.panelBackground)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(palette.panelStroke, lineWidth: 1)
            )
            .shadow(color: palette.panelShadow, radius: 24, x: 0, y: 14)
            .padding(20)
        }
        .confirmationDialog(
            String(localized: "settings.preset"),
            isPresented: $presetDialogPresented,
            titleVisibility: .visible
        ) {
            ForEach(ClockPreset.selectableCases) { preset in
                Button {
                    applyPreset(preset)
                } label: {
                    Text(preset.displayName)
                }
            }

            Button(role: .cancel) {
            } label: {
                Text("action.close")
            }
        }
    }

    private func settingsCard<Content: View>(
        palette: ClockPalette,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            content()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(palette.sectionBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(palette.sectionStroke, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func handSection(
        kind: ClockHandKind,
        width: Binding<Double>,
        length: Binding<Double>,
        palette: ClockPalette
    ) -> some View {
        let selectedColor = handColor(for: kind)

        settingsCard(palette: palette) {
            HStack(alignment: .center) {
                Text(kind.title)
                    .font(.system(.headline, design: .rounded))

                Spacer()

                Button {
                    resetHand(kind)
                } label: {
                    Text("action.reset")
                        .font(.system(.footnote, design: .rounded, weight: .semibold))
                }
                .buttonStyle(.bordered)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 12) {
                    Text("hand.property.color")
                        .foregroundStyle(.primary)

                    Spacer()

                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(selectedColor.color)
                        .frame(width: 28, height: 18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(Color.primary.opacity(0.14), lineWidth: 1)
                        )

                    Text(selectedColor.displayName)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()

                    ColorPicker(
                        "",
                        selection: handColorPickerBinding(for: kind),
                        supportsOpacity: false
                    )
                    .labelsHidden()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(palette.sectionBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(palette.sectionStroke, lineWidth: 1)
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(ClockHandColor.allCases) { presetColor in
                            let isSelected = selectedColor.isApproximatelyEqual(to: presetColor.storedColor)

                            Button {
                                setHandColor(presetColor.storedColor, for: kind)
                            } label: {
                                Circle()
                                    .fill(presetColor.storedColor.color)
                                    .frame(width: 26, height: 26)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                isSelected ? palette.controlTint : Color.primary.opacity(0.16),
                                                lineWidth: isSelected ? 3 : 1
                                            )
                                    )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(Text(presetColor.displayName))
                        }
                    }
                    .padding(.vertical, 2)
                }
            }

            sliderRow(
                title: "hand.property.width",
                value: width,
                range: 0.5...2.5,
                step: 0.05,
                fractionDigits: 2,
                onValueChanged: {
                    syncPresetSelectionFromCurrentCustomization()
                }
            )

            sliderRow(
                title: "hand.property.length",
                value: length,
                range: 0.5...1.6,
                step: 0.05,
                fractionDigits: 2,
                onValueChanged: {
                    syncPresetSelectionFromCurrentCustomization()
                }
            )
        }
    }

    @ViewBuilder
    private func sliderRow(
        title: LocalizedStringResource,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double,
        fractionDigits: Int,
        onValueChanged: (() -> Void)? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                Spacer()
                Text(localizedNumber(value.wrappedValue, fractionDigits: fractionDigits))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            Slider(value: value, in: range, step: step)
                .onChange(of: value.wrappedValue) { _, _ in
                    onValueChanged?()
                }
        }
    }

    private func recognizedPreset(for customization: HandCustomization) -> ClockPreset? {
        ClockPreset.selectableCases.first {
            $0.customization.approximatelyMatches(customization)
        }
    }

    private func syncPresetSelectionFromCurrentCustomization() {
        guard !suppressPresetTracking else { return }

        let recognized = recognizedPreset(for: currentHandCustomization) ?? .custom
        if presetRaw != recognized.rawValue {
            presetRaw = recognized.rawValue
        }
    }

    private func applyPreset(_ preset: ClockPreset) {
        guard preset != .custom else { return }
        applyHandCustomization(preset.customization, selectedPreset: preset)
    }

    private func applyHandCustomization(
        _ customization: HandCustomization,
        selectedPreset: ClockPreset
    ) {
        performWhileSuppressingPresetTracking {
            hourTensWidth = customization.hourTensWidth
            hourOnesWidth = customization.hourOnesWidth
            minuteTensWidth = customization.minuteTensWidth
            minuteOnesWidth = customization.minuteOnesWidth
            secondTensWidth = customization.secondTensWidth
            secondOnesWidth = customization.secondOnesWidth

            hourTensLength = customization.hourTensLength
            hourOnesLength = customization.hourOnesLength
            minuteTensLength = customization.minuteTensLength
            minuteOnesLength = customization.minuteOnesLength
            secondTensLength = customization.secondTensLength
            secondOnesLength = customization.secondOnesLength

            setStoredColor(customization.hourTensColor, for: .hourTens)
            setStoredColor(customization.hourOnesColor, for: .hourOnes)
            setStoredColor(customization.minuteTensColor, for: .minuteTens)
            setStoredColor(customization.minuteOnesColor, for: .minuteOnes)
            setStoredColor(customization.secondTensColor, for: .secondTens)
            setStoredColor(customization.secondOnesColor, for: .secondOnes)

            presetRaw = selectedPreset.rawValue
        }
    }

    private func activeResetSourceCustomization() -> HandCustomization {
        switch selectedPreset {
        case .standard, .compact, .contrast, .fine, .technical:
            return selectedPreset.customization
        case .custom:
            return ClockDefaults.preset.customization
        }
    }

    private func handColor(for kind: ClockHandKind) -> StoredClockColor {
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
    }

    private func handColorPickerBinding(for kind: ClockHandKind) -> Binding<Color> {
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

    private func setStoredColor(_ color: StoredClockColor, for kind: ClockHandKind) {
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
    }

    private func setHandAdjustment(_ adjustment: HandAdjustment, for kind: ClockHandKind) {
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

        setStoredColor(adjustment.color, for: kind)
    }

    private func setHandColor(_ color: StoredClockColor, for kind: ClockHandKind) {
        performWhileSuppressingPresetTracking {
            setStoredColor(color, for: kind)
            presetRaw = (recognizedPreset(for: currentHandCustomization) ?? .custom).rawValue
        }
    }

    private func resetHand(_ kind: ClockHandKind) {
        let adjustment = activeResetSourceCustomization().adjustment(for: kind)

        performWhileSuppressingPresetTracking {
            setHandAdjustment(adjustment, for: kind)
            presetRaw = (recognizedPreset(for: currentHandCustomization) ?? .custom).rawValue
        }
    }

    private func applyDefaults() {
        performWhileSuppressingPresetTracking {
            presetRaw = ClockDefaults.preset.rawValue
            appearanceModeRaw = ClockDefaults.appearanceMode.rawValue
            showDigits = ClockDefaults.showDigits
            showTicks = ClockDefaults.showTicks
            useGradientBackground = ClockDefaults.useGradientBackground
            centerDotScale = ClockDefaults.centerDotScale
            dialInset = ClockDefaults.dialInset
            clockModeRaw = ClockDefaults.displayMode.rawValue
            integerOnly = ClockDefaults.integerOnly
            continuousMinuteOnesInIntegerMode = ClockDefaults.continuousMinuteOnesInIntegerMode
            continuousSecondOnesInIntegerMode = ClockDefaults.continuousSecondOnesInIntegerMode
            elenaEnabled = ClockDefaults.elenaEnabled

            let customization = ClockDefaults.preset.customization
            hourTensWidth = customization.hourTensWidth
            hourOnesWidth = customization.hourOnesWidth
            minuteTensWidth = customization.minuteTensWidth
            minuteOnesWidth = customization.minuteOnesWidth
            secondTensWidth = customization.secondTensWidth
            secondOnesWidth = customization.secondOnesWidth

            hourTensLength = customization.hourTensLength
            hourOnesLength = customization.hourOnesLength
            minuteTensLength = customization.minuteTensLength
            minuteOnesLength = customization.minuteOnesLength
            secondTensLength = customization.secondTensLength
            secondOnesLength = customization.secondOnesLength

            setStoredColor(customization.hourTensColor, for: .hourTens)
            setStoredColor(customization.hourOnesColor, for: .hourOnes)
            setStoredColor(customization.minuteTensColor, for: .minuteTens)
            setStoredColor(customization.minuteOnesColor, for: .minuteOnes)
            setStoredColor(customization.secondTensColor, for: .secondTens)
            setStoredColor(customization.secondOnesColor, for: .secondOnes)
        }
    }

    private func performWhileSuppressingPresetTracking(_ updates: () -> Void) {
        suppressPresetTracking = true
        updates()

        DispatchQueue.main.async {
            suppressPresetTracking = false
        }
    }
}

struct CombinedDialFace: View {
    let snapshot: ClockSnapshot
    let settings: ClockSettings

    private enum HandBase {
        static let hourTensLength: CGFloat = 0.22
        static let hourOnesLength: CGFloat = 0.30
        static let minuteTensLength: CGFloat = 0.38
        static let minuteOnesLength: CGFloat = 0.46
        static let secondTensLength: CGFloat = 0.54
        static let secondOnesLength: CGFloat = 0.62

        static let hourTensWidth: CGFloat = 0.020
        static let hourOnesWidth: CGFloat = 0.018
        static let minuteTensWidth: CGFloat = 0.016
        static let minuteOnesWidth: CGFloat = 0.014
        static let secondTensWidth: CGFloat = 0.012
        static let secondOnesWidth: CGFloat = 0.010
    }

    private var hands: [HandSpec] {
        let c = settings.handCustomization

        let baseHands: [HandSpec] = [
            HandSpec(
                id: "hourTens",
                slotValue: snapshot.hourTensSlot,
                color: c.hourTensColor.color,
                lengthRatio: HandBase.hourTensLength * c.hourTensLength,
                lineWidthRatio: HandBase.hourTensWidth * c.hourTensWidth
            ),
            HandSpec(
                id: "hourOnes",
                slotValue: snapshot.hourOnesSlot,
                color: c.hourOnesColor.color,
                lengthRatio: HandBase.hourOnesLength * c.hourOnesLength,
                lineWidthRatio: HandBase.hourOnesWidth * c.hourOnesWidth
            ),
            HandSpec(
                id: "minuteTens",
                slotValue: snapshot.minuteTensSlot,
                color: c.minuteTensColor.color,
                lengthRatio: HandBase.minuteTensLength * c.minuteTensLength,
                lineWidthRatio: HandBase.minuteTensWidth * c.minuteTensWidth
            ),
            HandSpec(
                id: "minuteOnes",
                slotValue: snapshot.minuteOnesSlot,
                color: c.minuteOnesColor.color,
                lengthRatio: HandBase.minuteOnesLength * c.minuteOnesLength,
                lineWidthRatio: HandBase.minuteOnesWidth * c.minuteOnesWidth
            )
        ]

        switch settings.displayMode {
        case .fourHands:
            return baseHands

        case .sixHands:
            return baseHands + [
                HandSpec(
                    id: "secondTens",
                    slotValue: snapshot.secondTensSlot,
                    color: c.secondTensColor.color,
                    lengthRatio: HandBase.secondTensLength * c.secondTensLength,
                    lineWidthRatio: HandBase.secondTensWidth * c.secondTensWidth
                ),
                HandSpec(
                    id: "secondOnes",
                    slotValue: snapshot.secondOnesSlot,
                    color: c.secondOnesColor.color,
                    lengthRatio: HandBase.secondOnesLength * c.secondOnesLength,
                    lineWidthRatio: HandBase.secondOnesWidth * c.secondOnesWidth
                )
            ]
        }
    }

    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
            let dialRadius = size * 0.40
            let numberRadius = size * 0.455
            let centerOuterSize = size * 0.12 * settings.centerDotScale
            let centerInnerSize = size * 0.055 * settings.centerDotScale
            let palette = settings.resolvedPalette
            let rotationSlotOffset = settings.rotationSlotOffset

            ZStack {
                if settings.usesElenaDialArtwork {
                    Image(settings.elenaDialAssetName)
                        .resizable()
                        .interpolation(.high)
                        .antialiased(true)
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .scaleEffect(settings.elenaDialArtworkScale)
                } else {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: palette.dialGradient,
                                center: .center,
                                startRadius: 4,
                                endRadius: dialRadius * 1.35
                            )
                        )

                    Circle()
                        .strokeBorder(Color.primary.opacity(0.16), lineWidth: size * 0.018)

                    if settings.showTicks {
                        tickRing(
                            size: size,
                            center: center,
                            radius: dialRadius,
                            rotationSlotOffset: rotationSlotOffset
                        )
                    }

                    if settings.showDigits {
                        ForEach(0..<10, id: \.self) { digit in
                            let point = pointOnCircle(
                                center: center,
                                radius: numberRadius,
                                angle: slotAngle(for: Double(digit), rotationSlotOffset: rotationSlotOffset)
                            )

                            Text("\(digit)")
                                .font(.system(size: size * 0.09, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.primary)
                                .position(point)
                        }
                    }
                }

                ForEach(hands) { hand in
                    let clampedLength = min(max(hand.lengthRatio, 0.05), 0.78)
                    let effectiveHandLength = clampedLength * settings.handLengthMultiplier

                    let handEnd = pointOnCircle(
                        center: center,
                        radius: size * effectiveHandLength,
                        angle: slotAngle(for: hand.slotValue, rotationSlotOffset: rotationSlotOffset)
                    )

                    Path { path in
                        path.move(to: center)
                        path.addLine(to: handEnd)
                    }
                    .stroke(
                        hand.color,
                        style: StrokeStyle(
                            lineWidth: size * hand.lineWidthRatio,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .shadow(radius: 2)
                }

                Circle()
                    .fill(palette.centerOuterFill)
                    .frame(width: centerOuterSize, height: centerOuterSize)

                Circle()
                    .fill(palette.centerInnerFill)
                    .frame(width: centerInnerSize, height: centerInnerSize)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    @ViewBuilder
    private func tickRing(
        size: CGFloat,
        center: CGPoint,
        radius: CGFloat,
        rotationSlotOffset: Double
    ) -> some View {
        Canvas { context, _ in
            for digit in 0..<10 {
                let angle = slotAngle(for: Double(digit), rotationSlotOffset: rotationSlotOffset)
                let outer = pointOnCircle(center: center, radius: radius, angle: angle)
                let inner = pointOnCircle(center: center, radius: radius * 0.87, angle: angle)

                var path = Path()
                path.move(to: outer)
                path.addLine(to: inner)

                context.stroke(
                    path,
                    with: .color(.primary.opacity(0.20)),
                    style: StrokeStyle(lineWidth: size * 0.013, lineCap: .round)
                )
            }
        }
    }
}

struct AppBackground: View {
    let settings: ClockSettings

    var body: some View {
        let palette = settings.resolvedPalette

        Group {
            if settings.useGradientBackground {
                LinearGradient(
                    colors: palette.backgroundGradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                palette.backgroundGradient[1]
            }
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
    let elenaEnabled: Bool
    let handCustomization: HandCustomization

    var preferredColorSchemeOverride: ColorScheme? {
        appearanceMode.preferredColorScheme
    }

    var resolvedPalette: ClockPalette {
        ClockPalette.palette(for: effectiveColorScheme)
    }

    var rotationSlotOffset: Double {
        elenaEnabled ? -1.0 : 0.0
    }

    var usesElenaDialArtwork: Bool {
        elenaEnabled
    }

    var elenaDialAssetName: String {
        "ElenaDial"
    }

    var elenaDialArtworkScale: CGFloat {
        usesElenaDialArtwork ? 1.50 : 1.0
    }

    var handLengthMultiplier: CGFloat {
        usesElenaDialArtwork ? 0.75 : 1.0
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
    let centerOuterFill: Color
    let centerInnerFill: Color
    let overlayScrim: Color
    let panelBackground: Color
    let panelStroke: Color
    let panelShadow: Color
    let sectionBackground: Color
    let sectionStroke: Color
    let controlTint: Color

    static func palette(for colorScheme: ColorScheme) -> ClockPalette {
        switch colorScheme {
        case .light:
            return ClockPalette(
                backgroundGradient: [
                    Color(red: 0.93, green: 0.95, blue: 0.99),
                    Color(red: 0.90, green: 0.93, blue: 0.98),
                    Color(red: 0.96, green: 0.97, blue: 1.00)
                ],
                dialGradient: [
                    Color.white.opacity(0.96),
                    Color.white.opacity(0.84),
                    Color.black.opacity(0.08)
                ],
                centerOuterFill: Color.black.opacity(0.16),
                centerInnerFill: Color.white.opacity(0.96),
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
                    Color(red: 0.08, green: 0.11, blue: 0.16),
                    Color(red: 0.10, green: 0.14, blue: 0.20),
                    Color(red: 0.06, green: 0.09, blue: 0.14)
                ],
                dialGradient: [
                    Color(red: 0.20, green: 0.25, blue: 0.33),
                    Color(red: 0.13, green: 0.16, blue: 0.23),
                    Color.black.opacity(0.45)
                ],
                centerOuterFill: Color.white.opacity(0.18),
                centerInnerFill: Color(red: 0.92, green: 0.95, blue: 0.99),
                overlayScrim: Color.black.opacity(0.42),
                panelBackground: Color(red: 0.09, green: 0.12, blue: 0.18).opacity(0.72),
                panelStroke: Color.white.opacity(0.12),
                panelShadow: Color.black.opacity(0.42),
                sectionBackground: Color.white.opacity(0.055),
                sectionStroke: Color.white.opacity(0.10),
                controlTint: Color(red: 0.48, green: 0.66, blue: 1.00)
            )

        @unknown default:
            return ClockPalette(
                backgroundGradient: [
                    Color(red: 0.93, green: 0.95, blue: 0.99),
                    Color(red: 0.90, green: 0.93, blue: 0.98),
                    Color(red: 0.96, green: 0.97, blue: 1.00)
                ],
                dialGradient: [
                    Color.white.opacity(0.96),
                    Color.white.opacity(0.84),
                    Color.black.opacity(0.08)
                ],
                centerOuterFill: Color.black.opacity(0.16),
                centerInnerFill: Color.white.opacity(0.96),
                overlayScrim: Color.black.opacity(0.22),
                panelBackground: Color.white.opacity(0.52),
                panelStroke: Color.white.opacity(0.55),
                panelShadow: Color.black.opacity(0.18),
                sectionBackground: Color.white.opacity(0.58),
                sectionStroke: Color.black.opacity(0.06),
                controlTint: Color.blue
            )
        }
    }
}

struct ClockSnapshot {
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

    init(
        date: Date,
        integerOnly: Bool,
        continuousMinuteOnesInIntegerMode: Bool,
        continuousSecondOnesInIntegerMode: Bool
    ) {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: date)

        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        let nanosecond = components.nanosecond ?? 0

        let fractionalSecond = max(0.0, min(0.999_999, Double(nanosecond) / 1_000_000_000.0))
        let preciseSecond = Double(second) + fractionalSecond
        let preciseMinute = Double(minute) + preciseSecond / 60.0
        let preciseHour = Double(hour) + preciseMinute / 60.0

        let computedHourTens = hour / 10
        let computedHourOnes = hour % 10
        let computedMinuteTens = minute / 10
        let computedMinuteOnes = minute % 10
        let computedSecondTens = second / 10
        let computedSecondOnes = second % 10

        hourTensDigit = computedHourTens
        hourOnesDigit = computedHourOnes
        minuteTensDigit = computedMinuteTens
        minuteOnesDigit = computedMinuteOnes
        secondTensDigit = computedSecondTens
        secondOnesDigit = computedSecondOnes

        if integerOnly {
            hourTensSlot = Double(computedHourTens)
            hourOnesSlot = Double(computedHourOnes)
            minuteTensSlot = Double(computedMinuteTens)
            minuteOnesSlot = continuousMinuteOnesInIntegerMode ? preciseMinute : Double(computedMinuteOnes)
            secondTensSlot = Double(computedSecondTens)
            secondOnesSlot = continuousSecondOnesInIntegerMode ? preciseSecond : Double(computedSecondOnes)
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

func slotAngle(for slot: Double, rotationSlotOffset: Double = 0.0) -> Angle {
    Angle.degrees(-90.0 + (slot + rotationSlotOffset) * 36.0)
}

func pointOnCircle(center: CGPoint, radius: CGFloat, angle: Angle) -> CGPoint {
    let radians = CGFloat(angle.radians)
    return CGPoint(
        x: center.x + CoreGraphics.cos(radians) * radius,
        y: center.y + CoreGraphics.sin(radians) * radius
    )
}

#Preview {
    ContentView()
}
