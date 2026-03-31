/* /Users/drebin/Documents/software/urks/urks/ContentView+Settings.swift */
import SwiftUI
import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

extension ContentView {
    private func localizedString(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }

    private func localizedFormat(_ key: String, _ arguments: CVarArg...) -> String {
        String(
            format: localizedString(key),
            locale: Locale.current,
            arguments: arguments
        )
    }

    private func handWidthLabel(_ value: Double) -> String {
        switch value {
        case ..<0.007:
            return localizedString("settings.handWidth.veryFine")
        case ..<0.011:
            return localizedString("settings.handWidth.fine")
        case ..<0.016:
            return localizedString("settings.handWidth.normal")
        case ..<0.022:
            return localizedString("settings.handWidth.bold")
        default:
            return localizedString("settings.handWidth.veryBold")
        }
    }

    private func handLengthPercentOfRadiusText(_ value: Double) -> String {
        let percent = localizedNumber((value / ClockGeometry.maxHandLengthRatio) * 100.0, fractionDigits: 0)
        return localizedFormat("settings.handLengthPercentOfRadiusFormat", percent)
    }

    private var colorSettingsExpandedBinding: Binding<Bool> {
        Binding(
            get: { colorSettingsExpanded },
            set: { newValue in
                colorSettingsExpanded = newValue

                if newValue {
                    handColorsExpanded = true
                    dialColorsExpanded = true
                } else {
                    handColorsExpanded = false
                    dialColorsExpanded = false
                }
            }
        )
    }

