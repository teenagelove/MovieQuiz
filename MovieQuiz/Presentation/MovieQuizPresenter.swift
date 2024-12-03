#warning("Remove import UIKit")
import UIKit
import Foundation

final class MovieQuizPresenter {
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = .zero
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
}
