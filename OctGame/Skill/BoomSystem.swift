//
//  BoomSystem.swift
//  OctGame
//
//  Created by zc on 16/7/9.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class BoomSystem: SkillSystem {
    
    var boomArray: NSMutableArray!
    var currentBoom: Boom!
    var boomID: UInt32!
    var defaluePosition: CGPoint?
    var hitValue: Int = 3
//    var bogusBoom: SKSpriteNode!
    override init() {
        super.init()
        self.boomArray = NSMutableArray()
        self.boomID = 0
        self.touchPointArray = NSMutableArray()
        self.bollGroup = BallCategory.fireBall.rawValue + BallCategory.waterBall.rawValue + BallCategory.electricBoll.rawValue
    }
    
    override func initSkill() {
        self.boomID = self.boomID+1
        let boom = Boom(imageName: "boom.png", size: SkillSize.dilei, entityName: self.entityName, collsionBitMask: ((self.entity as! FightPlayer).enemy.sprite.physicsBody?.categoryBitMask)!, BoomID: "Boom\(self.boomID)")
        let player = (self.entity as! FightPlayer)
        

        if self.entityName == "fightEnemy" {
            boom.alpha = 0
            boom.position = CGPoint(x:player.fightMap.mapArray.objectAtIndex(0).position.x, y:player.fightMap.mapArray.objectAtIndex(0).position.y - fightMapCellSize.height)
            
        }else {
            boom.position = CGPoint(x:player.fightMap.mapArray.objectAtIndex(0).position.x, y:player.fightMap.mapArray.objectAtIndex(0).position.y + fightMapCellSize.height)
            
        }
        defaluePosition = boom.position
        player.sprite.parent?.addChild(boom)
        self.boomArray.addObject(boom)
        self.currentBoom = boom
    }
    
    func setBoom() {
        let xiaoshi = SKAction.fadeAlphaTo(0.3, duration: 0.4)
        let block = SKAction.runBlock { 
            self.bogusBoomRun({ 
                
            })
        }
        self.currentBoom.runAction(SKAction.sequence([xiaoshi,block]))
       // print("set boom")
        
        for temp in self.boomArray {
            if (temp as! Boom).isControl == true {
                self.currentBoom = temp as! Boom
            }
        }
        
    }
    func bogusBoomRun(finish: ()->()) {
        let bogusBoom = SKSpriteNode(imageNamed: "boom.png")
        bogusBoom.size = SkillSize.dilei
        bogusBoom.position = defaluePosition!
        bogusBoom.zPosition = SpriteLevel.sprite.rawValue
        (self.entity as! FightPlayer).sprite.parent?.addChild(bogusBoom)
        let turnPoint1 = (self.entity as! FightPlayer).enemy.fightMap.mapArray.objectAtIndex(17)
        let turnPoint2 = (self.entity as! FightPlayer).enemy.fightMap.mapArray.objectAtIndex(5)
        let turnPoint3 = (self.entity as! FightPlayer).enemy.fightMap.mapArray.objectAtIndex(6)
        let turnPoint4 = (self.entity as! FightPlayer).enemy.fightMap.mapArray.objectAtIndex(14)
        let turnPoint5 = (self.entity as! FightPlayer).enemy.fightMap.mapArray.objectAtIndex(15)
        let turnPoint6 = (self.entity as! FightPlayer).enemy.fightMap.mapArray.objectAtIndex(7)
        var turnPoint7: CGPoint!
    
        if self.entityName == "fightPlayer" {
            turnPoint7 = CGPoint(x: turnPoint6.position.x, y: screenSize.height-10)
        }else  if self.entityName == "fightEnemy" {
            turnPoint7 = CGPoint(x: turnPoint6.position.x, y: 10)
        }
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, bogusBoom.position.x, bogusBoom.position.y)
        CGPathAddLineToPoint(path, nil, turnPoint1.position.x, turnPoint1.position.y)
        CGPathAddLineToPoint(path, nil, turnPoint2.position.x, turnPoint2.position.y)
        CGPathAddLineToPoint(path, nil, turnPoint3.position.x, turnPoint3.position.y)
        CGPathAddLineToPoint(path, nil, turnPoint4.position.x, turnPoint4.position.y)
        CGPathAddLineToPoint(path, nil, turnPoint5.position.x, turnPoint5.position.y)
        CGPathAddLineToPoint(path, nil, turnPoint6.position.x, turnPoint6.position.y)
        CGPathAddLineToPoint(path, nil, turnPoint7.x, turnPoint7.y)
        let follow = SKAction.followPath(path, asOffset: false, orientToPath: false, duration: 5)
        let block = SKAction.runBlock {
//            print("yichu-----jiadilei")
            bogusBoom.removeFromParent()
            finish()
        }
        bogusBoom.runAction(SKAction.sequence([follow,block]))
    }
    func isSetBoomSuccess(point: CGPoint) -> Int? {
        let enemyMap = (self.entity as! FightPlayer).enemy.fightMap
        for i in 0 ..< enemyMap.mapArray.count {
            if i >= 5 && i <= 15 && i != 8 && i != 12 && i != enemyMap.getCurrentPointMapCell((self.entity as! FightPlayer).enemy.sprite.position) {
                if CGRectContainsPoint(enemyMap.mapArray.objectAtIndex(i).frame, point) {
                    self.currentBoom.position = enemyMap.mapArray.objectAtIndex(i).position
                    return i
                }
            }
        }
        return nil
    }
    override func toucheBegan(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        let touchLocation = touches.first?.locationInNode(scene)
        self.touchPointArray.removeAllObjects()
        if self.currentBoom != nil {
            if self.currentBoom.isControl == true {
                 let rect = CGRect(origin: CGPoint(x: self.currentBoom.position.x-SkillSize.dilei.width, y: self.currentBoom.position.y-SkillSize.dilei.height), size: CGSize(width: self.currentBoom.frame.width*2, height: self.currentBoom.frame.height*2))
                if CGRectContainsPoint(rect, touchLocation!) {
                    self.touchPointArray.addObject(NSValue.init(CGPoint: touchLocation!))
 
                }
            }
        }

    }
    
    override func toucheMoved(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        if self.currentBoom != nil {
            if self.currentBoom.isControl == true {
                if self.touchPointArray.count != 0 {
                    let point = (touches.first?.locationInNode(scene))!
                    self.touchPointArray.addObject(NSValue.init(CGPoint: point))
                    
                    let oldPoint = (touches.first?.previousLocationInNode(scene))!
                    let distance = CGPoint(x: point.x-oldPoint.x, y: point.y-oldPoint.y)
                    //   let rect = CGRect(origin: self.currentBoom.frame.origin, size: CGSize(width: 80, height: 80))
                    // if CGRectContainsPoint(rect, point) {
                    let newPoint = CGPoint(x: self.currentBoom.position.x+distance.x, y: self.currentBoom.position.y+distance.y)
                    //                if CGRectContainsRect(CGRectMake(0, 0, screenSize.width, screenSize.height), self.newRectWithObj(SkillSize.dilei, point: newPoint)) {
                    self.currentBoom.position = newPoint
                    //   }
                    //  }
                }
            }

        }
    }
    
    override func toucheEnded(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        if self.touchPointArray.count != 0 {
            let endPoint = (self.touchPointArray.lastObject!.CGPointValue)!
            let boomMapCellNum = isSetBoomSuccess(endPoint)
            if boomMapCellNum != nil{
                self.currentBoom.boomOnMapCellIndex = boomMapCellNum
                self.currentBoom.isControl = false
                self.currentBoom.physicsBody?.dynamic = true
                self.setBoom()
                var dict = Dictionary<String, AnyObject>()
                dict.updateValue(SkillName.boom.rawValue, forKey: "initSkill")
                let percentX = self.currentBoom.position.x / screenSize.width
                let percentY = self.currentBoom.position.y / screenSize.height
                dict.updateValue(percentX, forKey: "percentX")
                dict.updateValue(percentY, forKey: "percentY")
                scene.websocket.writeMessage(BTMessage(command: BTCommand.CastSpell, params: (self.entity as! FightPlayer).toReleaseSkill(dict)))
            }else {
                self.currentBoom.position = defaluePosition!
            }
        }
      //  print("move end")

    }
    
    func newRectWithObj(size:CGSize,point:CGPoint)->CGRect {
        return CGRectMake(point.x-size.width/2,point.y-size.height/2,size.width,size.height);
    }
    
    override func reckonHarmArea(toHarmPlayer: FightPlayer, originalConterPoint: CGPoint) {
        for temp in self.harmAreas {
            temp.runHarmArea(toHarmPlayer, originalConterPoint: originalConterPoint, hitValue: self.hitValue)
        }
    }
    
    override func didContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA
        let nodeB = contact.bodyB
        //自己监测 自己的地雷与敌人的碰撞  敌人监测 敌人的地雷与我碰撞
        if self.entityName == "fightPlayer" {
            if nodeA.categoryBitMask == BitMaskType.boom {
                let boom = nodeA.node as! Boom
                if nodeB.categoryBitMask == BitMaskType.fightEnemy {
                    if boom.entityName == "fightPlayer" {
                        if boom.isControl == false {
                            boom.isRemove = true
                            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: boom.position)
                        }

                    }
                }
                
                if nodeB.categoryBitMask == BitMaskType.ftWall {
                    let wall = nodeB.node?.userData?.objectForKey("wallclass") as! Wall
                    if boom.entityName == "fightPlayer" {
                        if wall.entityName == "fightEnemy" {
                            if wall.isControl == false {
                                boom.isRemove = true
                                self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: wall.wallSprite.position)
                            }
                            
                        }
                    }
                }

            }else if nodeB.categoryBitMask == BitMaskType.boom {
                let boom = nodeB.node as! Boom
                if nodeA.categoryBitMask == BitMaskType.fightEnemy {
                    if boom.entityName == "fightPlayer" {
                        if boom.isControl == false {
                            boom.isRemove = true
                            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: boom.position)
                        }
                    }
                }
                
                if nodeA.categoryBitMask == BitMaskType.ftWall {
                    
                    let wall = nodeA.node?.userData?.objectForKey("wallclass") as! Wall
                    if boom.entityName == "fightPlayer" {
                        if wall.entityName == "fightEnemy" {
                            if wall.isControl == false {
                                boom.isRemove = true
                                self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: wall.wallSprite.position)
                            }

                        }
                    }
                }

            }
        }else if self.entityName == "fightEnemy" {
            if nodeA.categoryBitMask == BitMaskType.boom {
                let boom = nodeA.node as! Boom
                if nodeB.categoryBitMask == BitMaskType.fightSelf {
                    if boom.entityName == "fightEnemy" {
                        if boom.isControl == false {
                            boom.isRemove = true
                            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: boom.position)
                        }
                    }
                }
                
                if nodeB.categoryBitMask == BitMaskType.ftWall {
                    let wall = nodeB.node?.userData?.objectForKey("wallclass") as! Wall
                    if boom.entityName == "fightEnemy" {
                        if wall.entityName == "fightPlayer" {
                            if wall.isControl == false {
                                boom.isRemove = true
                                self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: wall.wallSprite.position)
                            }

                        }
                    }
                }
            }else if nodeB.categoryBitMask == BitMaskType.boom {
                let boom = nodeB.node as! Boom
                if nodeA.categoryBitMask == BitMaskType.fightSelf {
                    if boom.entityName == "fightEnemy" {
                        if boom.isControl == false {
                            boom.isRemove = true
                            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: boom.position)
                        }
                    }
                }
                
                if nodeA.categoryBitMask == BitMaskType.ftWall {
                    let wall = nodeA.node?.userData?.objectForKey("wallclass") as! Wall
                    if boom.entityName == "fightEnemy" {
                        if wall.entityName == "fightPlayer" {
                            if wall.isControl == false {
                                boom.isRemove = true
                                self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: wall.wallSprite.position)
                            }

                        }
                    }
                }

            }
        }
    }
    
    override func addSkillObserver() {
        if self.entityName == "fightEnemy" {
            let nc = NSNotificationCenter.defaultCenter()
            nc.addObserver(self, selector: #selector(boomContactWall), name: "wallSetRight", object: (self.entity as! FightPlayer).enemy)
        }
    }
    @objc func boomContactWall(note: NSNotification) {
        if let wall = note.userInfo?["playerSelfWall"] as? Wall {
            for tempBoom in self.boomArray {
                if (tempBoom as! Boom).isControl == false {
                    if CommonFunc.fightIsEqualPoint((tempBoom as! Boom).position, pointB: wall.wallSprite.position) == true {
                        (tempBoom as! Boom).isRemove = true
                        self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: wall.wallSprite.position)
                    }
                }
            }
        }

    }
    override func checkState(time: NSTimeInterval) {
        let removeArray = NSMutableArray()
        
        for temp in self.boomArray {
            if (temp as! Boom).removeBoom() == true {
                removeArray.addObject(temp)
            }
        }
        
        for removeTemp in removeArray {
            self.boomArray.removeObject(removeTemp)
        }
    }
}


