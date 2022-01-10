//
//  TriviaQuestion.swift
//  tilQuiz
//
//  Created by Roy Levi on 22/05/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import Foundation

struct TriviaQuestion: Codable, Equatable {
    var question: String
    var answers: [String]
    var correctAnswer: Int
    var topic: Topic
    
    enum Topic: String, Codable, Equatable, CaseIterable {
        case anatomy
        
        case cpr
        
        case routine
        case anamnesis
        
        case trauma
        case teamWork
        
        case mentalHealth
        case publicHealth
        
        case nbc // Nuclear, Biologic, Chemical
        case medicine
    }
}
