#warning("Remove import UIKit")
import UIKit
import Foundation

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    #warning("Add (set)")
    private var currentQuestionIndex: Int = .zero
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuizIndex() {
        currentQuestionIndex = .zero
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    func noButtonClicked() {
        giveAnswer(givenAnswer: false)
    }
    func yesButtonClicked() {
        giveAnswer(givenAnswer: true)
    }
    
    private func giveAnswer(givenAnswer answer: Bool) {
        guard let currentQuestion else { return }
        
        #warning("Need add currentQuestion == view.currentQuestion")
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == answer)
    }
}