    @ViewBuilder
    private func appearanceModeSection(settings: ClockSettings, palette: ClockPalette) -> some View {
        settingsCard(palette: palette) {
            VStack(alignment: .leading, spacing: 12) {
                Text("settings.label.appearance")
                    .font(.system(.headline, design: .rounded))

                Picker("settings.appearance", selection: appearanceModeRawBinding) {
                    ForEach(ClockAppearanceMode.allCases) { mode in
                        Text(mode.displayName).tag(mode.rawValue)
                    }
                }
                .pickerStyle(.segmented)

                Text(settings.appearanceDescription)
                    .font(.system(.footnote, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    func settingsOverlay(settings: ClockSettings, palette: ClockPalette? = nil) -> some View {
        let resolvedPalette = palette ?? settings.resolvedPalette

        ZStack {
            resolvedPalette.overlayScrim
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedHandForEditing = nil
                        selectedSurfaceRoleForEditing = nil
                        showSettings = false
                    }
                }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    settingsHeader(settings: settings, palette: resolvedPalette)

                    if let kind = selectedHandForEditing {
                        handEditorInlinePage(kind: kind, palette: resolvedPalette)
                    } else if let role = selectedSurfaceRoleForEditing {
                        surfaceEditorInlinePage(role: role, palette: resolvedPalette)
                    } else {
                        settingsSectionPicker(palette: resolvedPalette)

                        switch settingsSection {
                        case .design:
                            designSettingsPage(settings: settings, palette: resolvedPalette)
                        case .timeZone:
                            widgetSettingsPage(palette: resolvedPalette)
                        }
                    }

                    settingsFooter(palette: resolvedPalette)
                }
                .padding(20)
                .tint(resolvedPalette.controlTint)
            }
            .frame(maxWidth: 520, maxHeight: 820)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.ultraThinMaterial)

                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(resolvedPalette.panelBackground)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(resolvedPalette.panelStroke, lineWidth: 1)
            )
            .shadow(color: resolvedPalette.panelShadow, radius: 24, x: 0, y: 14)
            .padding(20)
        }
    }

    @ViewBuilder
    func settingsHeader(settings: ClockSettings, palette: ClockPalette) -> some View {
        settingsCard(palette: palette) {
            if let kind = selectedHandForEditing {
                HStack(alignment: .center, spacing: 12) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedHandForEditing = nil
                            selectedSurfaceRoleForEditing = nil
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("settings.back")
                        }
                    }
                    .buttonStyle(.bordered)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(kind.title)
                            .font(.system(.title3, design: .rounded, weight: .bold))

                        Text("settings.handEditor.description")
                            .font(.system(.footnote, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        resetHand(kind)
                    } label: {
                        Text("action.reset")
                    }
                    .buttonStyle(.bordered)
                }
            } else if let role = selectedSurfaceRoleForEditing {
                HStack(alignment: .center, spacing: 12) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedHandForEditing = nil
                            selectedSurfaceRoleForEditing = nil
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("settings.back")
                        }
                    }
                    .buttonStyle(.bordered)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(role.title)
                            .font(.system(.title3, design: .rounded, weight: .bold))

                        Text("settings.surfaceEditor.description")
                            .font(.system(.footnote, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        resetSurfaceRole(role)
                    } label: {
                        Text("action.reset")
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("settings.title")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                    }

                    Spacer()

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedHandForEditing = nil
                            selectedSurfaceRoleForEditing = nil
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
            }
        }
    }

    @ViewBuilder
    func settingsSectionPicker(palette: ClockPalette) -> some View {
        settingsCard(palette: palette) {
            Picker("settings.sectionSelector", selection: $settingsSection) {
                ForEach(SettingsSection.allCases) { section in
                    Text(section.title).tag(section)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    @ViewBuilder
    func designSettingsPage(settings: ClockSettings, palette: ClockPalette) -> some View {
        appearanceModeSection(settings: settings, palette: palette)
        clockSettingsPage(settings: settings, palette: palette)
        handsSettingsPage(settings: settings, palette: palette)
    }

    @ViewBuilder
    func clockSettingsPage(settings: ClockSettings, palette: ClockPalette) -> some View {
        settingsCard(palette: palette) {
            DisclosureGroup(isExpanded: $appearanceSettingsExpanded) {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("settings.label.handCount")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))

                        Picker("settings.mode", selection: clockModeRawBinding) {
                            ForEach(ClockDisplayMode.allCases) { mode in
                                Text(mode.displayName).tag(mode.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("settings.label.markings")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))

                        Picker("settings.label.markings", selection: dialMarkingModeBinding) {
                            ForEach(ClockDialMarkingMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Divider()

                    DisclosureGroup {
                        VStack(alignment: .leading, spacing: 14) {
                            Toggle("settings.integerOnly", isOn: integerOnlyBinding)

                            if integerOnly {
                                Toggle("settings.continuousMinuteOnesInIntegerMode", isOn: continuousMinuteOnesInIntegerModeBinding)

                                if settings.displayMode == .sixHands {
                                    Toggle("settings.continuousSecondOnesInIntegerMode", isOn: continuousSecondOnesInIntegerModeBinding)
                                }
                            }
                        }
                        .padding(.top, 8)
                        .padding(.trailing, 8)
                    } label: {
                        Text("settings.page.advanced")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    }
                }
                .padding(.top, 8)
            } label: {
                Text("settings.page.appearance")
                    .font(.system(.headline, design: .rounded))
            }
        }
    }

    @ViewBuilder
    func handsSettingsPage(settings: ClockSettings, palette: ClockPalette) -> some View {
        settingsCard(palette: palette) {
            DisclosureGroup(isExpanded: colorSettingsExpandedBinding) {
                VStack(alignment: .leading, spacing: 14) {
                    DisclosureGroup(isExpanded: $handColorsExpanded) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(settings.displayMode.visibleHandKinds) { kind in
                                handRow(kind: kind, palette: palette)

                                if kind.id != settings.displayMode.visibleHandKinds.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .padding(.top, 10)
                    } label: {
                        Text("settings.page.hands")
                            .font(.system(.headline, design: .rounded))
                    }

                    DisclosureGroup(isExpanded: $dialColorsExpanded) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(ClockSurfaceColorRole.allCases) { role in
                                surfaceRow(role: role, palette: palette)

                                if role.id != ClockSurfaceColorRole.allCases.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .padding(.top, 10)
                    } label: {
                        Text("settings.page.dial")
                            .font(.system(.headline, design: .rounded))
                    }
                }
                .padding(.top, 8)
            } label: {
                Text("settings.page.colors")
                    .font(.system(.headline, design: .rounded))
            }
        }
    }

    @ViewBuilder
    func handEditorInlinePage(kind: ClockHandKind, palette: ClockPalette) -> some View {
        handSection(
            kind: kind,
            width: handWidthBinding(for: kind),
            length: handLengthBinding(for: kind),
            palette: palette
        )
    }

    @ViewBuilder
    func surfaceEditorInlinePage(role: ClockSurfaceColorRole, palette: ClockPalette) -> some View {
        let selectedColor = surfaceColor(for: role)

        settingsCard(palette: palette) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 12) {
                    Text("settings.color")
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
                        selection: surfaceColorPickerBinding(for: role),
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
                                setSurfaceColor(presetColor.storedColor, for: role)
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
        }
    }

    @ViewBuilder
    func widgetSettingsPage(palette: ClockPalette) -> some View {
        settingsCard(palette: palette) {
            VStack(alignment: .leading, spacing: 14) {
                Text("settings.page.timeZone")
                    .font(.system(.headline, design: .rounded))

                widgetCitySearchSection(
                    title: "settings.widget.primaryClock",
                    currentCityName: resolvedPrimaryCityName,
                    currentTimeZoneIdentifier: widgetPrimaryTimeZoneIdentifier,
                    model: primaryCitySearchModel,
                    onUseLocal: {
                        widgetPrimaryTimeZoneIdentifier = TimeZone.current.identifier
                        widgetPrimaryCityName = widgetDefaultCityName(for: TimeZone.current.identifier)
                        primaryCitySearchModel.setDisplayText(widgetPrimaryCityName)
                        syncWidgetSharedDefaults()
                    },
                    onResolved: { cityName, timeZoneIdentifier in
                        widgetPrimaryCityName = cityName
                        widgetPrimaryTimeZoneIdentifier = timeZoneIdentifier
                        syncWidgetSharedDefaults()
                    }
                )

                Toggle("settings.widget.enableSecondClockWide", isOn: widgetSecondaryClockEnabledBinding)

                if widgetSecondaryClockEnabled {
                    widgetCitySearchSection(
                        title: "settings.widget.secondaryClock",
                        currentCityName: resolvedSecondaryCityName,
                        currentTimeZoneIdentifier: widgetSecondaryTimeZoneIdentifier,
                        model: secondaryCitySearchModel,
                        onUseLocal: nil,
                        onResolved: { cityName, timeZoneIdentifier in
                            widgetSecondaryCityName = cityName
                            widgetSecondaryTimeZoneIdentifier = timeZoneIdentifier
                            syncWidgetSharedDefaults()
                        }
                    )
                }
            }
        }
    }

    @ViewBuilder
    func settingsFooter(palette: ClockPalette) -> some View {
        settingsCard(palette: palette) {
            Button {
                applyDefaults()
            } label: {
                Text("action.resetDefaults")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }

    @ViewBuilder
    func handRow(kind: ClockHandKind, palette: ClockPalette) -> some View {
        let adjustment = currentHandAdjustment(for: kind)
        let summary = localizedFormat(
            "settings.handSummaryFormat",
            handWidthLabel(adjustment.width),
            handLengthPercentOfRadiusText(adjustment.length)
        )

        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedSurfaceRoleForEditing = nil
                selectedHandForEditing = kind
            }
        } label: {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(adjustment.color.color)
                    .frame(width: 28, height: 18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(Color.primary.opacity(0.14), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(kind.title)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(summary)
                        .font(.system(.footnote, design: .rounded))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .tint(palette.controlTint)
    }

    @ViewBuilder
    func surfaceRow(role: ClockSurfaceColorRole, palette: ClockPalette) -> some View {
        let color = surfaceColor(for: role)

        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedHandForEditing = nil
                selectedSurfaceRoleForEditing = role
            }
        } label: {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(color.color)
                    .frame(width: 28, height: 18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(Color.primary.opacity(0.14), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(role.title)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(color.displayName)
                        .font(.system(.footnote, design: .rounded))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .tint(palette.controlTint)
    }

    @ViewBuilder
    func widgetCitySearchSection(
        title: LocalizedStringResource,
        currentCityName: String,
        currentTimeZoneIdentifier: String,
        model: WidgetCitySearchModel,
        onUseLocal: (() -> Void)?,
        onResolved: @escaping (_ cityName: String, _ timeZoneIdentifier: String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))

                Spacer()

                if let onUseLocal {
                    Button("settings.useLocal") {
                        onUseLocal()
                    }
                    .buttonStyle(.bordered)
                }
            }

            Text(localizedFormat("settings.cityTimeZoneFormat", currentCityName, currentTimeZoneIdentifier))
                .font(.system(.footnote, design: .rounded))
                .foregroundStyle(.secondary)

            TextField(
                "settings.widget.cityInput",
                text: Binding(
                    get: { model.query },
                    set: { newValue in
                        model.query = newValue
                        model.updateQuery(newValue)
                    }
                )
            )
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled()

            if !model.suggestions.isEmpty {
                VStack(spacing: 0) {
                    ForEach(Array(model.suggestions.prefix(6))) { suggestion in
                        Button {
                            model.selectSuggestion(suggestion) { cityName, timeZoneIdentifier in
                                onResolved(cityName, timeZoneIdentifier)
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(suggestion.primaryText)
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                if !suggestion.secondaryText.isEmpty {
                                    Text(suggestion.secondaryText)
                                        .font(.system(.footnote, design: .rounded))
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        if suggestion.id != model.suggestions.prefix(6).last?.id {
                            Divider()
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.primary.opacity(0.04))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
            }

            if let errorMessage = model.errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(.footnote, design: .rounded))
                    .foregroundStyle(.red)
            }
        }
    }

    func settingsCard<Content: View>(
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
    func handSection(
        kind: ClockHandKind,
        width: Binding<Double>,
        length: Binding<Double>,
        palette: ClockPalette
    ) -> some View {
        let selectedColor = handColor(for: kind)

        settingsCard(palette: palette) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 12) {
                    Text("settings.color")
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
                title: "settings.slider.width",
                value: width,
                range: 0.004...0.030,
                step: 0.0005,
                fractionDigits: 3,
                valueText: handWidthLabel(width.wrappedValue),
                onValueChanged: {
                    syncWidgetSharedDefaults()
                }
            )

            sliderRow(
                title: "settings.slider.length",
                value: length,
                range: 0.120...ClockGeometry.maxHandLengthRatio,
                step: 0.005,
                fractionDigits: 3,
                valueText: handLengthPercentOfRadiusText(length.wrappedValue),
                onValueChanged: {
                    syncWidgetSharedDefaults()
                }
            )
        }
    }

    @ViewBuilder
    func sliderRow(
        title: LocalizedStringResource,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double,
        fractionDigits: Int,
        valueText: String? = nil,
        onValueChanged: (() -> Void)? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                Spacer()
                Text(valueText ?? localizedNumber(value.wrappedValue, fractionDigits: fractionDigits))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            Slider(value: value, in: range, step: step)
                .onChange(of: value.wrappedValue) { _, _ in
                    onValueChanged?()
                }
        }
    }
}
