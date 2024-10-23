//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Danil Kazakov on 23.10.2024.
//

import Foundation


struct AlertModel {
    let title: String
    let message: String
    let buttonMessage: String
    let completion: () -> Void
}
