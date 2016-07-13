//
//  Ball.swift
//  OctGame
//
//  Created by zc on 16/7/12.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class Ball {
    var sprite: SKSpriteNode!
    var ballID: Int!
    let ballSize = CGSize(width: screenSize.width*0.133, height: screenSize.width*0.133)
    var isControl: Bool!
    init(ballKinds : BallCategory) {
        self.sprite = SKSpriteNode(imageNamed: ballKinds.imageName)
        self.sprite.name = ballKinds.name
        self.ballID = BallCategory.decode(ballKinds.name)?.rawValue
        self.sprite.size = ballSize
        self.sprite.zPosition = SpriteLevel.fightBall.rawValue
        self.isControl = true
    }
}