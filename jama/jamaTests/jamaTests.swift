//
//  jamaTests.swift
//  jamaTests
//
//  Created by Mark Brightman on 06/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import XCTest
@testable import jama

class jamaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONMapping() throws {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "MovieResult", withExtension: "json") else {
            XCTFail("Missing file: MovieResult.json")
            return
        }
        
        let jsonData = try Data(contentsOf: url)
        if let movieResults = MovieResults(data: jsonData) {
            XCTAssertEqual(movieResults.totalResults, 872)
        } else {
             XCTFail("totalResults")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
