/* /Users/drebin/Documents/software/urks/urks/StopwatchView.swift */
import SwiftUI

private struct StopwatchDialSnapshot {
    let elapsed: TimeInterval

    let totalHours: Int
    let totalMinutes: Int
    let totalSeconds: Int
    let totalHundredths: Int

    let displayMinuteTensDigit: Int
    let displayMinuteOnesDigit: Int
    let displaySecondTensDigit: Int
    let displaySecondOnesDigit: Int
    let displayHundredthTensDigit: Int
    let displayHundredthOnesDigit: Int

    let minuteTensSlot: Double
    let minuteOnesSlot: Double
    let secondTensSlot: Double
    let secondOnesSlot: Double
    let hundredthTensSlot: Double
    let hundredthOnesSlot: Double

    init(
        elapsed: TimeInterval,
        settings: ClockSettings,
        forceIntegerDisplay: Bool = false,
        forceDiscreteOnes: Bool = false
    ) {
        let clamped = max(0, elapsed)
        let flooredHundredths = Int((clamped * 100.0).rounded(.down))

        let hours = flooredHundredths / 360000
        let minutes = (flooredHundredths / 6000) % 60
        let seconds = (flooredHundredths / 100) % 60
        let hundredths = flooredHundredths % 100

        totalHours = hours
        totalMinutes = minutes
        totalSeconds = seconds
        totalHundredths = hundredths
        self.elapsed = clamped

        let faceMinutes = (flooredHundredths / 6000) % 100

        displayMinuteTensDigit = (faceMinutes / 10) % 10
        displayMinuteOnesDigit = faceMinutes % 10
        displaySecondTensDigit = seconds / 10
        displaySecondOnesDigit = seconds % 10
        displayHundredthTensDigit = hundredths / 10
        displayHundredthOnesDigit = hundredths % 10

        let preciseMinutes = clamped / 60.0
        let preciseSeconds = clamped
        let preciseHundredths = clamped * 100.0

        let shouldRenderIntegerOnly = forceIntegerDisplay || settings.integerOnly
        let allowContinuousMinuteOnes = !forceDiscreteOnes && settings.continuousMinuteOnesInIntegerMode
        let allowContinuousSecondOnes = !forceDiscreteOnes && settings.continuousSecondOnesInIntegerMode

        if shouldRenderIntegerOnly {
            minuteTensSlot = Double(displayMinuteTensDigit)
            minuteOnesSlot = allowContinuousMinuteOnes
                ? preciseMinutes
                : Double(displayMinuteOnesDigit)

            secondTensSlot = Double(displaySecondTensDigit)
            secondOnesSlot = allowContinuousSecondOnes
                ? preciseSeconds
                : Double(displaySecondOnesDigit)

            hundredthTensSlot = Double(displayHundredthTensDigit)
            hundredthOnesSlot = Double(displayHundredthOnesDigit)
        } else {
            minuteTensSlot = preciseMinutes / 10.0
            minuteOnesSlot = preciseMinutes
            secondTensSlot = preciseSeconds / 10.0
            secondOnesSlot = preciseSeconds
            hundredthTensSlot = preciseHundredths / 10.0
            hundredthOnesSlot = preciseHundredths
        }
    }

    var primaryText: String {
        if totalHours > 0 {
            return String(
                format: "%02d:%02d:%02d.%02d",
                totalHours,
                totalMinutes,
                totalSeconds,
                totalHundredths
            )
        }

        let faceMinutes = ((Int((elapsed * 100.0).rounded(.down)) / 6000) % 100)
        return String(
            format: "%02d:%02d.%02d",
            faceMinutes,
            totalSeconds,
            totalHundredths
        )
    }
}

private struct StopwatchDialHandSpec: Identifiable {
    let id: String
    let slotValue: Double
    let color: Color
    let lengthRatio: CGFloat
    let lineWidthRatio: CGFloat
}

private struct StopwatchLayoutMetrics {
    let isLandscape: Bool
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let sectionSpacing: CGFloat
    let columnSpacing: CGFloat
    let leftColumnWidth: CGFloat
    let rightColumnWidth: CGFloat
    let dialSize: CGFloat

