//
//  GameSession.swift
//  tilQuiz
//
//  Created by Roy Levi on 23/05/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import Foundation

struct GameSession: Codable, Equatable {
    
    var gameKey: String
    
    var creatorData: PlayerData
    
    var gameType: GameType
    var topics: [TriviaQuestion.Topic]?
    var usingSubLibraries: [Bool]?
    
    struct PlayerData: Codable, Equatable {
        var name: String
        var score: Int
        var progression: Int
        var gameState: State
        
        enum State: String, Codable, Equatable {
            case open
            case ongoing
            case ended
            case complete
        }
    }
    
    enum GameType: String, Codable, Equatable {
        case trivia
    }
}
