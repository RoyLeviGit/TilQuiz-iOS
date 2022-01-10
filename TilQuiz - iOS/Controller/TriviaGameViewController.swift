//
//  TriviaGameViewController.swift
//  tilQuiz
//
//  Created by Roy Levi on 10/06/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import UIKit
import IBAnimatable

class TriviaGameViewController: UIViewController, GameMenuActionDelegate, GameOverviewActionDelegate {
    
    weak var gameBar: GameBarViewController!
    
    @IBOutlet weak var questionLabel: TriviaQuestionLabel!
    @IBOutlet weak var questionTopicBubbleImageView: UIImageView!
    @IBOutlet var answerCards: [TriviaAnswerCard]!
    
    private var game: TriviaGame?
    var topics: [TriviaQuestion.Topic]?
    
    // MARK: - Game Setup
    
    
    private var observers: [NSObjectProtocol] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        answerCards.forEach { answerCard in
            answerCard.alpha = 0
        }
        
        observers = [
            notifCentre.addObserver(forName: .GameNextQuestionReady, object: game, queue: .main) { _ in
                self.displayTriviaQuestion() {
                    self.game?.restartTimer()
                }
            },
            notifCentre.addObserver(forName: .GameMyScoreUpdated, object: game, queue: .main) { _ in
                self.gameBar.myScoreLabel.text = self.game?.myPlayerData?.score.description
            },
            notifCentre.addObserver(forName: .GameTimeElapsedUpdated, object: game, queue: .main) { _ in
                self.gameBar.timeElapsed = self.game?.timeElapsed ?? 0
            },
            notifCentre.addObserver(forName: .GameOutOfTime, object: game, queue: .main) { _ in
                self.timerRanOutOfTime()
            }]
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topics = [MenuViewController.topicChosen]
        if let topics = topics{
            do {
                try game = TriviaGame(with: topics)
            } catch GameError.noLibraryInitilizedByDatabase {
                // Display error message and dissmiss VC
                displayAlertMessage(messageToDisplay: "No Library Initilized By Database\nCheck Internet Connection")
                dismiss(animated: true)
                return
            } catch {
                // Display error message and dismiss VC
                displayAlertMessage(messageToDisplay: error.localizedDescription)
                dismiss(animated: true)
                return
            }
            
            setupDisplay()

            game?.start()
        } else {
            // Display error message and dissmiss VC
            displayAlertMessage(messageToDisplay: "Needed Preparations Missing\nTry relaunching app")
            dismiss(animated: true)
            return
        }
    }

    private func setupDisplay() {
        gameBar.setupLayout(for: .trivia)
        gameBar.menuClickHandler = { [unowned self] in self.gameMenuViewControllerContainer.isHidden = false }
        // Pass max time var from game to gameBar for time indication
        gameBar.maxTime = game!.maxTime
        
        questionLabel.layer.cornerRadius = 10
        questionLabel.layer.masksToBounds = true
        // Attach topic bubble to question label for animations
        questionLabel.addSubview(questionTopicBubbleImageView)
        
        // Setup answerCards needed traits for future animations
        for index in answerCards.indices {
            answerCards[index].originalFrameOrigin = answerCards[index].frame.origin
            // Set the right side of cards to lean left (default is right)
            if index%2 == 1 {
                answerCards[index].cardLeanRotation = .left
            }
            // Set the answer buttons text properties
            answerCards[index].titleLabel?.numberOfLines = 0
            answerCards[index].titleLabel?.textAlignment = NSTextAlignment.center
            answerCards[index].titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            answerCards[index].titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        // Starting deck position
        for index in answerCards.indices {
            let animationStartingPoint = view.convert(CGPoint(x: (view.frame.width - answerCards[index].frame.width)/2 - 8,
                                       y: view.frame.height - answerCards[index].frame.height - 8),
                               to: answerCards[index].superview!)
            answerCards[index].frame.origin = animationStartingPoint
            if index%2 == 0 {
                answerCards[index].transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
            } else {
                answerCards[index].transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            }
            answerCards[index].alpha = 1
        }
        
        // Menu setup
        gameMenuViewController.setupLayout(for: .trivia)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        for observer in observers {
            notifCentre.removeObserver(observer)
        }
    }
    
    // MARK: - Game Flow
    
    private func displayTriviaQuestion(animationCompleted: (() -> Void)? = nil) {
        
        questionLabel.text = game?.library.currentQuestion
        if let currentTopic = game?.library.currentTopic {
            questionTopicBubbleImageView.image = TriviaQuestion.Topic.bubbleImage(for: currentTopic)
        }
        let cImages = cardsImages(for: game?.library.currentTopic)
        for index in answerCards.indices {
            answerCards[index].setTitle(game?.library.currentAnswers[index], for: .normal)
            answerCards[index].setBackgroundImage(cImages[index], for: .normal)
        }
        
        questionLabel.animateIn {
            Timer.scheduledTimer(withTimeInterval: Settings.shared.triviaQuestionDisplayedDelay, repeats: false) { _ in
                self.answerCards.forEach { $0.isEnabled = true }
                self.answerCards[0].animateToOriginalPosition()
                self.answerCards[1].animateToOriginalPosition()
                self.answerCards[2].animateToOriginalPosition()
                self.answerCards[3].animateToOriginalPosition() {
                    animationCompleted?()
                }
            }
        }
    }
    
    private func cardsImages(for topic: TriviaQuestion.Topic?) -> [UIImage] {
        if let topic = topic {
            switch topic {
            case .anatomy, .medicine, .teamWork, .mentalHealth:
                return [#imageLiteral(resourceName: "trivia_answer_1b"),#imageLiteral(resourceName: "trivia_answer_2b"),#imageLiteral(resourceName: "trivia_answer_3b"),#imageLiteral(resourceName: "trivia_answer_4b")]
            case .cpr, .anamnesis, .publicHealth:
                return [#imageLiteral(resourceName: "trivia_answer_1r"),#imageLiteral(resourceName: "trivia_answer_2r"),#imageLiteral(resourceName: "trivia_answer_3r"),#imageLiteral(resourceName: "trivia_answer_4r")]
            case .routine, .trauma, .nbc:
                return [#imageLiteral(resourceName: "trivia_answer_1g"),#imageLiteral(resourceName: "trivia_answer_2g"),#imageLiteral(resourceName: "trivia_answer_3g"),#imageLiteral(resourceName: "trivia_answer_4g")]
            }
        } else {
            return [#imageLiteral(resourceName: "trivia_answer_1g"),#imageLiteral(resourceName: "trivia_answer_2g"),#imageLiteral(resourceName: "trivia_answer_3g"),#imageLiteral(resourceName: "trivia_answer_4g")]
        }
    }
    
    @IBAction func answerButtonClicked(_ sender: TriviaAnswerCard?) {
        answerCards.forEach { $0.isEnabled = false }
        if let sender = sender {
            if answerCards.index(of: sender) == game!.library.currentCorrectAnswer {
                correctAnswerClicked(by: sender)
            } else {
                incorrectAnswerClicked(by: sender)
            }
        } else {
            incorrectAnswerClicked(by: nil)
        }
    }
    
    private func correctAnswerClicked(by sender: TriviaAnswerCard) {
        game!.correctAnswerPicked()
        
        sender.animateCorrectAnswer() {
            self.gameBar.timeElapsed = 0
            self.questionLabel.animateOut()
            self.answerCards[0].animateCorrectAnswerPicked()
            self.answerCards[1].animateCorrectAnswerPicked()
            self.answerCards[2].animateCorrectAnswerPicked()
            self.answerCards[3].animateCorrectAnswerPicked() {
                self.game!.readyForNextQuestion()
                if(self.game!.myPlayerData!.gameState == .complete){
                    self.exitGameFromOverview()
                }
            }
        }
    }
    private func incorrectAnswerClicked(by sender: TriviaAnswerCard?) {
        game!.incorrectAnswerPicked()
        
        sender?.animateIncorrectAnswer()
    
        answerCards[game!.library.currentCorrectAnswer].animateCorrectAnswer() {
            self.gameBar.timeElapsed = 0
            self.questionLabel.animateOut()
            self.answerCards[0].animateIncorrectAnswerPicked()
            self.answerCards[1].animateIncorrectAnswerPicked()
            self.answerCards[2].animateIncorrectAnswerPicked()
            self.answerCards[3].animateIncorrectAnswerPicked() {
                self.game!.readyForNextQuestion()
                if(self.game!.myPlayerData!.gameState == .complete){
                    self.exitGameFromOverview()
                }
            }
        }
    }
    
    func timerRanOutOfTime() {
        print("timer out of time")
        answerButtonClicked(nil)
    }
    
    
    // MARK: - Overview
    
    weak var gameOverviewViewController: GameOverviewViewController!
    @IBOutlet weak var gameOverviewViewControllerContainer: UIView!
    func exitGameFromOverview() {
        print("game finished")
        dismiss(animated: true)
        performSegue(withIdentifier: "ShowMainTabMenu", sender: self)
    }
    
    // MARK: - Menu
    
    weak var gameMenuViewController: GameMenuViewController!
    @IBOutlet weak var gameMenuViewControllerContainer: UIView!
    func exitGameFromMenu() {
        print("game quit")
        game?.cleanUp()
        gameOverviewViewController.setupLayout(for: .trivia,
                                               scoreAppended: game?.myPlayerData?.score)
        gameOverviewViewControllerContainer.isHidden = false
        gameMenuViewControllerContainer.isHidden = true
    }
    func returnToGame() {
        gameMenuViewControllerContainer.isHidden = true
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let gameBarVC as GameBarViewController:
            gameBar = gameBarVC
        case let gameMenuVC as GameMenuViewController:
            gameMenuVC.delegate = self
            gameMenuViewController = gameMenuVC
        case let gameOverviewVC as GameOverviewViewController:
            gameOverviewVC.delegate = self
            gameOverviewViewController = gameOverviewVC
        default:
            break
        }
    }
}
