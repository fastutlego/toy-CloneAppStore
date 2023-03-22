//
//  RatingViewTest.swift
//  StoreSearchAppTests
//
//  Created by hasung jung on 2023/03/22.
//

import XCTest
@testable import StoreSearchApp

final class RatingViewTest: XCTestCase {

    func test_4_5() {
        let view = RatingView(currentRating: 4.5)
        XCTAssertEqual(view.emptyStarCount, 0)
        XCTAssertEqual(view.fullStartCount, 4)
        XCTAssertEqual(view.halfStartCount, 1)
    }

    func test_3() {
        let view = RatingView(currentRating: 3)
        XCTAssertEqual(view.emptyStarCount, 2)
        XCTAssertEqual(view.fullStartCount, 3)
        XCTAssertEqual(view.halfStartCount, 0)
    }

    func test_0() {
        let view = RatingView(currentRating: 0)
        XCTAssertEqual(view.emptyStarCount, 5)
        XCTAssertEqual(view.fullStartCount, 0)
        XCTAssertEqual(view.halfStartCount, 0)
    }
}
