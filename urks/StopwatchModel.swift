/* /Users/drebin/Documents/software/urks/urks/StopwatchModel.swift */
import Foundation
import Combine

struct StopwatchLap: Identifiable, Equatable {
    let id = UUID()
    let number: Int
    let splitElapsed: TimeInterval
    let lapDuration: TimeInterval
}

@MainActor
final class StopwatchModel: ObservableObject {
    @Published private(set) var accumulatedElapsed: TimeInterval = 0
    @Published private(set) var startedAt: Date?
    @Published private(set) var laps: [StopwatchLap] = []

    var isRunning: Bool {
        startedAt != nil
    }

    var hasRecordedTime: Bool {
        accumulatedElapsed > 0 || startedAt != nil
    }

    func elapsedTime(at date: Date = Date()) -> TimeInterval {
        guard let startedAt else {
            return accumulatedElapsed
        }

        return accumulatedElapsed + max(0, date.timeIntervalSince(startedAt))
    }

    func startOrResume(at date: Date = Date()) {
        guard !isRunning else {
            return
        }

        startedAt = date
    }

    func pause(at date: Date = Date()) {
        guard let startedAt else {
            return
        }

        accumulatedElapsed += max(0, date.timeIntervalSince(startedAt))
        self.startedAt = nil
    }

    func reset() {
        accumulatedElapsed = 0
        startedAt = nil
        laps = []
    }

    func recordLap(at date: Date = Date()) {
        let totalElapsed = elapsedTime(at: date)

        guard totalElapsed > 0 else {
            return
        }

        let previousSplit = laps.last?.splitElapsed ?? 0
        let nextLap = StopwatchLap(
            number: laps.count + 1,
            splitElapsed: totalElapsed,
            lapDuration: totalElapsed - previousSplit
        )

        laps.append(nextLap)
    }
}
