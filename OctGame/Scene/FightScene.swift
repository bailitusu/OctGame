//
//  FightScene.swift
//  OctGame
//
//  Created by zc on 16/7/1.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit
import Starscream

class FightScene: BaseScene, SKPhysicsContactDelegate {
    var fightPlayer: FightPlayer!
    var fightEnemy: FightPlayer!
//    var fightPlayerMap: FightMap!
//    var fightEnemyMap: FightMap!
    var gameStart: Bool = false
    var websocket: WebSocket!
    var wsDelegate: FightSceneWSDelegate!
    
    var touchPointArray: NSMutableArray!
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        touchPointArray = NSMutableArray()
        self.backgroundColor = SKColor.whiteColor()
        
        self.backGround = SKSpriteNode(imageNamed: "begin.jpg")
        self.backGround.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.backGround.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.backGround.zPosition = SpriteLevel.background.rawValue
        self.addChild(backGround)
        
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        
        fightPlayer = FightPlayer(roleName: "fightPlayer")
        addEntity(fightPlayer)
        fightPlayer.fightMap = FightMap()
        fightPlayer.fightMap.initMap(5, verticalNum: 4, oneSize: fightMapCellSize, scene: self, originalPointY: screenSize.height*0.299, isEnemy: false)
        fightPlayer.sprite.position = fightPlayer.fightMap.mapArray.objectAtIndex(10).position
        (fightPlayer.fightMap.mapArray.objectAtIndex(10) as! FTMapCell).obj = fightPlayer
        fightPlayer.configureSkill = ConfigureSkill(scene: self, player: fightPlayer)
        fightPlayer.initConfigureSkillBall()
        
        fightPlayer.playerStateUI = FTPlayerStateUI(player: fightPlayer, scene: self)
        fightPlayer.playerStateUI.hpLabel.position = CGPoint(x: screenSize.width-screenSize.width*0.146, y: screenSize.height*0.359)
        
        fightEnemy = FightPlayer(roleName: "fightEnemy")
        addEntity(fightEnemy)
        fightEnemy.fightMap = FightMap()
        fightEnemy.fightMap.initMap(5, verticalNum: 4, oneSize: fightMapCellSize, scene: self, originalPointY: screenSize.height-screenSize.height*0.299, isEnemy: true)
        fightEnemy.sprite.position = fightEnemy.fightMap.mapArray.objectAtIndex(10).position
        (fightEnemy.fightMap.mapArray.objectAtIndex(10) as! FTMapCell).obj = fightEnemy
        
        fightEnemy.playerStateUI = FTPlayerStateUI(player: fightEnemy, scene: self)
        fightEnemy.playerStateUI.hpLabel.position = CGPoint(x: screenSize.width*0.146 , y: screenSize.height-screenSize.height*0.375)
        
