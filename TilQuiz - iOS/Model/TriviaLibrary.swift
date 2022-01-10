//
//  TriviaLibrary.swift
//  tilQuiz
//
//  Created by Roy Levi on 23/05/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import Foundation

struct TriviaLibrary {
    
    init (fullLibrary: [TriviaQuestion]?, using topics: [TriviaQuestion.Topic]) {
        self.fullLibrary = fullLibrary
        usingTopics = topics
        initiateLibrary()
    }
    
    var fullLibrary: [TriviaQuestion]? {
        didSet {
            initiateLibrary()
        }
    }
    private(set) var library: [TriviaQuestion] = []
    
    var usingTopics: [TriviaQuestion.Topic] = [] {
        didSet {
            initiateLibrary()
        }
    }
    
    private mutating func initiateLibrary() {
        if let fullLibrary = fullLibrary {
            library = fullLibrary.filter({ triviaQuestion -> Bool in
                return usingTopics.contains(triviaQuestion.topic)
            })
        }
    }
    
    var currentLibraryQuestion = 0
    var currentQuestion: String {if library.count > currentLibraryQuestion{
        return library[currentLibraryQuestion].question
    } else {return ""} }
    var currentAnswers: [String] { if library.count > currentLibraryQuestion{
        return library[currentLibraryQuestion].answers
    } else {return ["", "", "", ""]} }
    var currentCorrectAnswer: Int {if library.count > currentLibraryQuestion{
        return library[currentLibraryQuestion].correctAnswer
    } else {return 0} }
    var currentTopic: TriviaQuestion.Topic { if library.count > currentLibraryQuestion{
        return library[currentLibraryQuestion].topic
    } else {return TriviaQuestion.Topic.anamnesis} }
    
}