    init(size: CGSize, dialInset: CGFloat) {
        let resolvedIsLandscape = size.width > size.height
        let resolvedHorizontalPadding: CGFloat = resolvedIsLandscape ? 24 : 20
        let resolvedVerticalPadding: CGFloat = resolvedIsLandscape ? 20 : 24
        let resolvedSectionSpacing: CGFloat = resolvedIsLandscape ? 14 : 18
        let resolvedColumnSpacing: CGFloat = 18

        let usableWidth = max(0, size.width - (resolvedHorizontalPadding * 2))
        let usableHeight = max(0, size.height - (resolvedVerticalPadding * 2))

        isLandscape = resolvedIsLandscape
        horizontalPadding = resolvedHorizontalPadding
        verticalPadding = resolvedVerticalPadding
        sectionSpacing = resolvedSectionSpacing
        columnSpacing = resolvedColumnSpacing

        if resolvedIsLandscape {
            let proposedLeftWidth = usableWidth * 0.45
            let minLeftWidth = min(usableWidth, 320)
            let maxLeftWidth = min(usableWidth, 500)
            let resolvedLeftWidth = min(max(proposedLeftWidth, minLeftWidth), maxLeftWidth)
            let resolvedRightWidth = max(260, usableWidth - resolvedLeftWidth - resolvedColumnSpacing)

            leftColumnWidth = resolvedLeftWidth
            rightColumnWidth = resolvedRightWidth

            let insetAllowance = max(0, dialInset * 2)
            let maxDialWidth = max(210, resolvedLeftWidth - insetAllowance)
            let maxDialHeight = max(210, usableHeight * 0.38)
            dialSize = min(maxDialWidth, maxDialHeight)
        } else {
            leftColumnWidth = usableWidth
            rightColumnWidth = usableWidth

            let insetAllowance = max(0, dialInset * 2)
            let maxDialWidth = max(220, usableWidth - insetAllowance)
            dialSize = min(maxDialWidth, 560)
        }
    }
}

private struct UrksStopwatchDialFace: View {
    let snapshot: StopwatchDialSnapshot
    let settings: ClockSettings
    var isCompact: Bool = false
    var showsHundredthHands: Bool = true

    private var hands: [StopwatchDialHandSpec] {
        let visibleKinds = settings.displayMode.visibleHandKinds.filter { kind in
            if showsHundredthHands {
                return true
            }

            switch kind {
            case .secondTens, .secondOnes:
                return false
            default:
                return true
            }
        }

        return visibleKinds.map { handSpec(for: $0) }
    }

    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
            let dialRadius = size * ClockGeometry.dialRadiusRatio

            let markingOuterRadius = size * 0.425
            let digitFontSize = size * (isCompact ? 0.075 : 0.09)
            let digitOuterInset = digitFontSize * 0.34
            let numberRadius = markingOuterRadius - digitOuterInset

            let centerOuterSize = size * (isCompact ? 0.105 : 0.12) * settings.centerDotScale
            let centerInnerSize = size * (isCompact ? 0.048 : 0.055) * settings.centerDotScale
            let palette = settings.resolvedPalette

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
                    .strokeBorder(palette.ringColor, lineWidth: size * (isCompact ? 0.016 : 0.018))

                if settings.showTicks || isCompact {
                    tickRing(
                        size: size,
                        center: center,
                        tickOuterRadius: markingOuterRadius,
                        tickColor: palette.markingColor
                    )
                }

                if settings.showDigits && !isCompact {
                    ForEach(0..<10, id: \.self) { digit in
                        let point = pointOnCircle(
                            center: center,
                            radius: numberRadius,
                            angle: slotAngle(for: Double(digit))
                        )

                        Text("\(digit)")
                            .font(.system(size: digitFontSize, weight: .bold, design: .rounded))
                            .foregroundStyle(palette.markingColor)
                            .position(point)
                    }
                }

