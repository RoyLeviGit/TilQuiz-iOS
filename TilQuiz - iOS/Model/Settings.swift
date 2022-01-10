//
//  Settings.swift
//  tilQuiz
//
//  Created by Mador Til on 12/02/2019.
//  Copyright © 2019 Yahav Levi. All rights reserved.
//

import Foundation

struct Settings: Codable {
    let triviaMaxQuestions: Int
    let triviaMaxTime: Double
    let triviaMinScore: Int
    let triviaMaxScore: Int
    
    let triviaQuestionAnimationDuration: TimeInterval
    let triviaQuestionDisplayedDelay: TimeInterval
    let triviaInAnimationDuration: TimeInterval
    let triviaOutAnimationDuration: TimeInterval
    let triviaAnswerShownDelay: TimeInterval
    let triviaAnswerColorChangeDuration: TimeInterval
    
    let schemaMaxTime: Double
    let schemaMinScore: Int
    let schemaMaxScore: Int
    
    let schemaInAnimationDuration: TimeInterval
    let schemaOutAnimationDuration: TimeInterval
    let schemaAnswerShownDelay: TimeInterval
    let schemaAnswerColorChangeDuration: TimeInterval
    
    static var shared: Settings!
}
