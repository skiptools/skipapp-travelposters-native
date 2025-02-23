import XCTest
import Foundation
import OSLog
import SkipBridge
@testable import TravelPostersModel

let logger: Logger = Logger(subsystem: "TravelPostersModel", category: "Tests")

@available(macOS 13, *)
final class TravelPostersModelTests: XCTestCase {
    override func setUp() {
        #if SKIP
        loadPeerLibrary(packageName: "travel-posters-model", moduleName: "TravelPostersModel")
        #endif
    }

    func testTravelPostersModel() throws {
        logger.log("running testTravelPostersModel")
        let allCities = CityManager.shared.allCities
        let cities: [City]
        #if SKIP
        // need to wrap in an Array because kotlincompat mode exposes it as a Kotlin List
        let citiesList: kotlin.collections.List<travel.posters.model.City> = allCities
        cities = skip.lib.Array(citiesList)
        #else
        cities = allCities
        #endif
        XCTAssertEqual(28, cities.count)
        XCTAssertEqual("Amsterdam", cities.first?.name)
    }
}
