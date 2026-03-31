/* /Users/drebin/Documents/software/urks/urksWidget/urksWidget.swift */
import WidgetKit
import SwiftUI

private func localizedWidgetString(
    _ key: String,
    fallbackGerman: String,
    fallbackEnglish: String
) -> String {
    let value = NSLocalizedString(key, comment: "")
    if value != key {
        return value
    }

    let preferredLanguage = Locale.preferredLanguages.first?.lowercased() ?? ""
    if preferredLanguage.hasPrefix("de") {
        return fallbackGerman
    }

    return fallbackEnglish
}

struct UrksWidgetEntry: TimelineEntry {
    let date: Date
}

struct UrksWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> UrksWidgetEntry {
        UrksWidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (UrksWidgetEntry) -> Void) {
        completion(UrksWidgetEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<UrksWidgetEntry>) -> Void) {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()

        let startOfCurrentMinute = calendar.date(
            bySettingHour: calendar.component(.hour, from: now),
            minute: calendar.component(.minute, from: now),
            second: 0,
            of: now
        ) ?? now

        var entries: [UrksWidgetEntry] = []

        for minuteOffset in 0..<180 {
            guard let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: startOfCurrentMinute) else {
                continue
            }

            entries.append(UrksWidgetEntry(date: entryDate))
        }

        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct urksWidget: Widget {
    let kind: String = "urksWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UrksWidgetProvider()) { entry in
            UrksWidgetRootView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
        .configurationDisplayName("widget.configurationDisplayName")
        .description("widget.description")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .systemExtraLarge,
            .accessoryInline,
            .accessoryRectangular
        ])
        .containerBackgroundRemovable(true)
        .contentMarginsDisabled()
    }
}

struct UrksWidgetRootView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var systemColorScheme

    let entry: UrksWidgetEntry

    var body: some View {
        let options = UrksSharedWidgetSettings.loadWidgetOptions()
        let effectiveColorScheme = systemColorScheme
        let handPalette = UrksSharedWidgetSettings.loadHandPalette(for: effectiveColorScheme)
        let surfacePalette = UrksSharedWidgetSettings.loadSurfacePalette(for: effectiveColorScheme)
        let handMetrics = UrksSharedWidgetSettings.loadHandMetrics()

        let systemPalette = UrksWidgetRenderPalette.system(
            colorScheme: effectiveColorScheme,
            handPalette: handPalette,
            surfacePalette: surfacePalette
        )

        let accessoryPalette = UrksWidgetRenderPalette.accessory(
            colorScheme: effectiveColorScheme,
            handPalette: handPalette,
            surfacePalette: surfacePalette
        )

        switch family {
        case .accessoryInline:
            UrksWidgetInlineSummaryView(
                snapshot: snapshot(for: options.primaryClockLocation, options: options)
            )

        case .accessoryRectangular:
            UrksWidgetAccessoryRectangularClockView(
                snapshot: snapshot(for: options.primaryClockLocation, options: options),
                palette: accessoryPalette,
                handMetrics: handMetrics,
                options: options
            )

        case .systemSmall:
            UrksWidgetSystemSmallClockView(
                snapshot: snapshot(for: options.primaryClockLocation, options: options),
                palette: systemPalette,
                handMetrics: handMetrics,
                options: options
            )

        case .systemMedium, .systemLarge, .systemExtraLarge:
            UrksWidgetSystemScalableClockView(
                family: family,
                date: entry.date,
                palette: systemPalette,
                handMetrics: handMetrics,
                options: options
            )

        default:
            UrksWidgetSystemSmallClockView(
                snapshot: snapshot(for: options.primaryClockLocation, options: options),
                palette: systemPalette,
                handMetrics: handMetrics,
                options: options
            )
        }
    }

    private func snapshot(
        for location: UrksSharedClockLocation,
        options: UrksSharedWidgetOptions
    ) -> UrksSharedSnapshot {
        UrksSharedSnapshot(
            date: entry.date,
            timeZone: location.timeZone,
            integerOnly: options.integerOnly,
            continuousMinuteOnesInIntegerMode: options.continuousMinuteOnesInIntegerMode,
            continuousSecondOnesInIntegerMode: options.continuousSecondOnesInIntegerMode
        )
    }
}

struct UrksWidgetInlineSummaryView: View {
    let snapshot: UrksSharedSnapshot

