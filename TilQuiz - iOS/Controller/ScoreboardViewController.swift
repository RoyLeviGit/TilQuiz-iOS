//
//  ScoreboardViewController.swift
//  tilQuiz
//
//  Created by Roy Levi on 05/06/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import UIKit

class ScoreboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var database = DatabaseFacade.shared
    
    @IBOutlet weak var scoreboardTableView: UITableView!
    
    var myScore: Score? {
        didSet {
//            if let myScore = myScore, let scoreboard = scoreboard, let placement = scoreboard.index(of: myScore) {
//                    myPlacement.text = "\(placement + 1)"
//            }
//            myDisplayName.text = database.userDisplayName ?? "Guest"
//            myDisplayedScore.text = "\(myScore?.score ?? 0)"
        }
    }
    
    var scoreboard: [Score]? {
        didSet {
            scoreboardTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreboardTableView.dataSource = self
        scoreboardTableView.delegate = self
    }
    
    var scoreboardObserver: NSObjectProtocol?
    var myScoreObserver: NSObjectProtocol?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scoreboardObserver = notifCentre.addObserver(forName: .DatabaseFacadeScoreboard, object: database, queue: OperationQueue.main) { [weak self] scoreboardNotification in
            if var scoreboard = self?.database.scoreboard {
                // Sorts scoreboard by score
                scoreboard.sort(by: { (score0: Score, score1: Score) -> Bool in
                    return score0.score > score1.score
                })
                self?.scoreboard = scoreboard
            }
        }
        myScoreObserver = notifCentre.addObserver(forName: .DatabaseFacadeMyScore, object: database, queue: OperationQueue.main) { [weak self] myScoreNotification in
            self?.myScore = self?.database.myScore
        }
        database.fetchScoreboard()
        myScore = database.myScore
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let scoreboardObserver = scoreboardObserver {
            notifCentre.removeObserver(scoreboardObserver)
        }
        if let myScoreObserver = myScoreObserver {
            notifCentre.removeObserver(myScoreObserver)
        }
    }
    
    let tableViewCellsHeight = CGFloat(60)
    
    //MARK: - Footer
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if database.isSignedIn {
            if let myScoreCell = tableView.dequeueReusableCell(withIdentifier: "scoreCell") as? ScoreTableViewCell {
                myScoreCell.scoreLabel.text = "\(myScore?.score ?? 0)"
                myScoreCell.displayNameLabel.text = database.userDisplayName ?? "Guest"
                if let myScore = myScore, let scoreboard = scoreboard, let placement = scoreboard.index(of: myScore) {
                    myScoreCell.placementLabel.text = "\(placement)"
                    myScoreCell.placementImageView.image = imageForPlacement(placement: placement)
                    if placement == 0 { myScoreCell.placementLabel.isHidden = true }
                    else { myScoreCell.placementLabel.isHidden = false }
                }
                return myScoreCell
            }
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableViewCellsHeight
    }
    
    //MARK: - Cells
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let scoreboard = scoreboard {
            return scoreboard.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let scoreboard = scoreboard {
            let scoreCell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath)
            if let scoreCell = scoreCell as? ScoreTableViewCell {
                scoreCell.scoreLabel.text = "\(scoreboard[indexPath.row].score)"
                scoreCell.displayNameLabel.text = scoreboard[indexPath.row].displayName
                scoreCell.placementLabel.text = "\(indexPath.row)"
                scoreCell.placementImageView.image = imageForPlacement(placement: indexPath.row)
                if indexPath.row == 0 { scoreCell.placementLabel.isHidden = true }
                else { scoreCell.placementLabel.isHidden = false }
            }
            return scoreCell
        }
        return tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellsHeight
    }
    
    func imageForPlacement(placement: Int) -> UIImage {
        switch placement {
        case 0: return #imageLiteral(resourceName: "king_of_the_scoreboard")
        case 1: return #imageLiteral(resourceName: "score_placement_1")
        case 2: return #imageLiteral(resourceName: "score_placement_2")
        case 3: return #imageLiteral(resourceName: "score_placement_3")
        default: return #imageLiteral(resourceName: "score_placement")
        }
    }
}
