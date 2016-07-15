//
//  FireSystem.swift
//  OctGame
//
//  Created by zc on 16/7/1.
//  Copyright © 2016年 oct. All rights reserved.
//


import SpriteKit
import UIKit

class FireSystem: SkillSystem {

    var huoqiuArray: NSMutableArray!
    var currentHuoqiu: Fire!
    var fireId: UInt32!
    var hitValue: Int = 1
    
    override init() {
        super.init()
        self.huoqiuArray = NSMutableArray()
        self.fireId = 0
        self.touchPointArray = NSMutableArray()
        self.bollGroup = BallCategory.fireBall.rawValue + BallCategory.electricBoll.rawValue + BallCategory.fireBall.rawValue
   
    }
    
    override func addSkillObserver() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(fireFollowPlayer), name: "playerMove", object: (self.entity as! FightPlayer))
    }
    
    @objc func fireFollowPlayer(note: NSNotification) {
//        let moveToPoint = note.userInfo!["moveToMapCell"]
//
//        
//        
//        
//        if moveToPoint!.position != (self.entity as! FightPlayer).sprite.position {
//            print("\(moveToPoint!.position)")
//            for temp in self.huoqiuArray {
//                if (temp as! Fire).isControl == true {
//                    // (temp as! Fire).position = (self.entity as! FightPlayer).sprite.position
//                    let move = SKAction.moveTo((moveToPoint?.position)!, duration: 0.3)
//                    (temp as! Fire).runAction(move)
//                }
//            }
//        }
        
        
        
        if let moveToPoint = note.userInfo?["moveToMapCell"] as? SKSpriteNode {
           // print(moveToPoint.position)
            
            if CommonFunc.fightIsEqualPoint(moveToPoint.position, pointB: (self.entity as! FightPlayer).sprite.position)  == false {
                for temp in self.huoqiuArray {
                    if (temp as! Fire).isControl == true {
                        // (temp as! Fire).position = (self.entity as! FightPlayer).sprite.position
                        let move = SKAction.moveTo(moveToPoint.position, duration: 0.3)
                        (temp as! Fire).runAction(move)
                    }
                }
            }

        }
        
        

    }
    
    override func initSkill() {
        self.fireId = self.fireId+1
        let fire = Fire(imageName: "huoqiu.jpg", size: SkillSize.huoqiu, entityName: self.entityName, collsionBitMask: ((self.entity as! FightPlayer).enemy.sprite.physicsBody?.categoryBitMask)!, fireID: "Fire\(self.fireId)")
        
        let tempSprite = (self.entity!.componentForClass(SpriteComponent.self)?.sprite)!
      //  let tempPosition = CGPoint(x: .position.x)!, y: <#T##CGFloat#>)
        fire.position = CGPoint(x: tempSprite.position.x, y: tempSprite.position.y)

        tempSprite.parent?.addChild(fire)
        self.huoqiuArray.addObject(fire)
        self.currentHuoqiu = fire
    }
    
