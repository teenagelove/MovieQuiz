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

    func testScreenCast() throws {
        let iterator = 1...10
        let noButton = app.buttons["Нет"]
        
        iterator.forEach { _ in
            sleep(1)
            noButton.tap()
        }
        
        app.alerts["Этот раунд окончен!"].scrollViews.otherElements.buttons["Сыграть еще раз"].tap()
        
    }
}
