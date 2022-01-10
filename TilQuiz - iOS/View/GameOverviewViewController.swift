//
//  GameOverviewViewController.swift
//  tilQuiz
//
//  Created by Mador Til on 26/02/2019.
//  Copyright © 2019 Yahav Levi. All rights reserved.
//

import UIKit

class GameOverviewViewController: UIViewController {
    
    let database = DatabaseFacade.shared
    weak var delegate: GameOverviewActionDelegate?
    
    @IBOutlet weak var myScoreReviewImageView: UIImageView!
    @IBOutlet weak var myScoreLabel: UILabel!
    @IBOutlet weak var didWinLabel: UILabel!
    @IBOutlet weak var scoreWonLabel: UILabel!
    @IBOutlet weak var koalaImageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    
    func setupLayout(for gameType: GameSession.GameType, scoreAppended: Int?) {
        view.layer.cornerRadius = 10
        
        view.backgroundColor = #colorLiteral(red: 0.7123180032, green: 0.6802606583, blue: 0.7333264947, alpha: 1)
        
        if let scoreAppended = scoreAppended{
            if(scoreAppended > 0) {
                didWinLabel.text = "בשבילי אתה תמיד מנצח!"
                scoreWonLabel.text = "זכית ב-\(scoreAppended) נקודות!"
                myScoreLabel.text = "\(scoreAppended)"
                koalaImageView.image = #imageLiteral(resourceName: "koala_happy")
            } else {
                didWinLabel.text = "לא יכולת לנצח אה?!"
                scoreWonLabel.text = ""
                myScoreLabel.text = "\(scoreAppended)"
                koalaImageView.image = #imageLiteral(resourceName: "koala_sad")
            }
        } else {
            didWinLabel.text = "לא יכולת לנצח אה?!"
            scoreWonLabel.text = ""
            myScoreLabel.text = "\(scoreAppended ?? 0)"
            koalaImageView.image = #imageLiteral(resourceName: "koala_sad")
        }
        
        myScoreReviewImageView.setForAnimation(of: .myScoreReview)
        myScoreReviewImageView.startAnimating()
        continueButton.layer.cornerRadius = 10
    }
    @IBAction func continueButtonClicked(_ sender: UIButton) {
        delegate?.exitGameFromOverview()
    }
}

protocol GameOverviewActionDelegate: class {
    func exitGameFromOverview()
}
