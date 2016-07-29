//
//  FireSystem.swift
//  OctGame
//
//  Created by zc on 16/7/1.
//  Copyright © 2016年 oct. All rights reserved.
//


import SpriteKit
import UIKit

class FireSystem: SkillSystem,AttackProtocal, NoSaveSkillProtocal {

    var huoqiuArray: NSMutableArray!
    var noLaunchHuoqiu: Fire?
    var fireId: UInt32!
    var hitValue: Int = 5

    override init() {
        super.init()
        self.huoqiuArray = NSMutableArray()
        self.fireId = 0
        self.touchPointArray = NSMutableArray()
        self.bollGroup = BallCategory.gongji.rawValue + BallCategory.fuzhu.rawValue + BallCategory.gongji.rawValue
        self.isSilent = false
    }
    
    override func addSkillObserver() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(fireFollowPlayer), name: "playerMove", object: (self.entity as! FightPlayer))
    }
    
    @objc func fireFollowPlayer(note: NSNotification) {

        if let moveToPoint = note.userInfo?["moveToMapCell"] as? SKSpriteNode {
           // print(moveToPoint.position)
            
            if CommonFunc.fightIsEqualPoint(moveToPoint.position, pointB: (self.entity as! FightPlayer).sprite.position)  == false {
//                for temp in self.huoqiuArray {
//                    if (temp as! Fire).isControl == true {
//                        // (temp as! Fire).position = (self.entity as! FightPlayer).sprite.position
//                        let move = SKAction.moveTo(moveToPoint.position, duration: 0.3)
//                        (temp as! Fire).runAction(move)
//                    }
//                }
                if self.noLaunchHuoqiu?.isControl == true {
                    let move = SKAction.moveTo(moveToPoint.position, duration: 0.3)
                    self.noLaunchHuoqiu!.runAction(move)
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
       // self.huoqiuArray.addObject(fire)
        if self.noLaunchHuoqiu != nil {
            self.noLaunchHuoqiu?.removeFromParent()
        }
        self.noLaunchHuoqiu = fire
    }
    

    
    func throwSkill(speed: CGVector) {

        if self.noLaunchHuoqiu!.isControl == true {
            if speed != CGVector(dx: 0, dy: 0) {
                self.noLaunchHuoqiu!.dircspeed = speed
                self.noLaunchHuoqiu!.isControl = false
                self.huoqiuArray.addObject(self.noLaunchHuoqiu!)
                self.noLaunchHuoqiu = nil
            }

        }

    }
    
    func removeSkillItem() {
        if self.noLaunchHuoqiu != nil {
            if self.noLaunchHuoqiu?.isControl == true {
                self.noLaunchHuoqiu?.removeFromParent()
                self.noLaunchHuoqiu = nil
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
                
                if nodeB.categoryBitMask == BitMaskType.ftWall {
                    let wall = nodeB.node?.userData?.objectForKey("wallclass") as! Wall
                    if fire.entityName == "fightPlayer" {
                        if wall.entityName == "fightEnemy" {
                            fire.isRemove = true
                            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: wall.buildSprite.position)
                        }
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
                
                if nodeA.categoryBitMask == BitMaskType.ftWall {

                    let wall = nodeA.node?.userData?.objectForKey("wallclass")
                    if fire.entityName == "fightPlayer" {
                        if (wall as! Wall).entityName == "fightEnemy" {
                            fire.isRemove = true
                            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: (wall as! Wall).buildSprite.position)
                        }
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
                
                if nodeB.categoryBitMask == BitMaskType.ftWall {
                    let wall = nodeB.node?.userData?.objectForKey("wallclass") as! Wall
                    if fire.entityName == "fightEnemy" {
                        if wall.entityName == "fightPlayer" {
                            fire.isRemove = true
                            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: wall.buildSprite.position)
                        }
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
                
                if nodeA.categoryBitMask == BitMaskType.ftWall {
                    let wall = nodeA.node?.userData?.objectForKey("wallclass") as! Wall
                    if fire.entityName == "fightEnemy" {
                        if wall.entityName == "fightPlayer" {
                            fire.isRemove = true
                            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: wall.buildSprite.position)
                        }
                    }
                }
                
            }
        }

    }
    
    override func toucheBegan(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        let touchLocation = touches.first?.locationInNode(scene)
        
        self.touchPointArray.removeAllObjects()
        if self.noLaunchHuoqiu != nil {
            
            let rect = CGRect(origin: CGPoint(x: self.noLaunchHuoqiu!.position.x-SkillSize.huoqiu.width, y: self.noLaunchHuoqiu!.position.y-SkillSize.huoqiu.height), size: CGSize(width: self.noLaunchHuoqiu!.frame.width*2, height: self.noLaunchHuoqiu!.frame.height*2))
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
            if self.isSilent == false {
                let firstPoint = (self.noLaunchHuoqiu?.position)!
                let endPoint = (self.touchPointArray.objectAtIndex(self.touchPointArray.count/2).CGPointValue)!
                let distance = CGVector(dx: endPoint.x-firstPoint.x, dy: endPoint.y-firstPoint.y)
                if distance != CGVector(dx: 0, dy: 0) {
                    self.throwSkill(SkillSystem.reckonSkillSpeed(distance, skillSpeed: FightSkillSpeed.huoqiu))
                }
                
                var dict = [String: AnyObject]()
                dict.updateValue(SkillName.fire.rawValue, forKey: "initSkill")
                let percentX = SkillSystem.reckonSkillSpeed(distance, skillSpeed: FightSkillSpeed.huoqiu).dx / screenSize.width
                let percentY = SkillSystem.reckonSkillSpeed(distance, skillSpeed: FightSkillSpeed.huoqiu).dy / screenSize.height
                dict.updateValue(percentX, forKey: "percentX")
                dict.updateValue(percentY, forKey: "percentY")
                // scene.websocket.writeMessage(BTMessage(command: BTCommand.CCastSpell, params: (self.entity as! FightPlayer).toReleaseSkill(dict)))
                scene.sock.send(BTCommand.CCastSpell, withParams: (self.entity as! FightPlayer).toReleaseSkill(dict))
//                for i in 0 ..< self.touchPointArray.count {
//                    print("\(i)-----\(self.touchPointArray.objectAtIndex(i).CGPointValue)")
//                }
            }
        }
    }
    
}
