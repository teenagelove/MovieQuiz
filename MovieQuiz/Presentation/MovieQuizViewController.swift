import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButtonOutlet: UIButton!
    @IBOutlet private weak var yesButtonOutlet: UIButton!
    
    // MARK: - Private Constants
    private let questionsAmount: Int = 10
    
    // MARK: - Private Properties
    private var currentQuestionIndex: Int = .zero
    private var correctAnswers: Int = .zero
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - IBActions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else { return }
        let givenAnswer = false
        showAnswerResult(
            isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else { return }
        let givenAnswer = true
        showAnswerResult(
            isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private UI Update Methods
    private func setupUI() {
        setupImageBorder()
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
    }
    
    private func setupImageBorder() {
        imageView.layer.borderWidth = 8.0
        imageView.layer.cornerRadius = 20.0
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
        if currentQuestionIndex == questionsAmount - 1 {
            let resultMessage = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
            let quizResult = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: resultMessage,
                buttonText: "Сыграть еще раз"
            )
            showAlert(quiz: quizResult) {
                self.resetQuiz()
            }
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }

    private func showAlert(quiz result: QuizResultsViewModel, action: @escaping () -> Void) {
        let alertPresenter = AlertPresenter(viewController: self)
        
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { action()}
        )
        
        alertPresenter.showAlert(alertModel: alertModel)
        
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
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