        fightPlayer.enemy = fightEnemy
        fightEnemy.enemy = fightPlayer
        configBitMask()
        
        
        
//        let beginBtn = SpriteButton(titleText: "产生火球", normalImageName: nil, callBack: { () -> () in
//            
//
//            self.fightPlayer.createSkillSprite(FireSystem.self)
//
//            var dict = Dictionary<String, AnyObject>()
//            dict.updateValue(SkillName.fire.rawValue, forKey: "initSkill")
//            self.websocket.writeMessage(BTMessage(command: BTCommand.CreateSpell, params: self.fightPlayer.toInitSkill(dict)))
//            }, frame:CGRectMake(30, 15, 60, 30))
//        beginBtn.setBackGroundColor(UIColor.blackColor())
//        beginBtn.zPosition = SpriteLevel.sprite.rawValue
//        self.addChild(beginBtn)
//
//        let boomBtn = SpriteButton(titleText: "产生地雷", normalImageName: nil, callBack: { () -> () in
//            
//
////            self.fightPlayer.createSkillSprite(BoomSystem.self)
////            var dict = Dictionary<String, AnyObject>()
////            dict.updateValue(SkillName.boom.rawValue, forKey: "initSkill")
////            self.websocket.writeMessage(BTMessage(command: BTCommand.CreateSpell, params: self.fightPlayer.toInitSkill(dict)))
////            
//            self.fightPlayer.createSkillSprite(WallSystem.self)
//            
//            var dict = Dictionary<String, AnyObject>()
//            dict.updateValue(SkillName.wall.rawValue, forKey: "initSkill")
//            self.websocket.writeMessage(BTMessage(command: BTCommand.CreateSpell, params: self.fightPlayer.toInitSkill(dict)))
//            
//            }, frame:CGRectMake(30, 70, 60, 30))
//        boomBtn.setBackGroundColor(UIColor.blackColor())
//        boomBtn.zPosition = SpriteLevel.sprite.rawValue
//        self.addChild(boomBtn)
        
        
        wsDelegate = FightSceneWSDelegate(forScene: self)
        websocket.delegate = wsDelegate

        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(ballFollowPlayer), name: "playerMove", object: fightPlayer)
        
        NSTimer.scheduledTimerWithTimeInterval(7, target: self, selector: #selector(createBall), userInfo: nil, repeats: true)
    }
    
    func configBitMask() {
        self.physicsBody?.categoryBitMask = BitMaskType.background
        self.physicsBody?.restitution = 1
        self.physicsBody?.friction = 0
        fightPlayer.physicsBody?.categoryBitMask = BitMaskType.fightSelf
        fightPlayer.physicsBody?.collisionBitMask = BitMaskType.fire
        fightPlayer.physicsBody?.contactTestBitMask = BitMaskType.fire
        
        fightEnemy.physicsBody?.categoryBitMask = BitMaskType.fightEnemy
        fightEnemy.physicsBody?.collisionBitMask = BitMaskType.fire
        fightEnemy.physicsBody?.contactTestBitMask = BitMaskType.fire
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        fightPlayer.didContact(contact)
        fightEnemy.didContact(contact)
                let nodeA = contact.bodyA
                let nodeB = contact.bodyB
        if nodeA.categoryBitMask == BitMaskType.fire {
            let fire = nodeA.node as! Fire
            if nodeB.categoryBitMask == BitMaskType.background {
                
                fire.collideCount = fire.collideCount+1
            }
        }else if nodeB.categoryBitMask == BitMaskType.fire {
            let fire = nodeB.node as! Fire
            if nodeA.categoryBitMask == BitMaskType.background {
                
                fire.collideCount = fire.collideCount+1
            }
        }




    }
    
    func createBall() {
        fightPlayer.configureSkill.createCurrentBall()
    }
    
    
    @objc func ballFollowPlayer(note: NSNotification) {
        let moveToPoint = note.userInfo!["moveToMapCell"]
        if fightPlayer.configCurrentBallArray.count != 0 {
            for temp in fightPlayer.configCurrentBallArray {
              //  temp.sprite.removeActionForKey("ballFollowPlayer")
                let move = SKAction.moveTo((moveToPoint?.position)!, duration: 0.3)
                temp.sprite.runAction(move)
            }
        }
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        
        fightPlayer.checkState(currentTime)
        fightEnemy.checkState(currentTime)
        
//        if fightPlayer.configCurrentBallArray.count != 0 {
//            for temp in  fightPlayer.configCurrentBallArray {
//                temp.sprite.position = fightPlayer.sprite.position
//            }
//        }
        if fightPlayer.configureSkill.isConfigOK == true {
            for temp in fightPlayer.configureSkill.currentBallArray {
                (temp as! Ball).sprite.hidden = true
            }
            fightPlayer.configureSkill.confirmSkill(fightPlayer.configCurrentBallArray)
            fightPlayer.configCurrentBallArray.removeAll()
            fightPlayer.configureSkill.isConfigOK = false
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
//        if gameStart == false {
//            gameStart = true
//           
//        }
        
        let touchLocation = touches.first?.locationInNode(self)
        
        fightPlayer.toucheBegan(touches, withEvent: event, scene: self)

        
        for i in 0  ..< fightPlayer.fightMap.mapArray.count {
            if i >= 5 && i <= 15 && i != 8 && i != 12 {
                if CGRectContainsPoint(fightPlayer.fightMap.mapArray.objectAtIndex(i).frame, touchLocation!) {
//                    if fightPlayer.skillSystemForClass(FireSystem.self)!.currentHuoqiu != nil {
//                        if CGRectContainsPoint(fightPlayer.skillSystemForClass(FireSystem.self)!.currentHuoqiu.frame, touchLocation!) {
//                            return
//                        }
//                    }
                    //                FightPlayer.cellPosition =
                    //  fightPlayer.move(fightPlayerMap.mapArray.objectAtIndex(i) as! SKSpriteNode)
                    fightPlayer.mapCellIndex = i
                    
                    // websocket.writeString("battlefield001_\(userID)_castspell_\(fightPlayer.toDictionary())")
                    websocket.writeMessage(BTMessage(command: BTCommand.PlayerStatus, params: fightPlayer.toDictionary()))
                }
            }
        }
        
        if fightPlayer.configureSkill.currentBallArray.count != 0{
            for tempBall in fightPlayer.configureSkill.currentBallArray {
                if CGRectContainsPoint((tempBall as! Ball).sprite.frame, touchLocation!) {
//                    if (tempBall as! Ball).isControl == true {
                    if fightPlayer.configCurrentBallArray.count < 3 {
                        fightPlayer.configCurrentBallArray.append(tempBall as! Ball)
                        if fightPlayer.configCurrentBallArray.count == 3 {
                            fightPlayer.configureSkill.isConfigOK = true
                        }
                        let move = SKAction.moveTo(fightPlayer.sprite.position, duration: 0.3)
                        let block = SKAction.runBlock({ 
                            if self.fightPlayer.configCurrentBallArray.count == 3 {
                                self.fightPlayer.configureSkill.isConfigOK = true
                            }
                        })
                        (tempBall as! Ball).sprite.runAction(SKAction.sequence([move,block]))
                    }

//                    }
                }
            }
        }

    }

    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        fightPlayer.toucheMoved(touches, withEvent: event, scene: self)

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        fightPlayer.toucheEnded(touches, withEvent: event, scene: self)

    }
}



extension WebSocket {
    func writeMessage(msg: BTMessage) {
        self.writeString(msg.description)
    }
}







