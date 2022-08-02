//
//  EarthQuakeTests.swift
//  EarthQuakeTests
//
//  Created by Peter Liaw on 7/29/22.
//

import XCTest
@testable import EarthQuake

class EarthQuakeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Test the basic getter method
    func testDataService() throws {
        let now = Epoch.now()
        let exp = expectation(description: "testGetData")
        DataService.shared.getData(startTime: now.delta(days: -1), endTime: now) { result in
            switch result {
            case .success(let data):
                print("\(data.features.count) records retrieved")
                exp.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    /// Test getInitialData and getOlderData, to mimic user paging down through records
    func testDataServiceMgr() throws {
        let exp = expectation(description: "testDataServiceMgr")
        DataServiceMgr.shared.getInitialData { result in
            switch result {
            case .success(let resp):
                DataServiceMgr.shared.getOlderData { result in
                    switch result {
                    case .success(let resp):
                        var lastTime = Int.max
                        for i in resp {
                            if i.properties.time > lastTime {
                                XCTFail("values not in descending order")
                                break
                            }
                            lastTime = i.properties.time
                        }
                        exp.fulfill()
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 10)
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

}
