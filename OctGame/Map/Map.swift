//
//  Map.swift
//  OctGame
//
//  Created by zc on 16/6/21.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit
class Map: NSObject {
    var startPointX: CGFloat!
    var startPointY: CGFloat!
    var endPointX: CGFloat!
    var endPointY: CGFloat!
  //  var screenSize: CGSize!
    var path: CGMutablePath!
    init(startPoint: CGPoint, EndPoint endPoint: CGPoint) {
        super.init()
        self.startPointX = startPoint.x
        self.startPointY = startPoint.y
        self.endPointX = endPoint.x
        self.endPointY = endPoint.y
      //  self.screenSize = screenSize
        self.path = self.loadMap()
    }
    
    func loadMap() -> CGMutablePath {
        let screen = UIScreen.mainScreen().bounds
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, self.startPointX, self.startPointY)
        CGPathAddQuadCurveToPoint(path, nil, 500, screen.height-140, 400, screen.height-135)
        CGPathAddQuadCurveToPoint(path, nil, -50, 220, 500, 20)
        return path
       // CGPathAddCurveToPoint(path, nil, 180, 100, 330, 200, screen.width-100, 100)
    }
    
    func MoveWithPath(sheep: SKSpriteNode, speed velocity: NSTimeInterval) {
        
//        let screen = UIScreen.mainScreen().bounds
//        let path = CGPathCreateMutable()
//
//        CGPathMoveToPoint(path, nil, self.startPointX, self.startPointY)
//        CGPathAddQuadCurveToPoint(path, nil, 500, screen.height-140, 400, screen.height-150)
//        CGPathAddQuadCurveToPoint(path, nil, -50, 190, 500, 50)
        
        let changeBody = SKAction.scaleTo(7, duration: velocity)
        sheep.runAction(changeBody)
        let follow = SKAction.followPath(self.path, asOffset: false, orientToPath: false, duration: velocity)
        sheep.runAction(follow)
       // sheep.animation.state = AnimationState.walkLeft
       // sheep.sprite.runAction(SKAction.followPath(path, asOffset: false, orientToPath: false, duration: 3))
       // sheep.sprite.runAction(SKAction.repeatActionForever(SKAction.followPath(path, asOffset: false, orientToPath: false, duration: 3)))
        
    }
}
