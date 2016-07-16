//
//  WallSystem.swift
//  OctGame
//
//  Created by zc on 16/7/15.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class WallSystem: SkillSystem {
    var currentWall: Wall!
    var wallID: UInt32!
   // var canSetWallMapCellIndexArray = [Int]()
    var wallArray: NSMutableArray!
    
    var defaluePosition: CGPoint?
    override init() {
        super.init()
        self.wallArray = NSMutableArray()
        self.wallID = 0
        self.touchPointArray = NSMutableArray()
        self.bollGroup = BallCategory.fireBall.rawValue + BallCategory.fireBall.rawValue + BallCategory.waterBall.rawValue
    }
    
    override func initSkill() {
        self.wallID = self.wallID+1
        let wallBitMask = BitMaskType.fire | BitMaskType.boom 
        let wall = Wall(entityName: self.entityName, collsionBitMask: wallBitMask, wallID: self.wallID)
        
        let player = (self.entity as! FightPlayer)
        if self.entityName == "fightEnemy" {
        //    boom.alpha = 0
            wall.wallSprite.position = CGPoint(x:player.fightMap.mapArray.objectAtIndex(0).position.x, y:player.fightMap.mapArray.objectAtIndex(0).position.y - fightMapCellSize.height)
            
        }else {
            wall.wallSprite.position = CGPoint(x:player.fightMap.mapArray.objectAtIndex(0).position.x, y:player.fightMap.mapArray.objectAtIndex(0).position.y + fightMapCellSize.height)
            
        }
        defaluePosition = wall.wallSprite.position
        player.sprite.parent?.addChild(wall.wallSprite)
        self.wallArray.addObject(wall)
        self.currentWall = wall
    }
    
    func isSetWallSuccess(point: CGPoint) -> Int? {
        let selfMap = (self.entity as! FightPlayer).fightMap
        
        for i in 0 ..< selfMap.mapArray.count {
            if (selfMap.mapArray.objectAtIndex(i) as! FTMapCell).obj == nil {
                if CGRectContainsPoint(selfMap.mapArray.objectAtIndex(i).frame, point) {
                    self.currentWall.wallSprite.position = selfMap.mapArray.objectAtIndex(i).position
                    return i
                }
            }
        }
        return nil
    }
    
    override func toucheBegan(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        let touchLocation = touches.first?.locationInNode(scene)
        self.touchPointArray.removeAllObjects()
        if self.currentWall != nil {
            if self.currentWall.isControl == true {
                let rect = CGRect(origin: CGPoint(x: self.currentWall.wallSprite.position.x-SkillSize.wall.width, y: self.currentWall.wallSprite.position.y-SkillSize.wall.height), size: CGSize(width: self.currentWall.wallSprite.frame.width*2, height: self.currentWall.wallSprite.frame.height*2))
                if CGRectContainsPoint(rect, touchLocation!) {
                    self.touchPointArray.addObject(NSValue.init(CGPoint: touchLocation!))
                }
            }
        }

    }
    
    override func toucheMoved(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        if self.touchPointArray.count != 0 {
            let point = (touches.first?.locationInNode(scene))!
            self.touchPointArray.addObject(NSValue.init(CGPoint: point))
            
            let oldPoint = (touches.first?.previousLocationInNode(scene))!
            let distance = CGPoint(x: point.x-oldPoint.x, y: point.y-oldPoint.y)

            let newPoint = CGPoint(x: self.currentWall.wallSprite.position.x+distance.x, y: self.currentWall.wallSprite.position.y+distance.y)

            self.currentWall.wallSprite.position = newPoint
  
        }
    }
    
    override func toucheEnded(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        if self.touchPointArray.count != 0 {
            let endPoint = (self.touchPointArray.lastObject!.CGPointValue)!
            let wallMapCellNum = isSetWallSuccess(endPoint)
            if wallMapCellNum != nil{
              //  self.currentWall.boomOnMapCellIndex = wallMapCellNum
                let selfMap = (self.entity as! FightPlayer).fightMap
                (selfMap.mapArray.objectAtIndex(wallMapCellNum!) as! FTMapCell).obj = self.currentWall
                self.currentWall.isControl = false
               // self.setBoom()
                
                
//                self.currentWall.wallSprite.physicsBody?.dynamic = true
                var dict = Dictionary<String, AnyObject>()
                dict.updateValue(SkillName.wall.rawValue, forKey: "initSkill")
                let percentX = self.currentWall.wallSprite.position.x / screenSize.width
                let percentY = self.currentWall.wallSprite.position.y / screenSize.height
                dict.updateValue(percentX, forKey: "percentX")
                dict.updateValue(percentY, forKey: "percentY")
                scene.websocket.writeMessage(BTMessage(command: BTCommand.CastSpell, params: (self.entity as! FightPlayer).toReleaseSkill(dict)))
                
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName("wallSetRight", object: self, userInfo: ["playerSelfWall" : self.currentWall])
                
                
                for temp in self.wallArray {
                    if (temp as! Wall).isControl == true {
                        self.currentWall = temp as! Wall
                    }
                }
            }else {
                self.currentWall.wallSprite.position = defaluePosition!
            }
        }
    }
    
//    override func didContact(contact: SKPhysicsContact) {
//        let nodeA = contact.bodyA
//        let nodeB = contact.bodyB
//        
//        if self.entityName == "fightPlayer" {
//            if nodeA.categoryBitMask == BitMaskType.ftWall {
//                let wall = nodeA.node?.userData?.objectForKey("wall") as! Wall
//                if nodeB.categoryBitMask == BitMaskType.fire {
//                    if wall.entityName == "fightPlayer" {
//                        if (nodeB.node as! Fire).entityName == "fightEnemy" {
//                            (nodeB.node as! Fire).isRemove = true
//                            (nodeB.node as! Fire).
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    override func checkState(time: NSTimeInterval) {
        let removeArray = NSMutableArray()
        
        for temp in self.wallArray {
            if (temp as! Wall).removeWall() == true {
                removeArray.addObject(temp)
            }
        }
        
        for removeTemp in removeArray {
            self.wallArray.removeObject(removeTemp)
        }
    }

}
