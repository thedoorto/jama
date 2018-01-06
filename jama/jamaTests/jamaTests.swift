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
    
    func testActualNowPlayingResponse() {
        var data: [MovieResult]?
        var firstResult: MovieResult?
        let expectation = self.expectation(description: "Wait for data to load.")
        getMoviesNowPlaying{ (results) in
            data = results
            if let data = data {
                firstResult = data[0]
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertTrue(data!.count > 0)
        XCTAssertNotNil(firstResult?.title)
    }
    
    func getMoviesNowPlaying(completion: @escaping ([MovieResult]?) -> Void) {
        let api: APIClient = APIClient(api: APIBase())
        api.getNowPlaying{ (results) in
            switch results {
            case .Success(let value):
                completion(value.results)
            case .Failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
}
