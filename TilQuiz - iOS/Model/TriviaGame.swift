//
//  TriviaGame.swift
//  tilQuiz
//
//  Created by Roy Levi on 10/06/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import Foundation

class TriviaGame: GameProtocol {
    
    
    let database = DatabaseFacade.shared
    
    var gameSessionDataObservers: [NSObjectProtocol] = []
    
    init(with topics: [TriviaQuestion.Topic]) throws {
        // Might init empty array if no earlier database trivia questions fetch happened
        database.fetchTriviaQuestions()
        if let library = database.triviaQuestions {
            self.library = TriviaLibrary(fullLibrary: library, using: topics)
        } else {
            database.fetchTriviaQuestions()
            throw GameError.noLibraryInitilizedByDatabase
        }
        if(TriviaGame.maxQuestions > library.library.count){
            TriviaGame.maxQuestions = library.library.count - 1
        }
    }
    
    // MARK: - Game Flow
    
    var library: TriviaLibrary
    private static var maxQuestions = Settings.shared.triviaMaxQuestions
    
    private var pickedQuestionIndices: [Int] = []
    private func pickRandomQuestion() {
        var index = library.library.count.arc4random
        // May become easaly infinite
        while pickedQuestionIndices.contains(index) {
            index = library.library.count.arc4random
        }
        pickedQuestionIndices.append(index)
        library.currentLibraryQuestion = index
    }
    
    func readyForNextQuestion() {
        // All the logic happens in the didSet of the myPlayerData var
        myPlayerData?.progression += 1
    }
    
    func correctAnswerPicked() {
        timerUpdater?.invalidate()
        myPlayerData?.score += scoreIncrement
    }
    func incorrectAnswerPicked() {
        timerUpdater?.invalidate()
        myPlayerData?.score -= scoreDecrement
    }
    
    var minScore: Int = Settings.shared.triviaMinScore
    
    var maxScore: Int = Settings.shared.triviaMaxScore
    
    // MARK: - Timer
    
    var maxTime = Settings.shared.triviaMaxTime
    
    var timeElapsed = 0.0 {
        didSet {
            timeElapsedDidSet()
        }
    }
    var startTime = 0.0
    var timerUpdater: Timer?
    
    // MARK: - Game Session Changes Listeners
    
    var myPlayerData: GameSession.PlayerData? {
        didSet {
            // Responds to my progression changes
            if oldValue?.progression != myPlayerData?.progression {
                    if myPlayerData?.progression == TriviaGame.maxQuestions + 1{
                        myPlayerData?.gameState = .complete
                    } else {
                        pickRandomQuestion()
                        notifCentre.post(name: .GameNextQuestionReady, object: self)
                    }            }
            myPlayerDataDidSet(oldValue: oldValue)
        }
    }
}
