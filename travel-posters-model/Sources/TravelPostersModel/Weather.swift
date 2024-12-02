import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A JSON response from the open-meteo.com weather service
///
/// See https://github.com/open-meteo/sdk.git for a more complete SDK
public struct Weather : Hashable, Codable {
    public let latitude: Double // e.g.: 42.36515
    public let longitude: Double // e.g.: -71.0618
    public let time: Double // e.g.: 0.6880760192871094
    public let offset: Double // e.g.: 0
    public let timezone: String // e.g.: "GMT"
    public let tz: String // e.g.: "GMT"
    public let elevation: Double // e.g.: 8.0
    public let conditions: WeatherConditions

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case time = "generationtime_ms"
        case offset = "utc_offset_seconds"
        case timezone = "timezone"
        case tz = "timezone_abbreviation"
        case elevation = "elevation"
        case conditions = "current_weather"
    }

    /// Fetches the weather from the open-meteo API
    public static func fetch(latitude: Double, longitude: Double) async throws -> Weather {
        let factor = pow(10.0, 4.0) // API expects a lat/lon rounded to 4 places
        let lat = Double(round(latitude * factor)) / factor
        let lon = Double(round(longitude * factor)) / factor
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true")!

        var request = URLRequest(url: url)
        request.setValue("skipapp-bookings", forHTTPHeaderField: "User-Agent")

        logger.info("fetching weather endpoint: \(url.absoluteString)")
        let (data, response) = try await URLSession.shared.data(for: request)
        logger.info("received response: \(response)")
        return try JSONDecoder().decode(Weather.self, from: data)
    }
}

public struct WeatherConditions : Hashable, Codable {
    public let temperature: Double // 16.2
    public let windspeed: Double // 16.6
    public let winddirection: Double // 314
    public let weathercode: Int // 1
    public let is_day: Int // 1
    public let time: String // "2023-07-30T12:00"
}
