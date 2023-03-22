//
//  StoreSearchAppTests.swift
//  StoreSearchAppTests
//
//  Created by hasung jung on 2023/03/22.
//

import ComposableArchitecture
import XCTest

@testable import StoreSearchApp

final class StoreSearchAppTests: XCTestCase {


    func testSearchAPI() throws {
        let expectation = expectation(description: "SearchAPI Testing")

        Task {
            let result = await SearchResultClient.fetchSearchList(query: "K", limit: 50, page: 1)
            print(result)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0) { error in
            print(error)
        }
    }

    func testSearchAndClear() async {
        let store = TestStore(initialState: SearchFeature.State(), reducer: SearchFeature()) { reducer in
            
        }
    }

}
