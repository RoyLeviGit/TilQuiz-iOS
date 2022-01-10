//
//  QuestionViewProtocol.swift
//  tilQuiz
//
//  Created by Mador Til on 26/02/2019.
//  Copyright © 2019 Yahav Levi. All rights reserved.
//

import Foundation
import UIKit

protocol QuestionViewProtocol {
    var animationDuration: TimeInterval { get }
    
    func animateIn(animationCompleted: (() -> Void)?)
    func animateOut(animationCompleted: (() -> Void)?)
}

extension QuestionViewProtocol where Self: UIView {
    func animateIn(animationCompleted: (() -> Void)? = nil) {
        if let window = self.window {
            transform = CGAffineTransform(translationX: -window.frame.width, y: 0)
        }
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            self.transform = .identity
        }) { _ in
            animationCompleted?()
        }
    }
    func animateOut(animationCompleted: (() -> Void)? = nil) {
        transform = .identity
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
            if let window = self.window {
                self.transform = CGAffineTransform(translationX: window.frame.width, y: 0)
            }
        }) { _ in
            animationCompleted?()
        }
    }
}
