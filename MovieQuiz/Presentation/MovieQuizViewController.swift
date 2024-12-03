import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButtonOutlet: UIButton!
    @IBOutlet private weak var yesButtonOutlet: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var waitingView: UIView!
    
    // MARK: - Private Properties
    private var presenter: MovieQuizPresenter!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - IBActions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Public UI Update Methods
    func showLoadingIndicator() {
        waitingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        waitingView.isHidden = true
        activityIndicator.isHidden = true
    }
    
    func resetImageBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func updateButtonState() {
        noButtonOutlet.isEnabled.toggle()
        yesButtonOutlet.isEnabled.toggle()
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func show(quiz step: QuizStepViewModel) {
        resetImageBorder()
        updateButtonState()
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.image = step.image
    }
    
    func showNetworkError(message: String, retryAction: @escaping () -> Void) {
        activityIndicator.isHidden = true
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать еще раз",
                                   style: .default) { _ in
            retryAction()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showResult(result: AlertModel, restartAction: @escaping () -> Void) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            restartAction()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private UI Update Methods
    private func setup() {
        setupPresenter()
        setupUI()
    }
    private func setupUI() {
        setupImageBorder()
        updateButtonState()
    }
    
    private func setupPresenter() {
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    private func setupImageBorder() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8.0
        imageView.layer.cornerRadius = 20.0
        resetImageBorder()
    }
}
