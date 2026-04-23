import XCTest
@testable import DateExtension

final class DateExtensionTests: XCTestCase {
    func testPreservesOriginalWhenNoDateDetected() {
        let input = "not-a-date"
        XCTAssertEqual(input.formattedDate(.ddMMyyyy), input)
    }

    func testISO8601ConversionStillWorks() {
        let input = "2023-12-31T14:35:50Z"
        XCTAssertEqual(input.formattedDate(.ddMMyyyy), "31.12.2023")
    }

    func testCustomFormattingFromKnownInput() {
        let input = "31.12.2023"
        XCTAssertEqual(input.formattedDate(.custom("yyyy-MM-dd")), "2023-12-31")
    }

    func testUnixTimestampDetection() {
        let input = "1704033350"
        XCTAssertEqual(input.formattedDate(.yyyyMMdd), "2023-12-31")
    }
}
