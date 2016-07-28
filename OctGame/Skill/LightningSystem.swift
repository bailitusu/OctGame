//
//  LightningSystem.swift
//  OctGame
//
//  Created by zc on 16/7/28.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class LightningSystem: SkillSystem {
    var lightningArray: NSMutableArray!
    var currentLightning: Lightning!
    var defaluePosition: CGPoint?
    var lightningID: UInt32!
    var hitValue: Int = 1
    override init() {
        super.init()
        self.lightningArray = NSMutableArray()
        self.lightningID = 0
        self.touchPointArray = NSMutableArray()
        self.isSilent = false
        self.bollGroup = BallCategory.gongji.rawValue+BallCategory.jianzhu.rawValue+BallCategory.fuzhu.rawValue
    }
    
    override func initSkill() {
        self.lightningID = self.lightningID+1
        let lightning = Lightning(size: SkillSize.lightning, entityName: self.entityName, fogID: lightningID)
        let player = (self.entity as! FightPlayer)
        if player.roleName == "fightPlayer" {
            player.scene?.saveSkill.saveSkillArray.append(lightning)
            player.scene!.saveSkill.showCurrentSaveSkill()
            defaluePosition = lightning.skillPosition
            player.sprite.parent?.addChild(lightning)
        }
        self.lightningArray.addObject(lightning)
        self.currentLightning = lightning
    }
    
    func isSetLightningSuccess(point: CGPoint) -> (Int,FightPlayer)? {
        let enemyMap = (self.entity as! FightPlayer).enemy.fightMap
        for i in 0 ..< enemyMap.mapArray.count {
            if CGRectContainsPoint(enemyMap.mapArray.objectAtIndex(i).frame, point) {
                self.currentLightning.position = enemyMap.mapArray.objectAtIndex(i).position
                return (i,(self.entity as! FightPlayer).enemy)
            }
        }
        let selfMap = (self.entity as! FightPlayer).fightMap
        for j in 0 ..< selfMap.mapArray.count {
            if CGRectContainsPoint(selfMap.mapArray.objectAtIndex(j).frame, point) {
                self.currentLightning.position = selfMap.mapArray.objectAtIndex(j).position
                return (j,(self.entity as! FightPlayer))
            }
        }
        return nil
    }
    
    override func toucheBegan(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        let touchLocation = touches.first?.locationInNode(scene)
        self.touchPointArray.removeAllObjects()
        for temp in self.lightningArray {
            if (temp as! Lightning).isControl == true {

                if CGRectContainsPoint((temp as! Lightning).frame, touchLocation!) {
                    self.touchPointArray.addObject(NSValue.init(CGPoint: touchLocation!))
                    self.currentLightning = temp as! Lightning
                    self.defaluePosition = self.currentLightning.skillPosition
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
            
            let newPoint = CGPoint(x: self.currentLightning.position.x+distance.x, y: self.currentLightning.position.y+distance.y)
            
            self.currentLightning.position = newPoint
            
        }
    }
    
    override func toucheEnded(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        if self.touchPointArray.count != 0 {
            let endPoint = (self.touchPointArray.lastObject!.CGPointValue)!
            var lightningMapCell: (Int, FightPlayer)? = nil
            if self.isSilent == false {
                lightningMapCell = isSetLightningSuccess(endPoint)
            }
            if lightningMapCell != nil {
                
                self.currentLightning!.isControl = false
                // var dict = Dictionary<String, AnyObject>()
                var dict = [String: AnyObject]()
                dict.updateValue(SkillName.luolei.rawValue, forKey: "initSkill")
                let percentX = self.currentLightning!.position.x / screenSize.width
                let percentY = (self.currentLightning!.position.y-fightMapCellSize.height) / screenSize.height
                dict.updateValue(percentX, forKey: "percentX")
                dict.updateValue(percentY, forKey: "percentY")
                dict.updateValue((lightningMapCell?.0)!, forKey: "cellNum")
                dict.updateValue((lightningMapCell?.1.roleName)!, forKey: "setWhoMap")
                // scene.websocket.writeMessage(BTMessage(command: BTCommand.CastSpell, params: (self.entity as! FightPlayer).toReleaseSkill(dict)))
                scene.sock.send(BTCommand.CCastSpell, withParams: (self.entity as! FightPlayer).toReleaseSkill(dict))
                self.lightningRun(lightningMapCell!, lightning: self.currentLightning)
                var removeObjNum = 0
                for i in 0 ..< ((self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray)!.count {
                    if let lightning = ((self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray)![i] as? Lightning {
                        if lightning.lightningID == self.currentLightning.lightningID {
                            removeObjNum = i
                        }
                    }
                }
                (self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray.removeAtIndex(removeObjNum)
            }else {
                
                self.currentLightning.position = defaluePosition!
            }
        }
    }
    
    func lightningRun(cell: (Int, FightPlayer), lightning: Lightning) {
        if self.entityName == "fightPlayer" {
            if  let name = (cell.1.fightMap.mapArray.objectAtIndex(cell.0) as! FTMapCell).obj?.getEntityName() {
                if name == "fightEnemy" {
                    (cell.1.fightMap.mapArray.objectAtIndex(cell.0) as! FTMapCell).obj!.didBeHit(self.hitValue)
                }
            }
        }else if self.entityName == "fightEnemy" {
            if  let name = (cell.1.fightMap.mapArray.objectAtIndex(cell.0) as! FTMapCell).obj?.getEntityName() {
                if name == "fightPlayer" {
                    (cell.1.fightMap.mapArray.objectAtIndex(cell.0) as! FTMapCell).obj!.didBeHit(self.hitValue)
                }
            }
        }
        let alpha0 = SKAction.fadeAlphaTo(0, duration: 0.3)
        let alpha1 = SKAction.fadeAlphaTo(1, duration: 0.3)
        let block = SKAction.runBlock { 
            lightning.isRemove = true
        }
        lightning.runAction(SKAction.sequence([alpha0,alpha1,block]))
        
    }
    
    override func checkState(time: NSTimeInterval) {
        let removeArray = NSMutableArray()
        
        for temp in self.lightningArray {
            if (temp as! Lightning).removeLightning() == true {
                removeArray.addObject(temp)
            }
        }
        
        for removeTemp in removeArray {
            self.lightningArray.removeObject(removeTemp)
        }
    }
}
