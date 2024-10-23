//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Danil Kazakov on 23.10.2024.
//

import UIKit


final class AlertPresenter {
    private var viewController: UIViewController?
    
    private func showAlert(alertModel: AlertModel) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: alertModel.buttonMessage, style: .default) {_ in
            alertModel.completion()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
