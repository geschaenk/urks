/* /Users/drebin/Documents/software/urks/urks/ClockRendering.swift */
import SwiftUI

struct LiveClockFace: View {
    let settings: ClockSettings

    var body: some View {
        TimelineView(PeriodicTimelineSchedule(from: .now, by: 1.0 / 30.0)) { context in
            let snapshot = ClockSnapshot(
                date: context.date,
                integerOnly: settings.integerOnly,
                continuousMinuteOnesInIntegerMode: settings.continuousMinuteOnesInIntegerMode,
                continuousSecondOnesInIntegerMode: settings.continuousSecondOnesInIntegerMode
            )

            CombinedDialFace(snapshot: snapshot, settings: settings)
        }
    }
}

struct CombinedDialFace: View {
    let snapshot: ClockSnapshot
    let settings: ClockSettings

    private var hands: [HandSpec] {
        settings.displayMode.visibleHandKinds.map { handSpec(for: $0) }
    }

    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
            let dialRadius = size * ClockGeometry.dialRadiusRatio

            let markingOuterRadius = size * 0.425
            let digitFontSize = size * 0.09
            let digitOuterInset = digitFontSize * 0.34
            let numberRadius = markingOuterRadius - digitOuterInset

            let centerOuterSize = size * 0.12 * settings.centerDotScale
            let centerInnerSize = size * 0.055 * settings.centerDotScale
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
                    .strokeBorder(palette.ringColor, lineWidth: size * 0.018)

                if settings.showTicks {
                    tickRing(
                        size: size,
                        center: center,
                        tickOuterRadius: markingOuterRadius,
                        tickColor: palette.markingColor
                    )
                }

                if settings.showDigits {
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
                        ClockGeometry.maxHandLengthRatio
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

    private func handSpec(for kind: ClockHandKind) -> HandSpec {
        let adjustment = settings.handCustomization.adjustment(for: kind)

        return HandSpec(
            id: kind.rawValue,
            slotValue: slotValue(for: kind),
            color: adjustment.color.color,
            lengthRatio: adjustment.length,
            lineWidthRatio: adjustment.width
        )
    }

    private func slotValue(for kind: ClockHandKind) -> Double {
        switch kind {
        case .hourTens:
            return snapshot.hourTensSlot
        case .hourOnes:
            return snapshot.hourOnesSlot
        case .minuteTens:
            return snapshot.minuteTensSlot
        case .minuteOnes:
            return snapshot.minuteOnesSlot
        case .secondTens:
            return snapshot.secondTensSlot
        case .secondOnes:
            return snapshot.secondOnesSlot
        }
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
