//
//  SlowTowerSystem.swift
//  OctGame
//
//  Created by zc on 16/7/30.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class SlowTowerSystem: SkillSystem {
    var currentSlowTower: SlowTower!
    var towerID: UInt32!
    var towerArray: NSMutableArray!
    var defaluePosition: CGPoint?
    var area: UInt32 = UInt32(fightMapCellSize.width*2*fightMapCellSize.width*2)
    
    override init() {
        super.init()
        self.towerArray = NSMutableArray()
        self.towerID = 0
        self.touchPointArray = NSMutableArray()
        self.bollGroup = BallCategory.jianzhu.rawValue+BallCategory.jianzhu.rawValue+BallCategory.fuzhu.rawValue
        self.isSilent = false
    }
    
    override func initSkill() {
        self.towerID = self.towerID+1
        let towerBitMask = BitMaskType.fire | BitMaskType.boom | BitMaskType.bullet
        let tower = SlowTower(entityName: self.entityName, collsionBitMask: towerBitMask, buildID: self.towerID)
        let player = (self.entity as! FightPlayer)
        
        if player.roleName == "fightPlayer" {
            (self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray.append(tower)
            player.scene!.saveSkill.showCurrentSaveSkill()
            defaluePosition = tower.buildSprite.position
            player.sprite.parent?.addChild(tower.buildSprite)
        }
        
        self.towerArray.addObject(tower)
        self.currentSlowTower = tower
    }
    
    func isSetTowerSuccess(point: CGPoint) -> Int? {
        let selfMap = (self.entity as! FightPlayer).fightMap
        for i in 0 ..< selfMap.mapArray.count {
            if ((selfMap.mapArray.objectAtIndex(i) as! FTMapCell).obj == nil || ((selfMap.mapArray.objectAtIndex(i) as! FTMapCell).obj as? Boom) != nil) {
                if CGRectContainsPoint(selfMap.mapArray.objectAtIndex(i).frame, point) {
                    self.currentSlowTower.buildSprite.position = selfMap.mapArray.objectAtIndex(i).position
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
            if (temp as! SlowTower).isControl == true {
                
                if CGRectContainsPoint((temp as! SlowTower).buildSprite.frame, touchLocation!) {
                    self.touchPointArray.addObject(NSValue.init(CGPoint: touchLocation!))
                    self.currentSlowTower = temp as! SlowTower
                    self.defaluePosition = self.currentSlowTower.skillPosition
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
            
            let newPoint = CGPoint(x: self.currentSlowTower.buildSprite.position.x+distance.x, y: self.currentSlowTower.buildSprite.position.y+distance.y)
            
            self.currentSlowTower.buildSprite.position = newPoint
            
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
                (selfMap.mapArray.objectAtIndex(towerMapCellNum!) as! FTMapCell).obj = self.currentSlowTower
                self.currentSlowTower.isControl = false
                
                var dict = [String: AnyObject]()
                dict.updateValue(SkillName.slow.rawValue, forKey: "initSkill")
                let percentX = self.currentSlowTower.buildSprite.position.x / screenSize.width
                let percentY = (self.currentSlowTower.buildSprite.position.y-fightMapCellSize.height) / screenSize.height
                dict.updateValue(percentX, forKey: "percentX")
                dict.updateValue(percentY, forKey: "percentY")
                
                scene.sock.send(BTCommand.CCastSpell, withParams: (self.entity as! FightPlayer).toReleaseSkill(dict))
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName("slowSetRight", object: self, userInfo: ["playerSelfslow" : self.currentSlowTower])//用于tower和dilei的碰撞
                
                var removeObjNum = 0
                for i in 0 ..< ((self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray)!.count {
                    if let tower = ((self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray)![i] as? SlowTower {
                        if tower.buildID == self.currentSlowTower.buildID {
                            removeObjNum = i
                        }
                    }
                }
                (self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray.removeAtIndex(removeObjNum)
            }else {
                self.currentSlowTower.buildSprite.position = defaluePosition!
            }
        }
    }
    
    override func checkState(time: NSTimeInterval) {
        let removeArray = NSMutableArray()
        
        for temp in self.towerArray {
            if (temp as! SlowTower).removeTower() == true {
                removeArray.addObject(temp)
                let tempMap = (self.entity as! FightPlayer).fightMap
                (tempMap.mapArray.objectAtIndex(tempMap.getCurrentPointMapCell((temp as! SlowTower).buildSprite.position)!) as! FTMapCell).obj = nil
                if (temp as! SlowTower).buildID == self.currentSlowTower.buildID {
                    self.currentSlowTower = nil
                }
                
            }
            
            if (temp as! SlowTower).isControl == true {
                if (temp as! SlowTower).isRemove == true {
                    if (temp as! SlowTower).buildID == self.currentSlowTower.buildID {
                        self.currentSlowTower = nil
                    }
                    (temp as! SlowTower).buildSprite.removeFromParent()
                    removeArray.addObject(temp)
                }
            }
        }
        
        for removeTemp in removeArray {
            self.towerArray.removeObject(removeTemp)
        }
        
        if self.currentSlowTower != nil {
            if self.currentSlowTower.isControl == false {
                self.reckonSlowArea(self.currentSlowTower)
            }
        }
    }

    func reckonSlowArea(slowTower: SlowTower) {
        let scene = (self.entity as! FightPlayer).scene
//        var node: SKNode? = nil
        if let fire = scene?.childNodeWithName("fire") as? Fire{
            if fire.entityName == (self.entity as! FightPlayer).enemy.roleName {
                if fire.isControl == false {
                    let distance = CommonFunc.fightPointDistance(slowTower.buildSprite.position, pointB: fire.position)
                    if distance <= self.area {
                        if fire.dircspeed != CGVector(dx: fire.fireDefalutSpeed!.dx/4, dy: fire.fireDefalutSpeed!.dy/4) {
                            fire.dircspeed = CGVector(dx: fire.fireDefalutSpeed!.dx/4, dy: fire.fireDefalutSpeed!.dy/4)
                        }
                    }else {
                        if fire.dircspeed != fire.fireDefalutSpeed {
                            fire.dircspeed = fire.fireDefalutSpeed
                        }
                        
                    }
                }

            }
            
        }
        
        if let zidan = scene?.childNodeWithName("zidan") as? Bullte {
            if zidan.entityName == (self.entity as! FightPlayer).enemy.roleName {

                let distance = CommonFunc.fightPointDistance(slowTower.buildSprite.position, pointB: zidan.position)
                if distance <= self.area {
                    if zidan.physicsBody?.velocity != CGVector(dx: zidan.defaulVelocity!.dx/4, dy: zidan.defaulVelocity!.dy/4) {
                        zidan.physicsBody?.velocity = CGVector(dx: zidan.defaulVelocity!.dx/4, dy: zidan.defaulVelocity!.dy/4)
                    }
                }else {
                    if zidan.physicsBody?.velocity != zidan.defaulVelocity {
                        zidan.physicsBody?.velocity = zidan.defaulVelocity!
                    }
                    
                }
                
            }
        }
        
    }
}
