#warning("Remove import UIKit")
import UIKit
import Foundation

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    var correctAnswers:Int = .zero
    var currentQuestion: QuizQuestion?
    var questionFactory: QuestionFactoryProtocol?
    var statisticService: StatisticServiceProtocol?
    weak var viewController: MovieQuizViewController?
    
    private(set) var currentQuestionIndex: Int = .zero
    
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
    
    func showNextQuestionOrResult() {
        if self.isLastQuestion() {
            saveResult()
            let statisticMessage = createStatisticMessage()
            let quizResult = createQuizResultAlert(resultMessage: statisticMessage)
            showAlert(alert: quizResult)
        } else {
            showNextQuestion()
        }
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.viewController?.hideLoadingIndicator()
            self.viewController?.show(quiz: viewModel)
        }
    }
    
    func showAlert(alert: AlertModel) {
        guard let viewController else { return }
        
        let alertPresenter = AlertPresenter(viewController: viewController)
        alertPresenter.showAlert(alertModel: alert)
    }
    
    func showLoadDataError(message: String) {
        showNetworkError(message: message, completion: loadData)
    }
    
    func showLoadImageError(message: String) {
        showNetworkError(message: message, completion: reloadQuestion)
    }
    
    func loadData() {
        viewController?.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    private func showNetworkError(message: String, completion: @escaping () -> Void) {
        guard let viewController else { return }
        viewController.hideLoadingIndicator()
        let alert = createNetworkErrorAlert(message: message, completion: completion)
        showAlert(alert: alert)
    }
    
    private func createNetworkErrorAlert(message: String, completion: @escaping () -> Void) -> AlertModel {
        return createAlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: completion
        )
    }
    
    private func giveAnswer(givenAnswer answer: Bool) {
        guard let currentQuestion else { return }
        
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == answer)
    }
    
    private func saveResult() {
        guard let statisticService else { return }
        statisticService.store(
            gameResult: GameRecord(
                correct: correctAnswers,
                total: questionsAmount,
                date: Date()
            )
        )
    }
    
    private func showNextQuestion() {
        switchToNextQuestion()
        questionFactory?.requestNextQuestion()
    }
    
    private func createStatisticMessage() -> String {
        let gamesCount = statisticService?.gamesCount ?? 1
        let bestGameCorrect = statisticService?.bestGame.correct ?? correctAnswers
        let bestGameTotal = statisticService?.bestGame.total ?? questionsAmount
        let bestGameDate = statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString
        let totalAccuracy = statisticService?.totalAccuracy ?? 0
        return  """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(gamesCount)
                Рекорд: \(bestGameCorrect)/\(bestGameTotal) (\(bestGameDate))
                Средняя точность: \(String(format: "%.2f", totalAccuracy))%
                """
    }
    
    private func createQuizResultAlert(resultMessage: String) -> AlertModel {
        return createAlertModel(
            title: "Этот раунд окончен!",
            message: resultMessage,
            buttonText: "Сыграть еще раз",
            completion: resetQuiz
        )
    }
    
    private func createAlertModel(
        title: String,
        message: String,
        buttonText: String,
        completion: @escaping () -> Void
    ) -> AlertModel {
        return AlertModel(
            title: title,
            message: message,
            buttonText: buttonText,
            completion: completion
        )
    }
    
    private func resetQuiz() {
        resetQuizIndex()
        correctAnswers = .zero
        questionFactory?.requestNextQuestion()
    }
    
    private func reloadQuestion() {
        viewController?.showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

}