                ForEach(hands) { hand in
                    let clampedLength = min(
                        max(hand.lengthRatio, 0.05),
                        CGFloat(ClockGeometry.maxHandLengthRatio)
                    )

                    let handEnd = pointOnCircle(
                        center: center,
                        radius: size * clampedLength,
                        angle: slotAngle(for: hand.slotValue)
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
                    .shadow(radius: isCompact ? 1 : 2)
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

    private func handSpec(for kind: ClockHandKind) -> StopwatchDialHandSpec {
        let adjustment = settings.handCustomization.adjustment(for: kind)

        return StopwatchDialHandSpec(
            id: kind.rawValue,
            slotValue: slotValue(for: kind),
            color: adjustment.color.color,
            lengthRatio: CGFloat(adjustment.length),
            lineWidthRatio: CGFloat(adjustment.width)
        )
    }

    private func slotValue(for kind: ClockHandKind) -> Double {
        switch kind {
        case .hourTens:
            return snapshot.minuteTensSlot
        case .hourOnes:
            return snapshot.minuteOnesSlot
        case .minuteTens:
            return snapshot.secondTensSlot
        case .minuteOnes:
            return snapshot.secondOnesSlot
        case .secondTens:
            return snapshot.hundredthTensSlot
        case .secondOnes:
            return snapshot.hundredthOnesSlot
        }
    }

    @ViewBuilder
    private func tickRing(
        size: CGFloat,
        center: CGPoint,
        tickOuterRadius: CGFloat,
        tickColor: Color
    ) -> some View {
        let tickLength = size * (isCompact ? 0.040 : 0.050)
        let tickInnerRadius = max(0, tickOuterRadius - tickLength)
        let tickLineWidth = size * (isCompact ? 0.010 : 0.013)

        let zeroHeight = tickLength
        let zeroWidth = tickLength * 0.62
        let zeroAngle = slotAngle(for: 0.0)

        let zeroCenter = pointOnCircle(
            center: center,
            radius: tickOuterRadius - (zeroHeight / 2),
            angle: zeroAngle
        )

        Canvas { context, _ in
            for digit in 1..<10 {
                let angle = slotAngle(for: Double(digit))
                let outer = pointOnCircle(center: center, radius: tickOuterRadius, angle: angle)
                let inner = pointOnCircle(center: center, radius: tickInnerRadius, angle: angle)

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

private struct StopwatchLapRow: View {
    let lap: StopwatchLap
    let settings: ClockSettings

    private var snapshot: StopwatchDialSnapshot {
        StopwatchDialSnapshot(
            elapsed: lap.lapDuration,
            settings: settings,
            forceIntegerDisplay: true,
            forceDiscreteOnes: true
        )
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            UrksStopwatchDialFace(
                snapshot: snapshot,
                settings: settings,
                isCompact: true,
                showsHundredthHands: true
            )
            .frame(width: 72, height: 72)

            VStack(alignment: .leading, spacing: 4) {
                Text(StopwatchText.lapNumber(lap.number))
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))

                Text(snapshot.primaryText)
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .monospacedDigit()

                Text("\(StopwatchText.split): \(formattedElapsedTime(lap.splitElapsed))")
                    .font(.system(.footnote, design: .rounded))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            Spacer()
        }
        .padding(.vertical, 10)
    }

    private func formattedElapsedTime(_ elapsed: TimeInterval) -> String {
        let clamped = max(0, elapsed)
        let totalHundredths = Int((clamped * 100).rounded(.down))
        let hundredths = totalHundredths % 100
        let totalSeconds = totalHundredths / 100
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        return String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, hundredths)
    }
}

struct StopwatchView: View {
    @ObservedObject var model: StopwatchModel
    let settings: ClockSettings

    private var palette: ClockPalette {
        settings.resolvedPalette
    }

    private var showsHundredthHandsInMainDial: Bool {
        settings.displayMode == .sixHands && !model.isRunning && model.hasRecordedTime
    }

    private var showsHundredthsLegendInMainReadout: Bool {
        showsHundredthHandsInMainDial
    }

    var body: some View {
        TimelineView(PeriodicTimelineSchedule(from: .now, by: 1.0 / 30.0)) { context in
            let elapsed = model.elapsedTime(at: context.date)
            let snapshot = StopwatchDialSnapshot(elapsed: elapsed, settings: settings)

            GeometryReader { proxy in
                let metrics = StopwatchLayoutMetrics(
                    size: proxy.size,
                    dialInset: CGFloat(settings.dialInset)
                )

                if metrics.isLandscape {
                    landscapeRoot(
                        size: proxy.size,
                        referenceDate: context.date,
                        snapshot: snapshot,
                        metrics: metrics
                    )
                } else {
                    portraitRoot(
                        referenceDate: context.date,
                        snapshot: snapshot,
                        metrics: metrics
                    )
                }
            }
        }
    }

    @ViewBuilder
    private func portraitRoot(
        referenceDate: Date,
        snapshot: StopwatchDialSnapshot,
        metrics: StopwatchLayoutMetrics
    ) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: metrics.sectionSpacing) {
                headerCard
                dialSection(snapshot: snapshot, dialSize: metrics.dialSize)
                readoutCard(snapshot: snapshot)
                controlsCard(referenceDate: referenceDate, snapshot: snapshot)
                lapsCardScrollable
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.horizontal, metrics.horizontalPadding)
            .padding(.vertical, metrics.verticalPadding)
        }
    }

