import Foundation

/// A City model
public struct City : Identifiable, Codable {
    public typealias ID = Int

    public let id: ID
    public let name: String
    public let tagline: String
    public let population: String
    public let country: String
    public let latitude: Double
    public let longitude: Double
    public let imageURL: URL
    public let wikipediaURL: URL
}
