import UIKit


final class MovieQuizPresenter {
    // MARK: - Private Constants
    private let questionsAmount: Int = 10
    private let statisticService: StatisticServiceProtocol!
    
    // MARK: - Private Properties
    private(set) var correctAnswers:Int = .zero
    private(set) var currentQuestionIndex: Int = .zero
    private(set) var currentQuestion: QuizQuestion?
    private(set) var questionFactory: QuestionFactoryProtocol?
    private(set) weak var viewController: MovieQuizViewControllerProtocol?
    
    
    // MARK: - Initializers
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - Public Methods
    func giveAnswer(isTrue answer: Bool) {
        guard let currentQuestion else { return }
        proceedWithAnswer(isCorrect: currentQuestion.correctAnswer == answer)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    // MARK: - Private Methods
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func restartGame() {
        currentQuestionIndex = .zero
        correctAnswers = .zero
        questionFactory?.requestNextQuestion()
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            saveResult()
            let statisticMessage = makeResultsMessage()
            let quizResult = createQuizResultAlert(resultMessage: statisticMessage)
            viewController?.showResult(result: quizResult) { [weak self] in
                guard let self else { return }
                self.restartGame()
            }
        } else {
            goToNextQuestion()
        }
    }
    
    private func makeResultsMessage() -> String {
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
    
    private func loadData() {
        viewController?.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    private func loadQuestion() {
        viewController?.showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        if isCorrect {
            self.correctAnswers += 1
        }
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        viewController?.updateButtonState()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.proceedToNextQuestionOrResults()
            viewController?.updateButtonState()
        }
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
    
    private func goToNextQuestion() {
        switchToNextQuestion()
        questionFactory?.requestNextQuestion()
    }
    
    private func createQuizResultAlert(resultMessage: String) -> AlertModel {
        return AlertModel(
            title: "Этот раунд окончен!",
            message: resultMessage,
            buttonText: "Сыграть еще раз",
            completion: restartGame
        )
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
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
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        viewController?.showNetworkError(message: error.localizedDescription) { [weak self] in
            guard let self else { return }
            self.loadData()
        }
    }
    
    func didFailToLoadImage(with error: any Error) {
        viewController?.showNetworkError(message: error.localizedDescription) { [weak self] in
            guard let self else { return }
            self.loadQuestion()
        }
    }
}
