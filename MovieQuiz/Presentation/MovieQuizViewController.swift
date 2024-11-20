import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButtonOutlet: UIButton!
    @IBOutlet private weak var yesButtonOutlet: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Constants
    private let questionsAmount: Int = 10
    
    // MARK: - Private Properties
    private var currentQuestionIndex: Int = .zero
    private var correctAnswers: Int = .zero
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - IBActions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        giveAnswer(givenAnswer: false)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        giveAnswer(givenAnswer: true)
    }
    
    // MARK: - Private UI Update Methods
    private func setupUI() {
        setupImageBorder()
        setupDelegate()
        statisticService = StatisticServiceImplementation()
    }
    
    private func setupDelegate() {
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
    }
    
    private func setupImageBorder() {
        imageView.layer.borderWidth = 8.0
        imageView.layer.cornerRadius = 20.0
        resetImageBorder()
    }
    
    private func resetImageBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func updateButtonState() {
        noButtonOutlet.isEnabled.toggle()
        yesButtonOutlet.isEnabled.toggle()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.image = step.image
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    // MARK: - Private Logic Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        updateButtonState()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.resetImageBorder()
            self.showNextQuestionOrResult()
            self.updateButtonState()
        }
    }
    
    private func showNextQuestionOrResult() {
        if isLastQuestion() {
            saveResult()
            let statisticMessage = createStatisticMessage()
            let quizResult = createQuizResultAlert(resultMessage: statisticMessage)
            showAlert(alert: quizResult)
        } else {
            loadNextQuestion()
        }
    }
    
    private func isLastQuestion() -> Bool {
        return currentQuestionIndex == questionsAmount - 1
    }
    
    private func loadNextQuestion() {
        currentQuestionIndex += 1
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
    
    private func showAlert(alert: AlertModel) {
        let alertPresenter = AlertPresenter(viewController: self)
        alertPresenter.showAlert(alertModel: alert)
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
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
    
    private func giveAnswer(givenAnswer answer: Bool) {
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == answer)
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alert = createNetworkErrorAlert(message: message)
        showAlert(alert: alert)
    }
    
    private func createNetworkErrorAlert(message: String) -> AlertModel {
        return createAlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: resetQuiz
        )
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizViewController:  QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}
