/* /Users/drebin/Documents/software/urks/urks/ContentView.swift */
import SwiftUI

enum SettingsSection: String, CaseIterable, Identifiable {
    case design
    case timeZone

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .design:
            return "settings.section.design"
        case .timeZone:
            return "settings.section.timeZone"
        }
    }
}

enum ClockDialMarkingMode: String, CaseIterable, Identifiable {
    case digits
    case ticks

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .digits:
            return "settings.markingMode.digits"
        case .ticks:
            return "settings.markingMode.ticks"
        }
    }
}

enum ClockColorEditingMode: String, CaseIterable, Identifiable {
    case light
    case dark

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .light:
            return "settings.colorMode.light"
        case .dark:
            return "settings.colorMode.dark"
        }
    }

    var colorScheme: ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

enum ClockSurfaceColorRole: String, CaseIterable, Identifiable {
    case markings
    case ring
    case dialBackground
    case appBackground

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .markings:
            return "settings.surface.markings"
        case .ring:
            return "settings.surface.ring"
        case .dialBackground:
            return "settings.surface.dialBackground"
        case .appBackground:
            return "settings.surface.appBackground"
        }
    }
}

enum MainPage: Int, CaseIterable, Identifiable {
    case clock
    case stopwatch

    var id: Int { rawValue }
}

struct ContentView: View {
    @Environment(\.colorScheme) var systemColorScheme

    @StateObject var settingsStore = ClockSettingsStore()
    @StateObject var primaryCitySearchModel = WidgetCitySearchModel()
    @StateObject var secondaryCitySearchModel = WidgetCitySearchModel()
    @StateObject var stopwatchModel = StopwatchModel()

    @State var selectedPage: MainPage = .clock
    @State var settingsSection: SettingsSection = .design
    @State var selectedHandForEditing: ClockHandKind?
    @State var selectedSurfaceRoleForEditing: ClockSurfaceColorRole?
    @State var appearanceSettingsExpanded = false
    @State var colorSettingsExpanded = false
    @State var handColorsExpanded = false
    @State var dialColorsExpanded = false
    @State var showSettings = ClockDefaults.showSettings
    @State var suppressWidgetSync = false

    var dialMarkingMode: ClockDialMarkingMode {
        currentPreferences.dialMarkingMode
    }

    var dialMarkingModeBinding: Binding<ClockDialMarkingMode> {
        Binding(
            get: { dialMarkingMode },
            set: { newValue in
                setDialMarkingMode(newValue)
            }
        )
    }

    var showDigits: Bool {
        currentPreferences.showDigits
    }

    var showTicks: Bool {
        currentPreferences.showTicks
    }

    var resolvedPrimaryCityName: String {
        currentPreferences.resolvedPrimaryCityName
    }

    var resolvedSecondaryCityName: String {
        currentPreferences.resolvedSecondaryCityName
    }

    var activeColorEditingMode: ClockColorEditingMode {
        switch currentPreferences.appearanceMode.resolvedColorScheme(system: systemColorScheme) {
        case .light:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return .light
        }
    }

    var body: some View {
        let settings = currentPreferences.makeClockSettings(systemColorScheme: systemColorScheme)

        ZStack {
            AppBackground(settings: settings)
                .ignoresSafeArea()

            TabView(selection: $selectedPage) {
                clockPage(settings: settings)
                    .tag(MainPage.clock)

                StopwatchView(
                    model: stopwatchModel,
                    settings: settings
                )
                .tag(MainPage.stopwatch)
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))

            if showSettings && selectedPage == .clock {
                settingsOverlay(settings: settings)
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
                    .zIndex(10)
            }
        }
        .preferredColorScheme(settings.preferredColorSchemeOverride)
        .onAppear {
            migrateThemeColorSettingsIfNeeded()
            migrateDialMarkingModeIfNeeded()

            if widgetPrimaryCityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                widgetPrimaryCityName = widgetDefaultCityName(for: widgetPrimaryTimeZoneIdentifier)
            }

            primaryCitySearchModel.setDisplayText(currentPreferences.resolvedPrimaryCityName)

            if widgetSecondaryClockEnabled {
                secondaryCitySearchModel.setDisplayText(currentPreferences.resolvedSecondaryCityName)
            }

