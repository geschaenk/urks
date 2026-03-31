/* /Users/drebin/Documents/software/urks/urks/StopwatchText.swift */
import Foundation

enum StopwatchText {
    private static var usesGerman: Bool {
        Locale.current.language.languageCode?.identifier == "de"
    }

    static var title: String {
        usesGerman ? "Stoppuhr" : "Stopwatch"
    }

    static var subtitle: String {
        usesGerman ? "" : ""
    }

    static var ready: String {
        usesGerman ? "Bereit" : "Ready"
    }

    static var running: String {
        usesGerman ? "Läuft" : "Running"
    }

    static var paused: String {
        usesGerman ? "Pausiert" : "Paused"
    }

    static var start: String {
        usesGerman ? "Start" : "Start"
    }

    static var pause: String {
        usesGerman ? "Pause" : "Pause"
    }

    static var resume: String {
        usesGerman ? "Fortsetzen" : "Resume"
    }

    static var reset: String {
        usesGerman ? "Zurücksetzen" : "Reset"
    }

    static var lap: String {
        usesGerman ? "Runde" : "Lap"
    }

    static var laps: String {
        usesGerman ? "Rundenzeiten" : "Lap Times"
    }

    static var split: String {
        usesGerman ? "Gesamt" : "Split"
    }

    static var lastLap: String {
        usesGerman ? "Letzte Runde" : "Last Lap"
    }

    static var noLaps: String {
        usesGerman ? "Noch keine Runden erfasst." : "No laps recorded yet."
    }

    static var minutesLegend: String {
        usesGerman ? "Minuten" : "Minutes"
    }

    static var secondsLegend: String {
        usesGerman ? "Sekunden" : "Seconds"
    }

    static var hundredthsLegend: String {
        usesGerman ? "Hundertstel" : "Hundredths"
    }

    static func lapNumber(_ number: Int) -> String {
        usesGerman ? "Runde \(number)" : "Lap \(number)"
    }
}
