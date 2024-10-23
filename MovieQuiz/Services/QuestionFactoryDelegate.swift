//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Danil Kazakov on 23.10.2024.
//

import Foundation


protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
