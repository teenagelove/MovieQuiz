import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func showResult(result: MovieQuiz.AlertModel, restartAction: @escaping () -> Void) {
        
    }
    
    func showNetworkError(message: String, retryAction: @escaping () -> Void) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func updateButtonState() {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterCovertToViewModel() {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = presenter.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, question.text)
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
