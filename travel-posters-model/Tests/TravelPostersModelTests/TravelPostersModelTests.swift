import XCTest
import Foundation
import OSLog
@testable import TravelPostersModel

let logger: Logger = Logger(subsystem: "TravelPostersModel", category: "Tests")

@available(macOS 13, *)
final class TravelPostersModelTests: XCTestCase {
    func testTravelPostersModel() throws {
        logger.log("running testTravelPostersModel")
        XCTAssertEqual(1 + 2, 3, "basic test")
    }
}
