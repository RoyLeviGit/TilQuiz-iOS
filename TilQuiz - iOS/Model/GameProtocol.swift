//
//  GameProtocol.swift
//  tilQuiz
//
//  Created by Roy Levi on 25/06/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import Foundation

protocol GameProtocol: class {
    
    var database: DatabaseFacade { get }

    var gameSessionDataObservers: [NSObjectProtocol] { get set }
    func start()
    
    // MARK: - Game Flow
    
    func readyForNextQuestion()
    func correctAnswerPicked()
    func incorrectAnswerPicked()
    
    var minScore: Int { get }
    var maxScore: Int { get }
    var scoreIncrement: Int { get }
    var scoreDecrement: Int { get }
    
    // MARK: - Timer
    
    var maxTime: Double { get set }
    var timeElapsed: Double { get set }
    func timeElapsedDidSet()
    var startTime: Double { get set }
    var timerUpdater: Timer? { get set }
    func restartTimer()
    
    // MARK: - Game Session Changes Listeners
    
    var myPlayerData: GameSession.PlayerData? { get set }
    func myPlayerDataDidSet(oldValue: GameSession.PlayerData?)
}

extension GameProtocol {
    func start() {
            myPlayerData = GameSession.PlayerData(name: "Singleplayer", score: 0, progression: 0, gameState: .ongoing)
    }
    
    // MARK: - Game Flow
    
    var scoreIncrement: Int {
        get {
            return minScore + Int(Double(maxScore - minScore) * (maxTime - timeElapsed) / maxTime)
        }
    }
    var scoreDecrement: Int {
        get {
            return minScore / 2
        }
    }
    
    // MARK: - Timer
    
    internal func timeElapsedDidSet() {
        if timeElapsed > maxTime {
            timerUpdater?.invalidate()
            notifCentre.post(name: .GameOutOfTime, object: self)
        }
        notifCentre.post(name: .GameTimeElapsedUpdated, object: self)
    }
    func restartTimer() {
        timeElapsed = 0.0
        startTime = Date.timeIntervalSinceReferenceDate
        timerUpdater?.invalidate()
        timerUpdater = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            if let startTime = self?.startTime {
                self?.timeElapsed = Date.timeIntervalSinceReferenceDate - startTime
            }
        }
    }
    
    // MARK: - Game Session Changes Listeners
    
    /// Responds to my game state, and score changes. Uploads changes to database if needed.
    /// Still needs implementation for progression changes
    ///
    /// - Parameter oldValue: This variables old value
    internal func myPlayerDataDidSet(oldValue: GameSession.PlayerData?) {
        // Responds to my game state changes
        if oldValue?.gameState != myPlayerData?.gameState, let gameState = myPlayerData?.gameState {
            respondToGameStateChanges(state: gameState)
        }
        // Responds to my score changes
        if oldValue?.score != myPlayerData?.score {
            notifCentre.post(name: .GameMyScoreUpdated, object: self)
        }
        // Uploads changes to database if needed
    }
    
    private func respondToGameStateChanges(state: GameSession.PlayerData.State) {
        switch state {
        case .ended:
            notifCentre.post(name: .GameEnded, object: self)
        case .complete:
            notifCentre.post(name: .GameComplete, object: self)
        case .ongoing:
            notifCentre.post(name: .GameOpponentPresent, object: self)
        default:
            break
        }
    }
    func cleanUp() {
        timerUpdater?.invalidate()
        gameSessionDataObservers.forEach { gameSessionDataObserver in
            notifCentre.removeObserver(gameSessionDataObserver)
        }
    }
}
