//
//  ViewModelTests.swift
//  DefinitivTests
//
//  Created by Navi on 19/07/22.
//

import XCTest
@testable import Definitiv

class ViewModelTests: XCTestCase {

    var viewModel: ViewModelData?
    
    override func setUpWithError() throws {
       viewModel = ViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testFetchTemperature_Success_With_ValidCityName() {
        let expectation = XCTestExpectation(description: #function)
        
        viewModel?.fetchTemperatures(cityName: "Mumbai", completionHandler: { result in
            switch result {
            case .success(let temperatures):
                XCTAssertNotNil(temperatures)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        })
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchTemperature_Failure_With_InValidCityName() {
        let expectation = XCTestExpectation(description: #function)
        
        viewModel?.fetchTemperatures(cityName: "InvalidCity", completionHandler: { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let err):
                XCTAssertNotNil(err)
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 5)
    }
}