    @ViewBuilder
    private func landscapeRoot(
        size: CGSize,
        referenceDate: Date,
        snapshot: StopwatchDialSnapshot,
        metrics: StopwatchLayoutMetrics
    ) -> some View {
        let estimatedHeaderHeight: CGFloat = 88
        let availableColumnHeight = max(
            220,
            size.height - (metrics.verticalPadding * 2) - estimatedHeaderHeight - metrics.sectionSpacing
        )

        VStack(spacing: metrics.sectionSpacing) {
            headerCard

            HStack(alignment: .top, spacing: metrics.columnSpacing) {
                VStack(spacing: metrics.sectionSpacing) {
                    dialSection(snapshot: snapshot, dialSize: metrics.dialSize)
                    readoutCard(snapshot: snapshot)
                    controlsCard(referenceDate: referenceDate, snapshot: snapshot)
                }
                .frame(width: metrics.leftColumnWidth, alignment: .top)

                lapsCardScrollable
                    .frame(width: metrics.rightColumnWidth, height: availableColumnHeight, alignment: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .padding(.horizontal, metrics.horizontalPadding)
        .padding(.vertical, metrics.verticalPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    @ViewBuilder
    private func dialSection(
        snapshot: StopwatchDialSnapshot,
        dialSize: CGFloat
    ) -> some View {
        UrksStopwatchDialFace(
            snapshot: snapshot,
            settings: settings,
            showsHundredthHands: showsHundredthHandsInMainDial
        )
        .padding(settings.dialInset)
        .frame(width: dialSize, height: dialSize)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var headerCard: some View {
        stopwatchCard {
            HStack(alignment: .center, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(StopwatchText.title)
                        .font(.system(.title3, design: .rounded, weight: .bold))

                    Text(StopwatchText.subtitle)
                        .font(.system(.footnote, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 12)

                Text(statusText)
                    .font(.system(.footnote, design: .rounded, weight: .semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule(style: .continuous)
                            .fill(palette.controlTint.opacity(0.12))
                    )
                    .foregroundStyle(palette.controlTint)
            }
        }
    }

    @ViewBuilder
    private func readoutCard(snapshot: StopwatchDialSnapshot) -> some View {
        stopwatchCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(snapshot.primaryText)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .minimumScaleFactor(0.55)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .top, spacing: 10) {
                        legendItem(
                            title: StopwatchText.minutesLegend,
                            firstColor: settings.handCustomization.hourTensColor.color,
                            secondColor: settings.handCustomization.hourOnesColor.color
                        )

                        legendItem(
                            title: StopwatchText.secondsLegend,
                            firstColor: settings.handCustomization.minuteTensColor.color,
                            secondColor: settings.handCustomization.minuteOnesColor.color
                        )

                        if showsHundredthsLegendInMainReadout {
                            legendItem(
                                title: StopwatchText.hundredthsLegend,
                                firstColor: settings.handCustomization.secondTensColor.color,
                                secondColor: settings.handCustomization.secondOnesColor.color
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        legendItem(
                            title: StopwatchText.minutesLegend,
                            firstColor: settings.handCustomization.hourTensColor.color,
                            secondColor: settings.handCustomization.hourOnesColor.color
                        )

                        legendItem(
                            title: StopwatchText.secondsLegend,
                            firstColor: settings.handCustomization.minuteTensColor.color,
                            secondColor: settings.handCustomization.minuteOnesColor.color
                        )

                        if showsHundredthsLegendInMainReadout {
                            legendItem(
                                title: StopwatchText.hundredthsLegend,
                                firstColor: settings.handCustomization.secondTensColor.color,
                                secondColor: settings.handCustomization.secondOnesColor.color
                            )
                        }
                    }
                }

                if let lastLap = model.laps.last {
                    HStack {
                        Text(StopwatchText.lastLap)
                            .font(.system(.footnote, design: .rounded))
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(formattedElapsedTime(lastLap.lapDuration))
                            .font(.system(.footnote, design: .rounded, weight: .semibold))
                            .monospacedDigit()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func controlsCard(referenceDate: Date, snapshot: StopwatchDialSnapshot) -> some View {
        stopwatchCard {
            HStack(spacing: 12) {
                controlButton(
                    title: model.isRunning ? StopwatchText.lap : StopwatchText.reset,
                    isProminent: false,
                    isDisabled: !model.isRunning && !model.hasRecordedTime
                ) {
                    if model.isRunning {
                        model.recordLap(at: referenceDate)
                    } else {
                        model.reset()
                    }
                }

                controlButton(
                    title: primaryActionTitle,
                    isProminent: true,
                    isDisabled: false
                ) {
                    if model.isRunning {
                        model.pause(at: referenceDate)
                    } else {
                        model.startOrResume(at: referenceDate)
                    }
                }
            }

            if snapshot.elapsed > 0 {
                HStack {
                    Text(StopwatchText.split)
                        .font(.system(.footnote, design: .rounded))
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(formattedElapsedTime(snapshot.elapsed))
                        .font(.system(.footnote, design: .rounded, weight: .semibold))
                        .monospacedDigit()
                }
                .padding(.top, 2)
            }
        }
    }

    @ViewBuilder
    private var lapsCardScrollable: some View {
        stopwatchCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(StopwatchText.laps)
                    .font(.system(.headline, design: .rounded))

                if model.laps.isEmpty {
                    Text(StopwatchText.noLaps)
                        .font(.system(.footnote, design: .rounded))
                        .foregroundStyle(.secondary)

                    Spacer(minLength: 0)
                } else {
                    ScrollView(showsIndicators: true) {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(model.laps.reversed())) { lap in
                                StopwatchLapRow(
                                    lap: lap,
                                    settings: settings
                                )

                                if lap.id != model.laps.first?.id {
                                    Divider()
                                }
                            }
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    @ViewBuilder
    private func legendItem(
        title: String,
        firstColor: Color,
        secondColor: Color
    ) -> some View {
        HStack(spacing: 6) {
            HStack(spacing: 4) {
                Circle()
                    .fill(firstColor)
                    .frame(width: 8, height: 8)

                Circle()
                    .fill(secondColor)
                    .frame(width: 8, height: 8)
            }

            Text(title)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var statusText: String {
        if model.isRunning {
            return StopwatchText.running
        }

        if model.hasRecordedTime {
            return StopwatchText.paused
        }

        return StopwatchText.ready
    }

    private var primaryActionTitle: String {
        if model.isRunning {
            return StopwatchText.pause
        }

        if model.hasRecordedTime {
            return StopwatchText.resume
        }

        return StopwatchText.start
    }

    @ViewBuilder
    private func controlButton(
        title: String,
        isProminent: Bool,
        isDisabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isProminent ? palette.controlTint : palette.sectionBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(isProminent ? palette.controlTint : palette.sectionStroke, lineWidth: 1)
                )
                .foregroundStyle(isProminent ? Color.white : Color.primary)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.45 : 1.0)
    }

    @ViewBuilder
    private func stopwatchCard<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(palette.sectionBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(palette.sectionStroke, lineWidth: 1)
        )
    }

    private func formattedElapsedTime(_ elapsed: TimeInterval) -> String {
        let clamped = max(0, elapsed)
        let totalHundredths = Int((clamped * 100).rounded(.down))
        let hundredths = totalHundredths % 100
        let totalSeconds = totalHundredths / 100
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        return String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, hundredths)
    }
}
