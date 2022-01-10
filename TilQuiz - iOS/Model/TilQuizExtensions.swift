//
//  Extensions.swift
//  tilQuiz
//
//  Created by Mador Til on 04/09/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict["v\(index)"] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict))
    }
    
    func addConstraintsFillEntireView(view: UIView) {
        addConstraintsWithFormat(format: "H:|[v0]|", views: view)
        addConstraintsWithFormat(format: "V:|[v0]|", views: view)
    }
    var screenSize: CGSize {
        return window?.screen.bounds.size ?? .zero
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [0, 30, -30, 30, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = 0.7
        animation.isAdditive = true
        layer.add(animation, forKey: "shake")
    }
}
extension UIViewController {
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
}
extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
    func setForAnimation(of animation: Animation) {
        var animationImages = [UIImage]()
        switch animation {
        case .singleplayer:
            for index in 1...42 {
                if let animationImage = UIImage(named: "SinglePlayerAnimation00\(index)") {
                    animationImages.append(animationImage)
                }
            }
            self.animationImages = animationImages
            animationDuration = 42/25
        case .playCube:
            for index in 1...54 {
                if let animationImage = UIImage(named: "play_cube00\(index)") {
                    animationImages.append(animationImage)
                }
            }
            self.animationImages = animationImages
            animationDuration = 54/24
        case .myScoreReview:
            for index in 1...41 {
                if let animationImage = UIImage(named: "my_score_review00\(index)") {
                    animationImages.append(animationImage)
                }
            }
            self.animationImages = animationImages
            animationDuration = 41/24
        }
    }
    
    enum Animation {
        case singleplayer
        case playCube
        case myScoreReview
    }
}

extension String {
    
    /// Validate email string
    ///
    /// - returns: A Boolean value indicating whether an email is valid
    func isValidEmail() -> Bool {
        let emailRegEx = """
            (?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}\
            ~-]+)*|"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\\
            x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*")@(?:(?:[a-z0-9](?:[a-\
            z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5\
            ]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-\
            9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\
            -\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])
            """
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    /// Validate password string
    ///
    /// - Returns: A Boolean value indicating whether a password is valid
    func isValidPassword() -> Bool {
        return self.count >= 6
    }
    /// Validate nickname string
    ///
    /// - Returns: A Boolean value indicating whether a nickname is valid
    func isValidNickname() -> Bool {
        return self.count >= 3
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(-self)))
        } else {
            return 0
        }
    }
}

extension Notification.Name {
    static var DatabaseFacadeSchemaLibrary: Notification.Name {
        return Notification.Name("DatabaseFacadeSchemaLibrary")
    }
    static var DatabaseFacadeTriviaQuestions: Notification.Name {
        return Notification.Name("DatabaseFacadeTriviaQuestions")
    }
    static var DatabaseFacadeCurrentGameSession: Notification.Name {
        return Notification.Name("DatabaseFacadeCurrentGameSession")
    }
    static var DatabaseFacadeOpponentGameSessionData: Notification.Name {
        return Notification.Name("DatabaseFacadeOpponentGameSessionData")
    }
    static var DatabaseFacadeGameSessions: Notification.Name {
        return Notification.Name("DatabaseFacadeGameSessions")
    }
    static var DatabaseFacadeScoreboard: Notification.Name {
        return Notification.Name("DatabaseFacadeScoreboard")
    }
    static var DatabaseFacadeMyScore: Notification.Name {
        return Notification.Name("DatabaseFacadeMyScore")
    }
}

extension Notification.Name {
    static var GameNextQuestionReady: Notification.Name {
        return Notification.Name("GameNextQuestionReady")
    }
    static var GameWaitinForOpponent: Notification.Name {
        return Notification.Name("GameWaitinForOpponent")
    }
    static var GameOutOfTime: Notification.Name {
        return Notification.Name("GameOutOfTime")
    }
    static var GameWaitingForPlayerToJoin: Notification.Name {
        return Notification.Name("GameWaitingForPlayerToJoin")
    }
    static var GameEnded: Notification.Name {
        return Notification.Name("GameEnded")
    }
    static var GameComplete: Notification.Name {
        return Notification.Name("GameComplete")
    }
    static var GameMyScoreUpdated: Notification.Name {
        return Notification.Name("GameMyScoreUpdated")
    }
    static var GameTimeElapsedUpdated: Notification.Name {
        return Notification.Name("GameTimeElapsedUpdated")
    }
    static var GameOpponentNameUpdated: Notification.Name {
        return Notification.Name("GameOpponentNameUpdated")
    }
    static var GameOpponentScoreUpdated: Notification.Name {
        return Notification.Name("GameOpponentScoreUpdated")
    }
    static var GameOpponentPresent: Notification.Name {
        return Notification.Name("GameOpponentPresent")
    }
}

enum GameError: Error {
    case noLibraryInitilizedByDatabase
}

extension TriviaQuestion.Topic {
    static func bubbleImage(for topicIndex: Int) -> UIImage {
        return bubbleImage(for: TriviaQuestion.Topic.allCases[topicIndex])
    }
    static func bubbleImage(for topic: TriviaQuestion.Topic) -> UIImage {
        switch topic {
        case .anatomy: return #imageLiteral(resourceName: "anatomy_bubble")
        case .cpr: return #imageLiteral(resourceName: "cpr_bubble")
        case .routine: return #imageLiteral(resourceName: "routine_bubble")
        case .medicine: return #imageLiteral(resourceName: "medicine_bubble")
        case .teamWork: return #imageLiteral(resourceName: "medicine_bubble")
        case .anamnesis: return #imageLiteral(resourceName: "anamnesis_bubble")
        case .trauma: return #imageLiteral(resourceName: "trauma_bubble")
        case .mentalHealth: return #imageLiteral(resourceName: "mental_health_bubble")
        case .publicHealth: return #imageLiteral(resourceName: "public_health_bubble")
        case .nbc: return #imageLiteral(resourceName: "nbc_bubble")
        }
    }
    static func title(for topicIndex: Int) -> String {
        switch topicIndex {
        case 0: return "אנטומיה"
        case 1: return "החייאה"
        case 2: return "שגרה"
        case 3: return "רפואה"
        case 4: return "עבודה בצוות"
        case 5: return "אנמנזה"
        case 6: return "טראומה"
        case 7: return "ברה״ן"
        case 8: return "ברה״צ"
        case 9: return "אב״כ"
        default: return "Non Existent Topic"
        }
    }
}
