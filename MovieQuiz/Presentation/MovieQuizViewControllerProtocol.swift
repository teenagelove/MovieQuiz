protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showResult(result: AlertModel, restartAction: @escaping () -> Void)
    func showNetworkError(message: String, retryAction: @escaping () -> Void)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func updateButtonState()
    func highlightImageBorder(isCorrectAnswer: Bool)
}