    var body: some View {
        Text(
            verbatim: "\(localizedWidgetString("widget.brand", fallbackGerman: "Urks", fallbackEnglish: "Urks")) \(snapshot.hourMinuteText)"
        )
        .monospacedDigit()
    }
}

struct UrksWidgetAccessoryRectangularClockView: View {
    let snapshot: UrksSharedSnapshot
    let palette: UrksWidgetRenderPalette
    let handMetrics: UrksSharedHandMetrics
    let options: UrksSharedWidgetOptions

    var body: some View {
        HStack(spacing: 8) {
            UrksWidgetDialView(
                snapshot: snapshot,
                palette: palette,
                handMetrics: handMetrics,
                displayMode: options.displayMode,
                showDigits: options.showDigits,
                showTicks: options.showTicks
            )
            .frame(width: 46, height: 46)

            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: localizedWidgetString("widget.brand", fallbackGerman: "Urks", fallbackEnglish: "Urks"))
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text(snapshot.hourMinuteText)
                    .font(.headline)
                    .fontWeight(.bold)
                    .monospacedDigit()

                Text(snapshot.standardTimeText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            Spacer(minLength: 0)
        }
    }
}

struct UrksWidgetSystemSmallClockView: View {
    let snapshot: UrksSharedSnapshot
    let palette: UrksWidgetRenderPalette
    let handMetrics: UrksSharedHandMetrics
    let options: UrksSharedWidgetOptions

    var body: some View {
        UrksWidgetDialView(
            snapshot: snapshot,
            palette: palette,
            handMetrics: handMetrics,
            displayMode: options.displayMode,
            showDigits: options.showDigits,
            showTicks: options.showTicks
        )
        .padding(0)
    }
}

struct UrksWidgetSystemLayoutMetrics {
    let horizontalSpacing: CGFloat
    let outerHorizontalPadding: CGFloat
    let outerVerticalPadding: CGFloat
    let reservedLabelHeight: CGFloat
    let reservedSpacing: CGFloat
    let minimumColumnWidth: CGFloat
    let minimumClockSize: CGFloat
    let multiClockMaxSize: CGFloat
    let singleClockMaxSize: CGFloat

    static func forFamily(_ family: WidgetFamily) -> UrksWidgetSystemLayoutMetrics {
        switch family {
        case .systemLarge:
            return UrksWidgetSystemLayoutMetrics(
                horizontalSpacing: 14,
                outerHorizontalPadding: 12,
                outerVerticalPadding: 10,
                reservedLabelHeight: 34,
                reservedSpacing: 6,
                minimumColumnWidth: 120,
                minimumClockSize: 110,
                multiClockMaxSize: 160,
                singleClockMaxSize: 220
            )

        case .systemExtraLarge:
            return UrksWidgetSystemLayoutMetrics(
                horizontalSpacing: 18,
                outerHorizontalPadding: 16,
                outerVerticalPadding: 14,
                reservedLabelHeight: 40,
                reservedSpacing: 8,
                minimumColumnWidth: 140,
                minimumClockSize: 130,
                multiClockMaxSize: 220,
                singleClockMaxSize: 280
            )

        case .systemMedium:
            fallthrough
        default:
            return UrksWidgetSystemLayoutMetrics(
                horizontalSpacing: 10,
                outerHorizontalPadding: 6,
                outerVerticalPadding: 4,
                reservedLabelHeight: 30,
                reservedSpacing: 4,
                minimumColumnWidth: 84,
                minimumClockSize: 72,
                multiClockMaxSize: 104,
                singleClockMaxSize: 128
            )
        }
    }
}

struct UrksWidgetSystemScalableClockView: View {
    let family: WidgetFamily
    let date: Date
    let palette: UrksWidgetRenderPalette
    let handMetrics: UrksSharedHandMetrics
    let options: UrksSharedWidgetOptions

