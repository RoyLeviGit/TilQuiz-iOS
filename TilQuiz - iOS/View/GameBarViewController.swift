//
//  GameBarView.swift
//  tilQuiz
//
//  Created by Mador Til on 22/10/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import UIKit

class GameBarViewController: UIViewController {

    var timeElapsed = 0.0 {
        didSet {
            timeElapsedProgressView.progress = Float(timeElapsed / maxTime)
        }
    }
    var maxTime = 1.0
    @IBOutlet weak var timeElapsedProgressView: UIProgressView!
    
    
    @IBOutlet weak var myScoreLabel: UILabel!
    @IBOutlet weak var myPlayerImageView: UIImageView!
    
    func setupLayout(for gameType: GameSession.GameType) {
        view.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.3607843137, blue: 0.5294117647, alpha: 0.31)
        timeElapsedProgressView.tintColor = #colorLiteral(red: 0.2901960784, green: 0.2705882353, blue: 0.3843137255, alpha: 0.62)
        timeElapsedProgressView.progress = 0
        
        myPlayerImageView.setForAnimation(of: .singleplayer)
        myPlayerImageView.startAnimating()
    }
    
    var menuClickHandler: (() -> Void)?
    @IBAction func menuButtonClicked(_ sender: UIButton) {
        menuClickHandler?()
    }
}
