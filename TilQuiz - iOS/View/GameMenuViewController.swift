//
//  GameMenuViewController.swift
//  tilQuiz
//
//  Created by Mador Til on 14/11/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import UIKit

class GameMenuViewController: UIViewController {
    
    weak var delegate: GameMenuActionDelegate?
    
    @IBOutlet weak var exitGameButton: UIButton!
    @IBOutlet weak var returnToGameButton: UIButton!
    
    func setupLayout(for gameType: GameSession.GameType) {
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0.7137254902, green: 0.6784313725, blue: 0.7333333333, alpha: 1)
        exitGameButton.layer.cornerRadius = 10
        returnToGameButton.layer.cornerRadius = 10
    }
    
    @IBAction func exitGameButtonClicked(_ sender: UIButton) {
        delegate?.exitGameFromMenu()
    }
    
    @IBAction func returnToGameButtonClicked(_ sender: UIButton) {
        delegate?.returnToGame()
    }
}

protocol GameMenuActionDelegate: class {
    func exitGameFromMenu()
    func returnToGame()
}
