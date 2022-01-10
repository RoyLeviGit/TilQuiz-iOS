//
//  answerViewProtocol.swift
//  tilQuiz
//
//  Created by Mador Til on 07/11/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import Foundation
import UIKit

protocol AnswerViewProtocol {
    var originalFrameOrigin: CGPoint? { get set }
    var outAnimationDuration: TimeInterval { get }
    var inAnimationDuration: TimeInterval { get }
    var answerShownDelay: TimeInterval { get }
    var answerColorChangeDuration: TimeInterval { get }
    
    func animateToOriginalPosition(animationCompleted: (() -> Void)?)
    func animateCorrectAnswerPicked(animationCompleted: (() -> Void)?)
    func animateIncorrectAnswerPicked(animationCompleted: (() -> Void)?)
    
    func animateCorrectAnswer(animationCompleted: (() -> Void)?)
    func animateIncorrectAnswer(animationCompleted: (() -> Void)?)
}

extension AnswerViewProtocol where Self: UIView {
    func animateToOriginalPosition(animationCompleted: (() -> Void)? = nil) {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        UIView.animate(withDuration: inAnimationDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = .identity
            if let originalFrameOrigin = self.originalFrameOrigin {
                self.frame.origin = originalFrameOrigin
            }
        }) { complete in
            animationCompleted?()
        }
    }
    func animateCorrectAnswerPicked(animationCompleted: (() -> Void)? = nil) {
        UIView.animate(withDuration: outAnimationDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = .identity
            if self.window != nil {
                self.frame.origin.x = self.frame.origin.x + self.window!.frame.width
            }
        }) { complete in
            animationCompleted?()
        }
    }
    func animateIncorrectAnswerPicked(animationCompleted: (() -> Void)? = nil) {
        UIView.animate(withDuration: outAnimationDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = .identity
            if self.window != nil {
                self.frame.origin.x = self.frame.origin.x - self.window!.frame.width
            }
        }) { complete in
            animationCompleted?()
        }
    }
    
    func animateCorrectAnswer(animationCompleted: (() -> Void)? = nil) {
        UIView.animate(withDuration: answerColorChangeDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }) { complete in
            Timer.scheduledTimer(withTimeInterval: self.answerShownDelay, repeats: false) { timer in
                animationCompleted?()
            }
        }
    }
    func animateIncorrectAnswer(animationCompleted: (() -> Void)? = nil) {
        UIView.animate(withDuration: answerColorChangeDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.backgroundColor = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)
        }) { complete in
            Timer.scheduledTimer(withTimeInterval: self.answerShownDelay, repeats: false) { timer in
                animationCompleted?()
            }
        }
    }
}