//    func initHarmArea(harmArea: HarmArea) {
//        self.addHarmArea(harmArea)
//    }
    
    func throwSkill(speed: CGVector) {

        if self.currentHuoqiu.isControl == true {
            if speed != CGVector(dx: 0, dy: 0) {
                self.currentHuoqiu.dircspeed = speed
                self.currentHuoqiu.isControl = false
            }

        }
//        whoPlayer.currentHuoqiu = self.getCurrentTouchFire(whoPlayer)
//        whoPlayer.currentHuoqiu.dircspeed = speed
//        whoPlayer.currentHuoqiu.isControl = false
        for temp in huoqiuArray {
            if (temp as! Fire).isControl == true{
                self.currentHuoqiu = (temp as! Fire)
                break
            }
        }
        
    }
    
    override func reckonHarmArea(toHarmPlayer: FightPlayer, originalConterPoint: CGPoint) {
        for temp in self.harmAreas {
            temp.runHarmArea(toHarmPlayer, originalConterPoint: originalConterPoint, hitValue: self.hitValue)
        }

    }
    
    override func checkState(time: NSTimeInterval) {
//        for temp in self.huoqiuArray {
//            if (temp as! Fire).isControl == true {
//                (temp as! Fire).position = (self.entity as! FightPlayer).sprite.position
////                if (self.entity as! FightPlayer).yidong == true {
////                    let formatter = NSDateFormatter()
////                    formatter.dateFormat = "yyy-MM-dd HH:mm:ss:SSS"
////                    let date = formatter.stringFromDate(NSDate())
////                    print("---------\(date)")
////                }
//
//            }
//        }
//
        let removeArray = NSMutableArray()
        for temp in self.huoqiuArray  {
            if (temp as! Fire).removeFire() == true {
                removeArray.addObject(temp)
            }
        }
        
        for removeTemp in removeArray {
            self.huoqiuArray.removeObject(removeTemp)
        }
        

    
    }
    
    override func didContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA
        let nodeB = contact.bodyB
        if self.entityName == "fightPlayer" {
            if nodeA.categoryBitMask == BitMaskType.fire {
                let fire = nodeA.node as! Fire
                if nodeB.categoryBitMask == BitMaskType.fightEnemy {
                    if fire.entityName == "fightPlayer" {
                        fire.isRemove = true
                        self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: (self.entity as! FightPlayer).enemy.sprite.position)
                    }
                }
            }else if nodeB.categoryBitMask == BitMaskType.fire {
                let fire = nodeB.node as! Fire
                
                if nodeA.categoryBitMask == BitMaskType.fightEnemy {
                    if fire.entityName == "fightPlayer" {
                        fire.isRemove = true
                        self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: (self.entity as! FightPlayer).enemy.sprite.position)
                    }
                }

            }
        }else if self.entityName == "fightEnemy" {
            if nodeA.categoryBitMask == BitMaskType.fire {
                let fire = nodeA.node as! Fire
                if nodeB.categoryBitMask == BitMaskType.fightSelf {
                    if fire.entityName == "fightEnemy" {
                        fire.isRemove = true
                        self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: (self.entity as! FightPlayer).enemy.sprite.position)
                    }
                }
            }else if nodeB.categoryBitMask == BitMaskType.fire {
                let fire = nodeB.node as! Fire
                
                if nodeA.categoryBitMask == BitMaskType.fightSelf {
                    if fire.entityName == "fightEnemy" {
                        fire.isRemove = true
                        self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: (self.entity as! FightPlayer).enemy.sprite.position)
                    }
                }
                
            }
        }

    }
    
    override func toucheBegan(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        let touchLocation = touches.first?.locationInNode(scene)
        
        self.touchPointArray.removeAllObjects()
        if self.currentHuoqiu != nil {
            
            let rect = CGRect(origin: CGPoint(x: self.currentHuoqiu.position.x-SkillSize.huoqiu.width, y: self.currentHuoqiu.position.y-SkillSize.huoqiu.height), size: CGSize(width: self.currentHuoqiu.frame.width*2, height: self.currentHuoqiu.frame.height*2))
            if CGRectContainsPoint(rect, touchLocation!) {
                self.touchPointArray.addObject(NSValue.init(CGPoint: touchLocation!))
            }
            
        }

    }
    
    override func toucheMoved(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        if self.touchPointArray.count != 0 {
            let point = touches.first?.locationInNode(scene)
            self.touchPointArray.addObject(NSValue.init(CGPoint: point!))
        }
    }
    
    override func toucheEnded(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        if self.touchPointArray.count != 0 {
            let firstPoint = (self.touchPointArray.firstObject?.CGPointValue)!
            let endPoint = (self.touchPointArray.objectAtIndex(self.touchPointArray.count/2).CGPointValue)!
            let distance = CGVector(dx: endPoint.x-firstPoint.x, dy: endPoint.y-firstPoint.y)
            if distance != CGVector(dx: 0, dy: 0) {
                self.throwSkill(SkillSystem.reckonSkillSpeed(distance))
            }
            

            var dict = Dictionary<String, AnyObject>()
            dict.updateValue(SkillName.fire.rawValue, forKey: "initSkill")
            let percentX = SkillSystem.reckonSkillSpeed(distance).dx / screenSize.width
            let percentY = SkillSystem.reckonSkillSpeed(distance).dy / screenSize.height
            dict.updateValue(percentX, forKey: "percentX")
            dict.updateValue(percentY, forKey: "percentY")
            scene.websocket.writeMessage(BTMessage(command: BTCommand.CastSpell, params: (self.entity as! FightPlayer).toReleaseSkill(dict)))
            
            
        }

    }
    
}
