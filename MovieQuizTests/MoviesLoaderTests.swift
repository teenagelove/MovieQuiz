import XCTest
@testable import MovieQuiz

final class MovieLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure:
                XCTFail("Unexpected failure")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        let stabNetworkClient = StubNetworkClient(emulateError: true)
        let moviesLoader = MoviesLoader(networkClient: stabNetworkClient)
        
        let expectation = expectation(description: "Loading expectation")
        
        moviesLoader.loadMovies { result in
            switch result {
            case .success:
                XCTFail("Unexpected success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}
