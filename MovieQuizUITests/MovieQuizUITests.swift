import XCTest

final class MovieQuizUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testGameResultAlert() {
        let noButton = app.buttons["No"]
        let alert = app.alerts["Этот раунд окончен!"]
        let index = app.staticTexts["Index"]
        
        for iter in 1...10 {
            sleep(2)
            XCTAssertEqual(index.label, "\(iter)/10")
            noButton.tap()
        }
        
        sleep(1)
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
        
        alert.buttons.firstMatch.tap()
        sleep(1)
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(index.label, "1/10")
    }

    func testYesButton() {
        sleep(1)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(1)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton() {
        sleep(1)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(1)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
}
