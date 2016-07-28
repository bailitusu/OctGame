//
//  JianTower.swift
//  OctGame
//
//  Created by zc on 16/7/25.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class JianTowerSystem: SkillSystem {
    var currentJianTower: JianTower!
    var towerID: UInt32!
    var towerArray: NSMutableArray!
    var defaluePosition: CGPoint?
    var hitValue: Int = 1
    override init() {
        super.init()
        self.towerArray = NSMutableArray()
        self.towerID = 0
        self.touchPointArray = NSMutableArray()
        self.bollGroup = BallCategory.jianzhu.rawValue + BallCategory.jianzhu.rawValue + BallCategory.gongji.rawValue
        self.isSilent = false
    }
    
    override func initSkill() {
        self.towerID = self.towerID + 1
        let towerBitMask = BitMaskType.fire | BitMaskType.boom | BitMaskType.bullet
        let tower = JianTower(entityName: self.entityName, collsionBitMask: towerBitMask, buildID: self.towerID)
        let player = (self.entity as! FightPlayer)
//        if player.roleName == "fightEnemy" {
//            //    boom.alpha = 0
//            tower.buildSprite.position = CGPoint(x:player.fightMap.mapArray.objectAtIndex(0).position.x, y:player.fightMap.mapArray.objectAtIndex(0).position.y - fightMapCellSize.height)
//            
//        }else {
//            tower.buildSprite.position = CGPoint(x:player.fightMap.mapArray.objectAtIndex(0).position.x, y:player.fightMap.mapArray.objectAtIndex(0).position.y + fightMapCellSize.height)
//            
//        }
        if player.roleName == "fightPlayer" {
             (self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray.append(tower)
            player.scene!.saveSkill.showCurrentSaveSkill()
            defaluePosition = tower.buildSprite.position
            player.sprite.parent?.addChild(tower.buildSprite)
        }

        self.towerArray.addObject(tower)
        self.currentJianTower = tower
    }
    
    func isSetTowerSuccess(point: CGPoint) -> Int? {
        let selfMap = (self.entity as! FightPlayer).fightMap
        for i in 0 ..< selfMap.mapArray.count {
            if ((selfMap.mapArray.objectAtIndex(i) as! FTMapCell).obj == nil || ((selfMap.mapArray.objectAtIndex(i) as! FTMapCell).obj as? Boom) != nil) {
                if CGRectContainsPoint(selfMap.mapArray.objectAtIndex(i).frame, point) {
                    self.currentJianTower.buildSprite.position = selfMap.mapArray.objectAtIndex(i).position
                    return i
                }
            }
        }
        return nil
    }
    
    override func toucheBegan(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        let touchLocation = touches.first?.locationInNode(scene)
        self.touchPointArray.removeAllObjects()
        for temp in self.towerArray {
            if (temp as! JianTower).isControl == true {
//                let rect = CGRect(origin: CGPoint(x: (temp as! JianTower).buildSprite.position.x-SkillSize.building.width, y: (temp as! JianTower).buildSprite.position.y-SkillSize.building.height), size: CGSize(width: (temp as! JianTower).buildSprite.frame.width*2, height: (temp as! JianTower).buildSprite.frame.height*2))
                if CGRectContainsPoint((temp as! JianTower).buildSprite.frame, touchLocation!) {
                    self.touchPointArray.addObject(NSValue.init(CGPoint: touchLocation!))
                    self.currentJianTower = temp as! JianTower
                    self.defaluePosition = self.currentJianTower.skillPosition
                }
                
            }
        }
        
//        if self.currentJianTower != nil {
//            if self.currentJianTower.isControl == true {
//                let rect = CGRect(origin: CGPoint(x: self.currentJianTower.buildSprite.position.x-SkillSize.building.width, y: self.currentJianTower.buildSprite.position.y-SkillSize.building.height), size: CGSize(width: self.currentJianTower.buildSprite.frame.width*2, height: self.currentJianTower.buildSprite.frame.height*2))
//                if CGRectContainsPoint(rect, touchLocation!) {
//                    self.touchPointArray.addObject(NSValue.init(CGPoint: touchLocation!))
//                }
//            }
//        }
    }
    
    override func toucheMoved(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        if self.touchPointArray.count != 0 {
            let point = (touches.first?.locationInNode(scene))!
            self.touchPointArray.addObject(NSValue.init(CGPoint: point))
            
            let oldPoint = (touches.first?.previousLocationInNode(scene))!
            let distance = CGPoint(x: point.x-oldPoint.x, y: point.y-oldPoint.y)
            
            let newPoint = CGPoint(x: self.currentJianTower.buildSprite.position.x+distance.x, y: self.currentJianTower.buildSprite.position.y+distance.y)
            
            self.currentJianTower.buildSprite.position = newPoint
            
        }
    }
    
    override func toucheEnded(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        if self.touchPointArray.count != 0 {
            let endPoint = (self.touchPointArray.lastObject!.CGPointValue)!
            var towerMapCellNum: Int? = nil
            if self.isSilent == false {
                towerMapCellNum = isSetTowerSuccess(endPoint)
            }
            
            if towerMapCellNum != nil{
               
                let selfMap = (self.entity as! FightPlayer).fightMap
                (selfMap.mapArray.objectAtIndex(towerMapCellNum!) as! FTMapCell).obj = self.currentJianTower
                self.currentJianTower.isControl = false

                var dict = [String: AnyObject]()
                dict.updateValue(SkillName.tower.rawValue, forKey: "initSkill")
                let percentX = self.currentJianTower.buildSprite.position.x / screenSize.width
                let percentY = (self.currentJianTower.buildSprite.position.y-fightMapCellSize.height) / screenSize.height
                dict.updateValue(percentX, forKey: "percentX")
                dict.updateValue(percentY, forKey: "percentY")
                self.shootCloseRange(self.currentJianTower, scene: scene)
                //    scene.websocket.writeMessage(BTMessage(command: BTCommand.CCastSpell, params: (self.entity as! FightPlayer).toReleaseSkill(dict)))
                scene.sock.send(BTCommand.CCastSpell, withParams: (self.entity as! FightPlayer).toReleaseSkill(dict))
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName("jiantaSetRight", object: self, userInfo: ["playerSelfJianta" : self.currentJianTower])//用于tower和dilei的碰撞
                
                var removeObjNum = 0
                for i in 0 ..< ((self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray)!.count {
                    if let tower = ((self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray)![i] as? JianTower {
                        if tower.buildID == self.currentJianTower.buildID {
                            removeObjNum = i
                        }
                    }
                }
                (self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray.removeAtIndex(removeObjNum)
            }else {
                self.currentJianTower.buildSprite.position = defaluePosition!
            }
        }
    }

    func shootCloseRange(tower: JianTower, scene: FightScene) {
        let wait = SKAction.waitForDuration(0.5)
        let block = SKAction.runBlock { 
            let zidan = tower.createZidan()
            if self.entityName == "fightEnemy"{
                zidan.position = CGPoint(x: tower.buildSprite.position.x, y: tower.buildSprite.position.y-tower.buildSprite.size.height/2-12)
            }else {
                zidan.position = CGPoint(x: tower.buildSprite.position.x, y: tower.buildSprite.position.y+tower.buildSprite.size.height/2+12)
            }
            scene.addChild(zidan)
            zidan.physicsBody?.velocity = SkillSystem.reckonSkillSpeed(self.getCloseMubiao(zidan), skillSpeed: FightSkillSpeed.bullet)
          //  tempPlayer.mapArray.objectAtIndex(tempPlayer.getCurrentPointMapCell(<#T##currentPoint: CGPoint##CGPoint#>))
        }
        tower.buildSprite.runAction(SKAction.repeatActionForever(SKAction.sequence([wait,block])),withKey: "zidan")
    }
    
    func getCloseMubiao(zidan: SKSpriteNode) -> CGVector {
        let tempPlayer = (self.entity as! FightPlayer).enemy.fightMap
        var minDistance: CGVector = CGVector(dx: screenSize.width, dy: screenSize.height)
        for temp in tempPlayer.mapArray {
            if (temp as! FTMapCell).obj != nil && ((temp as! FTMapCell).obj as? Boom) == nil {
                let distance = ((temp as! FTMapCell).position.x-zidan.position.x)*((temp as! FTMapCell).position.x-zidan.position.x) + ((temp as! FTMapCell).position.y-zidan.position.y)*((temp as! FTMapCell).position.y-zidan.position.y)
                if distance < (minDistance.dx * minDistance.dx + minDistance.dy * minDistance.dy) {
                    minDistance = CGVector(dx: ((temp as! FTMapCell).position.x-zidan.position.x), dy: ((temp as! FTMapCell).position.y-zidan.position.y))
                    
                }
            }
        }
        return minDistance
    }
    
    override func checkState(time: NSTimeInterval) {
        let removeArray = NSMutableArray()
        
        for temp in self.towerArray {
            if (temp as! JianTower).removeTower() == true {
                removeArray.addObject(temp)
                let tempMap = (self.entity as! FightPlayer).fightMap
                (tempMap.mapArray.objectAtIndex(tempMap.getCurrentPointMapCell((temp as! JianTower).buildSprite.position)!) as! FTMapCell).obj = nil
                
            }
            
            if (temp as! JianTower).isControl == true {
                if (temp as! JianTower).isRemove == true {
                    (temp as! JianTower).buildSprite.removeFromParent()
                    removeArray.addObject(temp)
                }
            }
        }
        
        for removeTemp in removeArray {
            self.towerArray.removeObject(removeTemp)
        }
    }
    
    override func didContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA
        let nodeB = contact.bodyB
        if self.entityName == "fightPlayer" {
            var bullet: SKSpriteNode?
            var other: SKSpriteNode?
        
            if nodeA.categoryBitMask == BitMaskType.bullet {
                bullet = nodeA.node as? SKSpriteNode
                other = nodeB.node as? SKSpriteNode
            } else if nodeB.categoryBitMask == BitMaskType.bullet {
                bullet = nodeB.node as? SKSpriteNode
                other = nodeA.node as? SKSpriteNode
            }
        
            var isContact = false
            
            if bullet?.name == "fightPlayer" {
                
                if let tower = other?.userData?.objectForKey("towerclass") as? JianTower {
  
                    if tower.entityName == "fightEnemy" {

                        isContact = true
                    }
                } else if let wall = other?.userData?.objectForKey("wallclass") as? Wall {
                    if wall.entityName == "fightEnemy" {
                        
                        isContact = true

                    }
                } else if other?.physicsBody!.categoryBitMask == BitMaskType.fightEnemy {

                    isContact = true
                }
                if isContact {
                    if other != nil {
                        bullet?.removeFromParent()
                        self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: other!.position)
                    }
                }
  
            }
        }else if self.entityName == "fightEnemy" {
                var bullet: SKSpriteNode?
                var other: SKSpriteNode?
                
                if nodeA.categoryBitMask == BitMaskType.bullet {
                    bullet = nodeA.node as? SKSpriteNode
                    other = nodeB.node as? SKSpriteNode
                } else if nodeB.categoryBitMask == BitMaskType.bullet {
                    bullet = nodeB.node as? SKSpriteNode
                    other = nodeA.node as? SKSpriteNode
                }
                
                var isContact = false
                
                if bullet?.name == "fightEnemy" {
                    
                    if let tower = other?.userData?.objectForKey("towerclass") as? JianTower {
                        
                        if tower.entityName == "fightPlayer" {
                            
                            isContact = true
                        }
                    } else if let wall = other?.userData?.objectForKey("wallclass") as? Wall {
                        if wall.entityName == "fightPlayer" {
                            
                            isContact = true
                            
                        }
                    } else if other?.physicsBody!.categoryBitMask == BitMaskType.fightSelf {
                        
                        isContact = true
                    }
                    if isContact {
                        if other != nil {
                            bullet?.removeFromParent()
                            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: other!.position)
                        }
                    }
                    
                }
            }
            
//            
//            //let tower = nodeB.node?.userData?.objectForKey("towerclass") as! JianTower
//            if nodeA.categoryBitMask == BitMaskType.bullet && nodeB.categoryBitMask == BitMaskType.ftJianTower {
//                bullet = nodeA.node as! SKSpriteNode
//                tower = nodeB.node?.userData?.objectForKey("towerclass") as! JianTower
//            } else if nodeB.categoryBitMask == BitMaskType.bullet && nodeA.categoryBitMask == BitMaskType.ftJianTower {
//                bullet = nodeB.node as! SKSpriteNode
//                tower = nodeA.node?.userData?.objectForKey("towerclass") as! JianTower
//            }
//            
//            if bullet.name == "fightPlayer" {
//                
//                if tower.entityName == "fightEnemy" {
//                    bullet.removeFromParent()
//                    self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: tower.buildSprite.position)
//                }
//            }
//            
//            if nodeA.categoryBitMask == BitMaskType.bullet && nodeB.categoryBitMask == BitMaskType.ftWall {
//                bullet = nodeA.node as! SKSpriteNode
//                wall = nodeB.node?.userData?.objectForKey("wallclass") as! Wall
//            }else if nodeB.categoryBitMask == BitMaskType.bullet && nodeB.categoryBitMask == BitMaskType.ftWall
//            
//            
//            if nodeA.categoryBitMask == BitMaskType.bullet {
//                let bullet = nodeA.node as! SKSpriteNode
//                
//                if nodeB.categoryBitMask == BitMaskType.ftJianTower {
//                    let tower = nodeB.node?.userData?.objectForKey("towerclass") as! JianTower
//                    if bullet.name == "fightPlayer" {
//                        if tower.entityName == "fightEnemy" {
//                            bullet.removeFromParent()
//                            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: tower.buildSprite.position)
//                        }
//                    }
//                }
//                
//                if nodeB.categoryBitMask == BitMaskType.ftWall {
//                    let wall = nodeB.node?.userData?.objectForKey("wallclass") as! Wall
//                    if bullet.name == "fightPlayer" {
//                        if wall.entityName == "fightEnemy" {
//                            bullet.removeFromParent()
//                            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: wall.buildSprite.position)
//                        }
//                    }
//                }
//                
//                if nodeB.categoryBitMask == BitMaskType.fightEnemy {
//                    if bullet.name == "fightPlayer" {
//                        bullet.removeFromParent()
//                        self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: (self.entity as! FightPlayer).enemy.sprite.position)
//                    }
//                }
//                
//            }else if nodeB.categoryBitMask == BitMaskType.bullet {
//                
//            }
    }
    
    override func reckonHarmArea(toHarmPlayer: FightPlayer, originalConterPoint: CGPoint) {
        for temp in self.harmAreas {
            temp.runHarmArea(toHarmPlayer, originalConterPoint: originalConterPoint, hitValue: self.hitValue)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
