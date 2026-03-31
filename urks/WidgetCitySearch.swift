/* /Users/drebin/Documents/software/urks/urks/WidgetCitySearch.swift */
import Foundation
import MapKit
import Combine

private func widgetLocalizedString(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
}

struct WidgetCitySearchSuggestion: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let completion: MKLocalSearchCompletion

    var primaryText: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var secondaryText: String {
        subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

@MainActor
final class WidgetCitySearchModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var query = ""
    @Published var suggestions: [WidgetCitySearchSuggestion] = []
    @Published var errorMessage: String?

    private let completer = MKLocalSearchCompleter()

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address]
        completer.pointOfInterestFilter = .excludingAll
    }

    deinit {
        completer.delegate = nil
    }

    func updateQuery(_ value: String) {
        errorMessage = nil
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.count < 2 {
            suggestions = []
            completer.queryFragment = ""
            return
        }

        completer.queryFragment = trimmed
    }

    func setDisplayText(_ value: String) {
        query = value
        suggestions = []
        errorMessage = nil
    }

    func clear() {
        query = ""
        suggestions = []
        errorMessage = nil
        completer.queryFragment = ""
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        var seen = Set<String>()
        var mapped: [WidgetCitySearchSuggestion] = []

        for result in completer.results {
            guard let display = cityDisplay(for: result) else {
                continue
            }

            let identifier = "\(display.cityName.lowercased())|\(display.detail.lowercased())"
            guard !seen.contains(identifier) else {
                continue
            }

            seen.insert(identifier)

            mapped.append(
                WidgetCitySearchSuggestion(
                    id: identifier,
                    title: display.cityName,
                    subtitle: display.detail,
                    completion: result
                )
            )
        }

        suggestions = mapped
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        suggestions = []
        errorMessage = widgetLocalizedString("widget.citySearch.error.searchFailed")
    }

    func selectSuggestion(
        _ suggestion: WidgetCitySearchSuggestion,
        onResolved: @escaping (_ cityName: String, _ timeZoneIdentifier: String) -> Void
    ) {
        errorMessage = nil

        let request = MKLocalSearch.Request(completion: suggestion.completion)
        let search = MKLocalSearch(request: request)

        search.start { [weak self] response, error in
            Task { @MainActor in
                guard let self else { return }

                if error != nil {
                    self.errorMessage = widgetLocalizedString("widget.citySearch.error.resolveFailed")
                    return
                }

                guard let response else {
                    self.errorMessage = widgetLocalizedString("widget.citySearch.error.noPlaceFound")
                    return
                }

                let resolvedItem = response.mapItems.first { $0.timeZone != nil } ?? response.mapItems.first
                guard let mapItem = resolvedItem else {
                    self.errorMessage = widgetLocalizedString("widget.citySearch.error.noMatchingPlaceFound")
                    return
                }

                guard let timeZone = mapItem.timeZone else {
                    self.errorMessage = widgetLocalizedString("widget.citySearch.error.noTimeZoneFound")
                    return
                }

                let cityName = self.bestCityName(
                    from: mapItem,
                    fallbackTitle: suggestion.title
                )

                self.query = cityName
                self.suggestions = []
                self.errorMessage = nil

                onResolved(cityName, timeZone.identifier)
            }
        }
    }

    private func bestCityName(from mapItem: MKMapItem, fallbackTitle: String) -> String {
        if #available(iOS 26.0, *) {
            if
                let cityWithContext = mapItem.addressRepresentations?.cityWithContext(.automatic)?
                    .trimmingCharacters(in: .whitespacesAndNewlines),
                !cityWithContext.isEmpty
            {
                return cityWithContext
            }

            if
                let shortAddress = mapItem.address?.shortAddress?
                    .trimmingCharacters(in: .whitespacesAndNewlines),
                !shortAddress.isEmpty
            {
                return shortAddress
            }
        }

        if let name = mapItem.name?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
            return name
        }

        return fallbackTitle
    }

    private func cityDisplay(for result: MKLocalSearchCompletion) -> (cityName: String, detail: String)? {
        let title = normalizedText(result.title)
        let subtitle = normalizedText(result.subtitle)

        if let cityFromTitle = preferredCityComponent(from: title) {
            let detail = cleanedDetailText(from: subtitle, removing: cityFromTitle)
            return (cityFromTitle, detail)
        }

        if let cityFromSubtitle = preferredCityComponent(from: subtitle) {
            let detail = cleanedDetailText(from: subtitle, removing: cityFromSubtitle)
            return (cityFromSubtitle, detail)
        }

        return nil
    }

    private func preferredCityComponent(from value: String) -> String? {
        locationComponents(from: value).first(where: isLikelyCityName)
    }

    private func locationComponents(from value: String) -> [String] {
        let separators = CharacterSet(charactersIn: ",·•")
        return value
            .components(separatedBy: separators)
            .map { normalizedText($0) }
            .filter { !$0.isEmpty }
    }

    private func cleanedDetailText(from subtitle: String, removing cityName: String) -> String {
        let remaining = locationComponents(from: subtitle).filter {
            $0.compare(cityName, options: [.caseInsensitive, .diacriticInsensitive]) != .orderedSame
        }

        return remaining.joined(separator: " · ")
    }

    private func normalizedText(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }

    private func isLikelyCityName(_ value: String) -> Bool {
        let trimmed = normalizedText(value)
        guard trimmed.count >= 2, trimmed.count <= 60 else {
            return false
        }

        if trimmed.rangeOfCharacter(from: .decimalDigits) != nil {
            return false
        }

        let lowercased = trimmed.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)

        let blockedFragments = [
            "straße", "strasse", "street", "st.", "road", "rd.", "avenue", "ave",
            "boulevard", "blvd", "lane", "ln.", "drive", "dr.", "way", "platz",
            "square", "gasse", "allee", "weg", "ufer", "chaussee", "highway",
            "station", "bahnhof", "airport", "terminal", "hotel", "museum",
            "restaurant", "cafe", "café", "park", "center", "centre", "mall",
            "hospital", "clinic", "school", "university", "building", "tower",
            "office", "pier", "harbor", "harbour", "port"
        ]

        if blockedFragments.contains(where: { lowercased.contains($0) }) {
            return false
        }

        let invalidCharacters = CharacterSet(charactersIn: "@#/\\")
        if trimmed.rangeOfCharacter(from: invalidCharacters) != nil {
            return false
        }

        return true
    }
}

func widgetDefaultCityName(for identifier: String) -> String {
    if identifier == "UTC" || identifier == "GMT" {
        return "UTC"
    }

    let parts = identifier.split(separator: "/")
    if let last = parts.last, !last.isEmpty {
        return last.replacingOccurrences(of: "_", with: " ")
    }

    return widgetLocalizedString("city.default.local")
}