            syncWidgetSharedDefaults()
        }
        .onOpenURL { url in
            handleDeepLink(url)
        }
        .onChange(of: selectedPage) { _, newValue in
            guard newValue != .clock else {
                return
            }

            if showSettings {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedHandForEditing = nil
                    selectedSurfaceRoleForEditing = nil
                    showSettings = false
                }
            }
        }
        .onChange(of: appearanceModeRaw) { _, _ in
            syncWidgetSharedDefaults()
        }
        .onChange(of: dialMarkingModeRaw) { _, _ in
            syncWidgetSharedDefaults()
        }
        .onChange(of: clockModeRaw) { _, _ in
            syncWidgetSharedDefaults()
        }
        .onChange(of: integerOnly) { _, _ in
            syncWidgetSharedDefaults()
        }
        .onChange(of: continuousMinuteOnesInIntegerMode) { _, _ in
            syncWidgetSharedDefaults()
        }
        .onChange(of: continuousSecondOnesInIntegerMode) { _, _ in
            syncWidgetSharedDefaults()
        }
        .onChange(of: widgetPrimaryTimeZoneIdentifier) { _, _ in
            if widgetPrimaryCityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                widgetPrimaryCityName = widgetDefaultCityName(for: widgetPrimaryTimeZoneIdentifier)
                primaryCitySearchModel.setDisplayText(widgetPrimaryCityName)
            }
        }
        .onChange(of: widgetSecondaryClockEnabled) { _, isEnabled in
            if isEnabled {
                if widgetSecondaryCityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    widgetSecondaryCityName = widgetDefaultCityName(for: widgetSecondaryTimeZoneIdentifier)
                }
                secondaryCitySearchModel.setDisplayText(currentPreferences.resolvedSecondaryCityName)
            } else {
                secondaryCitySearchModel.clear()
            }
            syncWidgetSharedDefaults()
        }
        .onChange(of: widgetSecondaryTimeZoneIdentifier) { _, _ in
            if widgetSecondaryCityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                widgetSecondaryCityName = widgetDefaultCityName(for: widgetSecondaryTimeZoneIdentifier)
                secondaryCitySearchModel.setDisplayText(widgetSecondaryCityName)
            }
        }
    }

    @ViewBuilder
    private func clockPage(settings: ClockSettings) -> some View {
        LiveClockFace(settings: settings)
            .padding(settings.dialInset)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if showSettings {
                        selectedHandForEditing = nil
                        selectedSurfaceRoleForEditing = nil
                    }
                    showSettings.toggle()
                }
            }
    }

    func setDialMarkingMode(_ mode: ClockDialMarkingMode) {
        dialMarkingModeRaw = mode.rawValue
        legacyShowDigits = (mode == .digits)
        legacyShowTicks = (mode == .ticks)
    }

    func migrateDialMarkingModeIfNeeded() {
        let resolvedMode = ClockPreferences.resolvedDialMarkingMode(
            dialMarkingModeRaw: dialMarkingModeRaw,
            legacyShowDigits: legacyShowDigits,
            legacyShowTicks: legacyShowTicks
        )

        setDialMarkingMode(resolvedMode)
    }

    func migrateThemeColorSettingsIfNeeded() {
        guard clockColorCustomizationMigrationVersion < 1 else {
            return
        }

        darkHourTensColorRed = hourTensColorRed
        darkHourTensColorGreen = hourTensColorGreen
        darkHourTensColorBlue = hourTensColorBlue

        darkHourOnesColorRed = hourOnesColorRed
        darkHourOnesColorGreen = hourOnesColorGreen
        darkHourOnesColorBlue = hourOnesColorBlue

        darkMinuteTensColorRed = minuteTensColorRed
        darkMinuteTensColorGreen = minuteTensColorGreen
        darkMinuteTensColorBlue = minuteTensColorBlue

        darkMinuteOnesColorRed = minuteOnesColorRed
        darkMinuteOnesColorGreen = minuteOnesColorGreen
        darkMinuteOnesColorBlue = minuteOnesColorBlue

        darkSecondTensColorRed = secondTensColorRed
        darkSecondTensColorGreen = secondTensColorGreen
        darkSecondTensColorBlue = secondTensColorBlue

        darkSecondOnesColorRed = secondOnesColorRed
        darkSecondOnesColorGreen = secondOnesColorGreen
        darkSecondOnesColorBlue = secondOnesColorBlue

        clockColorCustomizationMigrationVersion = 1
    }

    func handleDeepLink(_ url: URL) {
        guard UrksDeepLink.isConfigureSecondClockURL(url) else {
            return
        }

        openWidgetConfigurationForSecondClock()
    }

    func openWidgetConfigurationForSecondClock() {
        if widgetSecondaryTimeZoneIdentifier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            widgetSecondaryTimeZoneIdentifier = "UTC"
        }

        if widgetSecondaryCityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            widgetSecondaryCityName = widgetDefaultCityName(for: widgetSecondaryTimeZoneIdentifier)
        }

        secondaryCitySearchModel.setDisplayText(currentPreferences.resolvedSecondaryCityName)

        withAnimation(.easeInOut(duration: 0.2)) {
            selectedPage = .clock
            selectedHandForEditing = nil
            selectedSurfaceRoleForEditing = nil
            settingsSection = .timeZone
            widgetSecondaryClockEnabled = true
            showSettings = true
        }

        syncWidgetSharedDefaults()
    }
}

#Preview {
    ContentView()
}
