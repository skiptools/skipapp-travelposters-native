import Foundation
import Observation
import SkipFuse

/// A manager for loading the cities list and handling user favorites
@Observable public final class CityManager {
    /// The JSON containing the user-selected list of favorite city IDs
    private static let favoritesURL = URL.applicationSupportDirectory.appendingPathComponent("favorites.json")

    /// The app-wide singleton `CityManager`
    public static let shared = CityManager()

    private init() {
        do {
            // load cities from Cities.json bundled with the app
            self.allCities = try JSONDecoder().decode([City].self, from: localCitiesJSON.data(using: .utf8)!).sorted { c1, c2 in
                c1.name < c2.name
            }
            logger.log("loaded cities: \(self.allCities.count)")
        } catch {
            logger.log("error loading cities: \(error)")
        }
        do {
            logger.log("favoritesURL: \(Self.favoritesURL)")
            // load favorites from favorites.json in the user's app documents folder
            self.favoriteIDs = try JSONDecoder().decode(Array<City.ID>.self, from: Data(contentsOf: Self.favoritesURL))
            logger.log("loaded favorites: \(self.favoriteIDs)")
        } catch {
            logger.log("error loading favorites: \(error)")
        }
    }

    /// All the cities in the list
    public var allCities: [City] = []

    /// The ordered list of favorites specified by the user; changed will be persisted to the JSON file
    public var favoriteIDs: Array<City.ID> = [] {
        didSet {
            logger.log("saving favorites: \(self.favoriteIDs)")
            do {
                try FileManager.default.createDirectory(at: Self.favoritesURL.deletingLastPathComponent(), withIntermediateDirectories: true)
                try JSONEncoder().encode(favoriteIDs).write(to: Self.favoritesURL)
            } catch {
                logger.log("error saving favorites: \(error)")
            }
        }
    }
}