    private var clocks: [UrksWidgetMediumClockModel] {
        var items: [UrksWidgetMediumClockModel] = []

        let primary = options.primaryClockLocation
        items.append(
            UrksWidgetMediumClockModel(
                id: "primary-\(primary.timeZoneIdentifier)",
                cityName: primary.cityName,
                snapshot: UrksSharedSnapshot(
                    date: date,
                    timeZone: primary.timeZone,
                    integerOnly: options.integerOnly,
                    continuousMinuteOnesInIntegerMode: options.continuousMinuteOnesInIntegerMode,
                    continuousSecondOnesInIntegerMode: options.continuousSecondOnesInIntegerMode
                )
            )
        )

        if let secondary = options.secondaryClockLocation {
            items.append(
                UrksWidgetMediumClockModel(
                    id: "secondary-\(secondary.timeZoneIdentifier)",
                    cityName: secondary.cityName,
                    snapshot: UrksSharedSnapshot(
                        date: date,
                        timeZone: secondary.timeZone,
                        integerOnly: options.integerOnly,
                        continuousMinuteOnesInIntegerMode: options.continuousMinuteOnesInIntegerMode,
                        continuousSecondOnesInIntegerMode: options.continuousSecondOnesInIntegerMode
                    )
                )
            )
        }

        return items
    }

    private var showsAddPlaceholder: Bool {
        clocks.count == 1
    }

    private var displayedColumnCount: Int {
        showsAddPlaceholder ? 2 : clocks.count
    }

