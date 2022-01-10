//
//  TriviaAnswerButton.swift
//  tilQuiz
//
//  Created by Mador Til on 22/10/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import UIKit

class TriviaAnswerCard: UIButton, AnswerViewProtocol {
    
    var originalFrameOrigin: CGPoint? = nil
    
    var cardLeanRotation: cardLeanRotation = .right
    enum cardLeanRotation {
        case right
        case left
    }
    private var leanAngle: CGFloat {
        switch self.cardLeanRotation {
        case .right:
            return -CGFloat.pi/8
        case .left:
            return CGFloat.pi/8
        }
    }
    
    var inAnimationDuration: TimeInterval = Settings.shared.triviaInAnimationDuration
    var outAnimationDuration: TimeInterval = Settings.shared.triviaOutAnimationDuration
    var answerShownDelay: TimeInterval = Settings.shared.triviaAnswerShownDelay
    var answerColorChangeDuration: TimeInterval = Settings.shared.triviaAnswerColorChangeDuration
    
    
    func animateToOriginalPosition(animationCompleted: (() -> Void)? = nil) {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        UIView.animate(withDuration: inAnimationDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = .identity
            if let originalFrameOrigin = self.originalFrameOrigin {
                self.frame.origin = originalFrameOrigin
            }
            self.transform = self.transform.rotated(by: self.leanAngle)
        }) { complete in
            animationCompleted?()
        }
    }
}