private let localCitiesJSON = """
[
    { "id": 1, "name": "Paris", "tagline": "The City of Lights", "population": "2.2 million", "nicestMonth": "July", "country": "France", "latitude": 48.8566, "longitude": 2.3522, "imageURL": "https://images.pexels.com/photos/2363/france-landmark-lights-night.jpg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Paris" },
    { "id": 2, "name": "Tokyo", "tagline": "The Land of the Rising Sun", "population": "9.3 million", "nicestMonth": "May", "country": "Japan", "latitude": 35.6895, "longitude": 139.6917, "imageURL": "https://images.pexels.com/photos/2614818/pexels-photo-2614818.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Tokyo" },
    { "id": 3, "name": "New York", "tagline": "The City That Never Sleeps", "population": "8.4 million", "nicestMonth": "July", "country": "USA", "latitude": 40.7128, "longitude": -74.0060, "imageURL": "https://images.pexels.com/photos/1239162/pexels-photo-1239162.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/New_York_City" },
    { "id": 4, "name": "London", "tagline": "The Capital of Culture", "population": "9.1 million", "nicestMonth": "July", "country": "UK", "latitude": 51.5074, "longitude": -0.1278, "imageURL": "https://images.pexels.com/photos/427679/pexels-photo-427679.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/London" },
    { "id": 5, "name": "Rome", "tagline": "The Eternal City", "population": "2.7 million", "nicestMonth": "July", "country": "Italy", "latitude": 41.9028, "longitude": 12.4964, "imageURL": "https://images.pexels.com/photos/1797161/pexels-photo-1797161.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Rome" },
    { "id": 6, "name": "Barcelona", "tagline": "The City of Gaudí", "population": "1.6 million", "nicestMonth": "July", "country": "Spain", "latitude": 41.3851, "longitude": 2.1734, "imageURL": "https://images.pexels.com/photos/1388030/pexels-photo-1388030.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Barcelona" },
    { "id": 7, "name": "Sydney", "tagline": "The Harbour City", "population": "5.3 million", "nicestMonth": "December", "country": "Australia", "latitude": -33.8688, "longitude": 151.2093, "imageURL": "https://images.pexels.com/photos/1619854/pexels-photo-1619854.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Sydney" },
    { "id": 8, "name": "Moscow", "tagline": "The Capital of Russia", "population": "12.6 million", "nicestMonth": "July", "country": "Russia", "latitude": 55.7512, "longitude": 37.6184, "imageURL": "https://images.pexels.com/photos/92412/pexels-photo-92412.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Moscow" },
    { "id": 9, "name": "Cape Town", "tagline": "The Mother City", "population": "3.9 million", "nicestMonth": "December", "country": "South Africa", "latitude": -33.9249, "longitude": 18.4241, "imageURL": "https://images.pexels.com/photos/259447/pexels-photo-259447.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Cape_Town" },
    { "id": 10, "name": "Bangkok", "tagline": "The City of Angels", "population": "8.7 million", "nicestMonth": "February", "country": "Thailand", "latitude": 13.7563, "longitude": 100.5018, "imageURL": "https://images.pexels.com/photos/17746130/pexels-photo-17746130.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Bangkok" },
    { "id": 11, "name": "Toronto", "tagline": "The Good City", "population": "2.7 million", "nicestMonth": "July", "country": "Canada", "latitude": 43.6532, "longitude": -79.3832, "imageURL": "https://images.pexels.com/photos/1519088/pexels-photo-1519088.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Toronto" },
    { "id": 12, "name": "Lisbon", "tagline": "The City of Seven Hills", "population": "520,000", "nicestMonth": "July", "country": "Portugal", "latitude": 38.7223, "longitude": -9.1393, "imageURL": "https://images.pexels.com/photos/5069524/pexels-photo-5069524.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Lisbon" },
    { "id": 13, "name": "Dubai", "tagline": "The City of Gold", "population": "8 million", "nicestMonth": "January", "country": "UAE", "latitude": 25.276987, "longitude": 55.296249, "imageURL": "https://images.pexels.com/photos/325193/pexels-photo-325193.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Dubai" },
    { "id": 14, "name": "Singapore", "tagline": "The Lion City", "population": "5.9 million", "nicestMonth": "February", "country": "Singapore", "latitude": 1.3521, "longitude": 103.8198, "imageURL": "https://images.pexels.com/photos/777059/pexels-photo-777059.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Singapore" },
    { "id": 15, "name": "Hong Kong", "tagline": "The Pearl of the Orient", "population": "7.4 million", "nicestMonth": "May", "country": "China", "latitude": 22.2875, "longitude": 114.1588, "imageURL": "https://images.pexels.com/photos/3038813/pexels-photo-3038813.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Hong_Kong" },
    { "id": 16, "name": "Melbourne", "tagline": "The City of Culture", "population": "4.7 million", "nicestMonth": "December", "country": "Australia", "latitude": -37.8136, "longitude": 144.9631, "imageURL": "https://images.pexels.com/photos/18163161/pexels-photo-18163161.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Melbourne" },
    { "id": 17, "name": "Berlin", "tagline": "The City of the Future", "population": "3.7 million", "nicestMonth": "July", "country": "Germany", "latitude": 52.5200, "longitude": 13.4050, "imageURL": "https://images.pexels.com/photos/7555434/pexels-photo-7555434.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Berlin" },
    { "id": 18, "name": "Amsterdam", "tagline": "The Venice of the North", "population": "850,000", "nicestMonth": "July", "country": "Netherlands", "latitude": 52.3731, "longitude": 4.8922, "imageURL": "https://images.pexels.com/photos/1258865/pexels-photo-1258865.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Amsterdam" },
    { "id": 19, "name": "Vancouver", "tagline": "The City of the Mountains", "population": "2.4 million", "nicestMonth": "July", "country": "Canada", "latitude": 49.2827, "longitude": -123.1207, "imageURL": "https://images.pexels.com/photos/2416602/pexels-photo-2416602.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Vancouver" },
    { "id": 20, "name": "Buenos Aires", "tagline": "The Paris of South America", "population": "3.1 million", "nicestMonth": "December", "country": "Argentina", "latitude": -34.6037, "longitude": -58.3816, "imageURL": "https://images.pexels.com/photos/14401404/pexels-photo-14401404.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Buenos_Aires" },
    { "id": 21, "name": "São Paulo", "tagline": "The Heart of Brazil", "population": "12.3 million", "nicestMonth": "February", "country": "Brazil", "latitude": -23.5505, "longitude": -46.6333, "imageURL": "https://images.pexels.com/photos/10914811/pexels-photo-10914811.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/São_Paulo" },
    { "id": 22, "name": "Taipei", "tagline": "The City of the Dragon", "population": "7.3 million", "nicestMonth": "May", "country": "Taiwan", "latitude": 25.0329, "longitude": 121.5654, "imageURL": "https://images.pexels.com/photos/1717859/pexels-photo-1717859.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Taipei" },
    { "id": 23, "name": "Istanbul", "tagline": "The City of a Thousand Minarets", "population": "15.5 million", "nicestMonth": "July", "country": "Turkey", "latitude": 41.0082, "longitude": 28.9784, "imageURL": "https://images.pexels.com/photos/6152260/pexels-photo-6152260.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Istanbul" },
    { "id": 24, "name": "Mexico City", "tagline": "The Heart of Mexico", "population": "21.7 million", "nicestMonth": "February", "country": "Mexico", "latitude": 19.4326, "longitude": -99.1332, "imageURL": "https://images.pexels.com/photos/3720115/pexels-photo-3720115.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Mexico_City" },
    { "id": 25, "name": "Dublin", "tagline": "The Emerald Isle", "population": "1.3 million", "nicestMonth": "July", "country": "Ireland", "latitude": 53.3498, "longitude": -6.2603, "imageURL": "https://images.pexels.com/photos/2416653/pexels-photo-2416653.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Dublin" },
    { "id": 26, "name": "Las Vegas", "tagline": "The Entertainment Capital of the World", "population": "6.5 million", "nicestMonth": "October", "country": "USA", "latitude": 36.1699, "longitude": -115.1398, "imageURL": "https://images.pexels.com/photos/2837909/pexels-photo-2837909.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Las_Vegas" },
    { "id": 27, "name": "Rio de Janeiro", "tagline": "The City of Love", "population": "6.6 million", "nicestMonth": "February", "country": "Brazil", "latitude": -22.9068, "longitude": -43.1729, "imageURL": "https://images.pexels.com/photos/13278962/pexels-photo-13278962.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Rio_de_Janeiro" },
    { "id": 28, "name": "Cairo", "tagline": "Gateway to Ancient Wonders", "population": "20.9 million", "nicestMonth": "January", "country": "Egypt", "latitude": 30.0444, "longitude": 31.2357, "imageURL": "https://images.pexels.com/photos/14085756/pexels-photo-14085756.jpeg?auto=compress&cs=tinysrgb&w=500&dpr=2", "wikipediaURL": "https://wikipedia.org/wiki/Cairo" }
]
"""
