//
//  CatapultSystem.swift
//  OctGame
//
//  Created by zc on 16/7/29.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class CatapultSystem: SkillSystem, NoSaveSkillProtocal {
    
    var catapultArray: NSMutableArray!
    var noLaunchCatapult: Catapult?
    var catapultID: UInt32!
    var hitValue: Int = 10
    var zhunXing: SKSpriteNode?
    override init() {
        super.init()
        self.catapultArray = NSMutableArray()
        self.catapultID = 0
        self.touchPointArray = NSMutableArray()
        self.bollGroup = BallCategory.gongji.rawValue + BallCategory.gongji.rawValue + BallCategory.gongji.rawValue
        self.isSilent = false
    }
    
    override func addSkillObserver() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(catapultFollowPlayer), name: "playerMove", object: (self.entity as! FightPlayer))
    }
    
    @objc func catapultFollowPlayer(note: NSNotification) {
        if let moveToPoint = note.userInfo?["moveToMapCell"] as? SKSpriteNode {
            // print(moveToPoint.position)
            
            if CommonFunc.fightIsEqualPoint(moveToPoint.position, pointB: (self.entity as! FightPlayer).sprite.position)  == false {

                if self.noLaunchCatapult?.isControl == true {
                    let move = SKAction.moveTo(moveToPoint.position, duration: 0.3)
                    self.noLaunchCatapult!.runAction(move)
                }
            }
            
        }
 
    }
    
    override func initSkill() {
        self.catapultID = self.catapultID+1
        let catapult = Catapult(size: SkillSize.catapult, entityName: self.entityName, catapultID: self.catapultID)
        let player = self.entity as! FightPlayer
        catapult.position = CGPoint(x: player.sprite.position.x, y: player.sprite.position.y)
        
        if player.roleName == "fightPlayer" {
           player.sprite.parent?.addChild(catapult)
        }
        
        // self.huoqiuArray.addObject(fire)
        if self.noLaunchCatapult != nil {
            self.noLaunchCatapult?.removeFromParent()
        }
        self.noLaunchCatapult = catapult
    }
    
    func removeSkillItem() {
        if self.noLaunchCatapult != nil {
            if self.noLaunchCatapult?.isControl == true {
                self.noLaunchCatapult?.removeFromParent()
                self.noLaunchCatapult = nil
            }
        }
    }
    
    override func reckonHarmArea(toHarmPlayer: FightPlayer, originalConterPoint: CGPoint) {
        for temp in self.harmAreas {
            temp.runHarmArea(toHarmPlayer, originalConterPoint: originalConterPoint, hitValue: self.hitValue)
        }
    }
    
    override func checkState(time: NSTimeInterval) {
        if self.zhunXing != nil {
            if self.zhunXing!.position.y <= 0 || self.zhunXing!.position.y >= screenSize.height || self.zhunXing!.position.x <= 0 || self.zhunXing!.position.x >= screenSize.width {
                self.noLaunchCatapult?.tagartPoint = self.zhunXing?.position
                self.zhunXing!.removeFromParent()
                self.zhunXing = nil
                
                self.sendTouShiChe()
            }
        }
        
        let removeArray = NSMutableArray()
        for temp in self.catapultArray  {
            if (temp as! Catapult).removeCatapult() == true {
                removeArray.addObject(temp)
            }
        }
        
        for removeTemp in removeArray {
            self.catapultArray.removeObject(removeTemp)
        }
    }
    
    override func toucheBegan(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        let touchLocation = touches.first?.locationInNode(scene)
        
        self.touchPointArray.removeAllObjects()
        if self.noLaunchCatapult != nil {
            
//            let rect = CGRect(origin: CGPoint(x: self.noLaunchCatapult!.position.x-SkillSize.huoqiu.width, y: self.noLaunchCatapult!.position.y-SkillSize.huoqiu.height), size: CGSize(width: self.noLaunchCatapult!.frame.width*2, height: self.noLaunchCatapult!.frame.height*2))
            if CGRectContainsPoint(self.noLaunchCatapult!.frame, touchLocation!) {
                self.touchPointArray.addObject(NSValue.init(CGPoint: touchLocation!))
            }
            
            if self.noLaunchCatapult?.miaoZhun == true {
                if CGRectContainsPoint(self.noLaunchCatapult!.frame, touchLocation!) {
                    self.zhunXing?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    let enemyMap = (self.entity as! FightPlayer).enemy.fightMap
                    for i in 0 ..< enemyMap.mapArray.count {
                        if CGRectContainsPoint(enemyMap.mapArray.objectAtIndex(i).frame, (self.zhunXing?.position)!) {
                            self.noLaunchCatapult?.tagartPoint = enemyMap.mapArray.objectAtIndex(i).position
                            self.zhunXing?.removeFromParent()
                            self.zhunXing = nil
                            self.sendTouShiChe()
                            //     let enemyMap = (self.entity as! FightPlayer).enemy.fightMap
                            var dict = [String: AnyObject]()
                            dict.updateValue(SkillName.catapult.rawValue, forKey: "initSkill")
                            let percentX = self.noLaunchCatapult!.tagartPoint!.x / screenSize.width
                            let percentY = (self.noLaunchCatapult!.tagartPoint!.y-fightMapCellSize.height) / screenSize.height
                            dict.updateValue(percentX, forKey: "percentX")
                            dict.updateValue(percentY, forKey: "percentY")
                            // scene.websocket.writeMessage(BTMessage(command: BTCommand.CCastSpell, params: (self.entity as! FightPlayer).toReleaseSkill(dict)))
                           scene.sock.send(BTCommand.CCastSpell, withParams: (self.entity as! FightPlayer).toReleaseSkill(dict))

                            break
                        }
                    }
                }
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
                let firstPoint = (self.noLaunchCatapult?.position)!
                let endPoint = (self.touchPointArray.lastObject!.CGPointValue)!
                let distance = CGVector(dx: endPoint.x-firstPoint.x, dy: endPoint.y-firstPoint.y)
                if distance != CGVector(dx: 0, dy: 0) {
                    if self.noLaunchCatapult?.miaoZhun == false {
                        self.noLaunchCatapult?.miaoZhun = true
                        self.runZhunXing(SkillSystem.reckonSkillSpeed(distance, skillSpeed: FightSkillSpeed.toushiche))
                    }
                    
                }
                

                //                for i in 0 ..< self.touchPointArray.count {
                //                    print("\(i)-----\(self.touchPointArray.objectAtIndex(i).CGPointValue)")
                //                }
            }
        }
    }

    
    func runZhunXing(speed: CGVector) {
        self.zhunXing = SKSpriteNode(imageNamed: "zhunxing.png")
        self.zhunXing!.size = SkillSize.catapult
        self.zhunXing!.zPosition = SpriteLevel.catapult.rawValue+1
        self.zhunXing!.physicsBody = SKPhysicsBody(circleOfRadius: SkillSize.catapult.width/2, center: CGPoint(x: 0.5, y: 0.5))
        self.zhunXing!.physicsBody?.affectedByGravity = false
        self.zhunXing!.physicsBody?.mass = 10
        self.zhunXing!.physicsBody?.allowsRotation = false
        self.zhunXing!.physicsBody?.linearDamping = 0
        self.zhunXing!.physicsBody?.categoryBitMask = UInt32(0)
        self.zhunXing!.physicsBody?.collisionBitMask = UInt32(0)
        self.zhunXing!.physicsBody?.contactTestBitMask = UInt32(0)
        (self.entity as! FightPlayer).scene?.addChild(self.zhunXing!)
        self.zhunXing!.position = (self.noLaunchCatapult?.position)!
        self.zhunXing!.physicsBody?.velocity = speed
    }

    func sendTouShiChe() {
        self.noLaunchCatapult!.isControl = false
        self.catapultArray.addObject(self.noLaunchCatapult!)
        let move = SKAction.moveTo(self.noLaunchCatapult!.tagartPoint!, duration: 2)
        let block = SKAction.runBlock { 
            self.reckonHarmArea((self.entity as! FightPlayer).enemy, originalConterPoint: self.noLaunchCatapult!.tagartPoint!)

            

            self.noLaunchCatapult?.isRemove = true
            self.noLaunchCatapult = nil
        }
        self.noLaunchCatapult?.runAction(SKAction.sequence([move, block]))
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
    
