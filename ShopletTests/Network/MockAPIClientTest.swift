//
//  MockAPIClientTest.swift
//  ShopletTests
//
//  Created by Macos on 27/06/2025.
//

import XCTest

final class MockAPIClientTest: XCTestCase {

    var mockAPI : MockAPIClient?
    override func setUp() {
        mockAPI = MockAPIClient()
    }

    override func tearDown()  {
       mockAPI = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testMockGetProducts(){
        MockAPIClient.getProducts { res in
            switch res{
            case .success(let res):
             XCTAssertNotNil(res)
            case .failure(_):
                XCTFail()
            }
        
        }
    }

}