    var body: some View {
        let metrics = UrksWidgetSystemLayoutMetrics.forFamily(family)

        GeometryReader { proxy in
            let totalSpacing = metrics.horizontalSpacing * CGFloat(max(displayedColumnCount - 1, 0))
            let availableWidth = proxy.size.width - (metrics.outerHorizontalPadding * 2) - totalSpacing
            let perColumnWidth = max(metrics.minimumColumnWidth, availableWidth / CGFloat(displayedColumnCount))

            let availableHeight = proxy.size.height - (metrics.outerVerticalPadding * 2)
            let verticalClockBudget = max(
                metrics.minimumClockSize,
                availableHeight - metrics.reservedLabelHeight - metrics.reservedSpacing
            )

            let widthCappedClockSize: CGFloat = displayedColumnCount > 1
                ? min(metrics.multiClockMaxSize, perColumnWidth)
                : min(metrics.singleClockMaxSize, perColumnWidth)

            let clockSize = min(widthCappedClockSize, verticalClockBudget)

            HStack(spacing: metrics.horizontalSpacing) {
                ForEach(clocks) { clock in
                    UrksWidgetMediumClockColumn(
                        clock: clock,
                        palette: palette,
                        handMetrics: handMetrics,
                        options: options,
                        clockSize: clockSize,
                        reservedLabelHeight: metrics.reservedLabelHeight
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                if showsAddPlaceholder {
                    UrksWidgetAddClockPlaceholderColumn(
                        palette: palette,
                        clockSize: clockSize,
                        reservedLabelHeight: metrics.reservedLabelHeight
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, metrics.outerHorizontalPadding)
            .padding(.vertical, metrics.outerVerticalPadding)
        }
    }
}

struct UrksWidgetMediumClockColumn: View {
    let clock: UrksWidgetMediumClockModel
    let palette: UrksWidgetRenderPalette
    let handMetrics: UrksSharedHandMetrics
    let options: UrksSharedWidgetOptions
    let clockSize: CGFloat
    let reservedLabelHeight: CGFloat

    var body: some View {
        VStack(spacing: 4) {
            Spacer(minLength: 0)

            UrksWidgetDialView(
                snapshot: clock.snapshot,
                palette: palette,
                handMetrics: handMetrics,
                displayMode: options.displayMode,
                showDigits: options.showDigits,
                showTicks: options.showTicks
            )
            .frame(width: clockSize, height: clockSize)

            Text(clock.cityName)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.65)
                .frame(maxWidth: .infinity, minHeight: reservedLabelHeight, maxHeight: reservedLabelHeight, alignment: .top)

            Spacer(minLength: 0)
        }
    }
}

struct UrksWidgetAddClockPlaceholderColumn: View {
    let palette: UrksWidgetRenderPalette
    let clockSize: CGFloat
    let reservedLabelHeight: CGFloat

    var body: some View {
        Link(destination: UrksDeepLink.configureSecondClockURL ?? URL(string: "urks://widget/configure-second-clock")!) {
            VStack(spacing: 4) {
                Spacer(minLength: 0)

                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: palette.dialGradient,
                                center: .center,
                                startRadius: 4,
                                endRadius: clockSize * 0.54
                            )
                        )

                    Circle()
                        .strokeBorder(palette.ringColor, lineWidth: clockSize * 0.018)

                    RoundedRectangle(cornerRadius: clockSize * 0.02, style: .continuous)
                        .fill(palette.tickColor)
                        .frame(width: clockSize * 0.12, height: clockSize * 0.42)

                    RoundedRectangle(cornerRadius: clockSize * 0.02, style: .continuous)
                        .fill(palette.tickColor)
                        .frame(width: clockSize * 0.42, height: clockSize * 0.12)
                }
                .frame(width: clockSize, height: clockSize)

                Text(
                    verbatim: localizedWidgetString(
                        "widget.addClock",
                        fallbackGerman: "Hinzufügen",
                        fallbackEnglish: "Add"
                    )
                )
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.65)
                .frame(maxWidth: .infinity, minHeight: reservedLabelHeight, maxHeight: reservedLabelHeight, alignment: .top)

                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct UrksWidgetMediumClockModel: Identifiable {
    let id: String
    let cityName: String
    let snapshot: UrksSharedSnapshot
}

struct UrksWidgetDialView: View {
    let snapshot: UrksSharedSnapshot
    let palette: UrksWidgetRenderPalette
    let handMetrics: UrksSharedHandMetrics
    let displayMode: UrksSharedDisplayMode
    let showDigits: Bool
    let showTicks: Bool

    private var hands: [UrksWidgetRenderHandSpec] {
        var baseHands: [UrksWidgetRenderHandSpec] = [
            UrksWidgetRenderHandSpec(
                id: "hourTens",
                slotValue: snapshot.hourTensSlot,
                color: palette.hourTensColor,
                lengthRatio: handMetrics.hourTensLength,
                lineWidthRatio: handMetrics.hourTensWidth
            ),
            UrksWidgetRenderHandSpec(
                id: "hourOnes",
                slotValue: snapshot.hourOnesSlot,
                color: palette.hourOnesColor,
                lengthRatio: handMetrics.hourOnesLength,
                lineWidthRatio: handMetrics.hourOnesWidth
            ),
            UrksWidgetRenderHandSpec(
                id: "minuteTens",
                slotValue: snapshot.minuteTensSlot,
                color: palette.minuteTensColor,
                lengthRatio: handMetrics.minuteTensLength,
                lineWidthRatio: handMetrics.minuteTensWidth
            ),
            UrksWidgetRenderHandSpec(
                id: "minuteOnes",
                slotValue: snapshot.minuteOnesSlot,
                color: palette.minuteOnesColor,
                lengthRatio: handMetrics.minuteOnesLength,
                lineWidthRatio: handMetrics.minuteOnesWidth
            )
        ]

        if displayMode.showsSecondHands {
            baseHands.append(
                UrksWidgetRenderHandSpec(
                    id: "secondTens",
                    slotValue: snapshot.secondTensSlot,
                    color: palette.secondTensColor,
                    lengthRatio: handMetrics.secondTensLength,
                    lineWidthRatio: handMetrics.secondTensWidth
                )
            )
            baseHands.append(
                UrksWidgetRenderHandSpec(
                    id: "secondOnes",
                    slotValue: snapshot.secondOnesSlot,
                    color: palette.secondOnesColor,
                    lengthRatio: handMetrics.secondOnesLength,
                    lineWidthRatio: handMetrics.secondOnesWidth
                )
            )
        }

        return baseHands
    }

    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)

            let dialRadius = size * UrksSharedGeometry.dialRadiusRatio
            let markingOuterRadius = size * 0.425
            let digitFontSize = size * 0.09
            let digitOuterInset = digitFontSize * 0.34
            let numberRadius = markingOuterRadius - digitOuterInset

            let centerOuterSize = size * 0.12
            let centerInnerSize = size * 0.055

            ZStack {
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
                    .strokeBorder(palette.ringColor, lineWidth: size * 0.018)

                if showTicks {
                    tickRing(
                        size: size,
                        center: center,
                        tickOuterRadius: markingOuterRadius,
                        tickColor: palette.tickColor
                    )
                }

                if showDigits {
                    ForEach(0..<10, id: \.self) { digit in
                        let point = UrksSharedGeometry.pointOnCircle(
                            center: center,
                            radius: numberRadius,
                            angle: UrksSharedGeometry.slotAngle(for: Double(digit))
                        )

                        Text("\(digit)")
                            .font(.system(size: digitFontSize, weight: .bold, design: .rounded))
                            .foregroundStyle(palette.digitColor)
                            .position(point)
                    }
                }

                ForEach(hands) { hand in
                    let clampedLength = min(
                        max(hand.lengthRatio, 0.05),
                        UrksSharedGeometry.maxHandLengthRatio
                    )

                    let handEnd = UrksSharedGeometry.pointOnCircle(
                        center: center,
                        radius: size * clampedLength,
                        angle: UrksSharedGeometry.slotAngle(for: hand.slotValue)
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
        tickOuterRadius: CGFloat,
        tickColor: Color
    ) -> some View {
        let tickLength = size * 0.050
        let tickInnerRadius = max(0, tickOuterRadius - tickLength)
        let tickLineWidth = size * 0.013

        let zeroHeight = tickLength
        let zeroWidth = tickLength * 0.62
        let zeroAngle = UrksSharedGeometry.slotAngle(for: 0.0)

        let zeroCenter = UrksSharedGeometry.pointOnCircle(
            center: center,
            radius: tickOuterRadius - (zeroHeight / 2),
            angle: zeroAngle
        )

        Canvas { context, _ in
            for digit in 1..<10 {
                let angle = UrksSharedGeometry.slotAngle(for: Double(digit))
                let outer = UrksSharedGeometry.pointOnCircle(center: center, radius: tickOuterRadius, angle: angle)
                let inner = UrksSharedGeometry.pointOnCircle(center: center, radius: tickInnerRadius, angle: angle)

                var tickPath = Path()
                tickPath.move(to: outer)
                tickPath.addLine(to: inner)

                context.stroke(
                    tickPath,
                    with: .color(tickColor),
                    style: StrokeStyle(lineWidth: tickLineWidth, lineCap: .round)
                )
            }

            let zeroRect = CGRect(
                x: zeroCenter.x - zeroWidth / 2,
                y: zeroCenter.y - zeroHeight / 2,
                width: zeroWidth,
                height: zeroHeight
            )

            let zeroPath = Path(roundedRect: zeroRect, cornerRadius: zeroWidth / 2)
            context.stroke(
                zeroPath,
                with: .color(tickColor),
                style: StrokeStyle(lineWidth: tickLineWidth * 0.78, lineCap: .round, lineJoin: .round)
            )
        }
    }
}

struct UrksWidgetRenderHandSpec: Identifiable {
    let id: String
    let slotValue: Double
    let color: Color
    let lengthRatio: CGFloat
    let lineWidthRatio: CGFloat
}

struct UrksWidgetRenderPalette {
    let dialGradient: [Color]
    let ringColor: Color
    let tickColor: Color
    let digitColor: Color
    let centerOuterFill: Color
    let centerInnerFill: Color
    let hourTensColor: Color
    let hourOnesColor: Color
    let minuteTensColor: Color
    let minuteOnesColor: Color
    let secondTensColor: Color
    let secondOnesColor: Color

    static func system(
        colorScheme: ColorScheme,
        handPalette: UrksSharedHandPalette,
        surfacePalette: UrksSharedSurfacePalette
    ) -> UrksWidgetRenderPalette {
        let exactDialColor = surfacePalette.dialBackgroundColor.color

        return UrksWidgetRenderPalette(
            dialGradient: [
                exactDialColor,
                exactDialColor,
                exactDialColor
            ],
            ringColor: surfacePalette.ringColor.color,
            tickColor: surfacePalette.markingColor.color,
            digitColor: surfacePalette.markingColor.color,
            centerOuterFill: surfacePalette.ringColor.color,
            centerInnerFill: exactDialColor,
            hourTensColor: handPalette.hourTensColor.color,
            hourOnesColor: handPalette.hourOnesColor.color,
            minuteTensColor: handPalette.minuteTensColor.color,
            minuteOnesColor: handPalette.minuteOnesColor.color,
            secondTensColor: handPalette.secondTensColor.color,
            secondOnesColor: handPalette.secondOnesColor.color
        )
    }

    static func accessory(
        colorScheme: ColorScheme,
        handPalette: UrksSharedHandPalette,
        surfacePalette: UrksSharedSurfacePalette
    ) -> UrksWidgetRenderPalette {
        system(colorScheme: colorScheme, handPalette: handPalette, surfacePalette: surfacePalette)
    }
}
