import XCTest
@testable import NKComponents

final class NKComponentsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NKComponents().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
