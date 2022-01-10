//
//  OpenGameTableViewCell.swift
//  tilQuiz
//
//  Created by Mador Til on 20/02/2019.
//  Copyright © 2019 Yahav Levi. All rights reserved.
//

import UIKit

class OpenGameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameTypeImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    
    func setup(from gameSession: GameSession) {
        xOffset = CGFloat(0)
        descriptionScrollView.subviews.forEach { $0.removeFromSuperview() }
        
        displayNameLabel.text = gameSession.creatorData.name
        
        switch gameSession.gameType {
        case .trivia:
            gameTypeImageView.image = #imageLiteral(resourceName: "trivia_on")
            if let topics = gameSession.topics {
                topics.forEach { addBubbleToDescriptionScrollView(image: TriviaQuestion.Topic.bubbleImage(for: $0)) }
            }
        case .schema:
            gameTypeImageView.image = #imageLiteral(resourceName: "schema_on")
            if let usingSubLibraries = gameSession.usingSubLibraries {
                for index in usingSubLibraries.indices {
                    if usingSubLibraries[index] { addBubbleToDescriptionScrollView(image: SchemaLibrary.bubbleImage(for: index)) }
                }
            }
        }
    }
    
    let imageSize = CGSize(width: CGFloat(48), height: CGFloat(48))
    var xOffset = CGFloat(0)
    private func addBubbleToDescriptionScrollView(image: UIImage) {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: xOffset, y: 0), size: imageSize))
        xOffset += CGFloat(50)
        imageView.image = image
        descriptionScrollView.contentSize = CGSize(width: xOffset, height: CGFloat(48))
        descriptionScrollView.addSubview(imageView)
    }
}
