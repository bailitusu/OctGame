//
//  dutiao.swift
//  OctGame
//
//  Created by zc on 16/7/20.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit


class FTSynchronizingScene: BaseScene {
    
    var fightPlayer: FightPlayer!
    
    var fightEnemy: FightPlayer!
    
    var sock: SLBattleFieldNet!
    
    override func didMoveToView(view: SKView) {
        //load textures
        self.backgroundColor = SKColor.whiteColor()
        
        self.backGround = SKSpriteNode(imageNamed: "loading.png")
        self.backGround.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.backGround.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.backGround.zPosition = SpriteLevel.background.rawValue
        self.addChild(backGround)
        
        fightPlayer = FightPlayer(roleName: "fightPlayer")
        fightPlayer.fightMap = FightMap()
        fightPlayer.fightMap.initMap(5, verticalNum: 4, oneSize: fightMapCellSize, originalPointY: screenSize.height*0.299, isEnemy: false)
        fightPlayer.sprite.position = fightPlayer.fightMap.mapArray.objectAtIndex(10).position
        (fightPlayer.fightMap.mapArray.objectAtIndex(10) as! FTMapCell).obj = fightPlayer
        fightPlayer.configureSkill = ConfigureSkill(player: fightPlayer)
        fightPlayer.initConfigureSkillBall()
        
        fightPlayer.playerStateUI = FTPlayerStateUI(player: fightPlayer)
        fightPlayer.playerStateUI.hpLabel.position = CGPoint(x: screenSize.width-screenSize.width*0.146, y: screenSize.height*0.359)
        
        
        //zc fix!!
        fightEnemy = FightPlayer(roleName: "fightEnemy")
       // addEntity(fightEnemy)
        fightEnemy.fightMap = FightMap()
        fightEnemy.fightMap.initMap(5, verticalNum: 4, oneSize: fightMapCellSize,originalPointY: screenSize.height-screenSize.height*0.299, isEnemy: true)
        fightEnemy.sprite.position = fightEnemy.fightMap.mapArray.objectAtIndex(10).position
        (fightEnemy.fightMap.mapArray.objectAtIndex(10) as! FTMapCell).obj = fightEnemy
        
        fightEnemy.playerStateUI = FTPlayerStateUI(player: fightEnemy)
        fightEnemy.playerStateUI.hpLabel.position = CGPoint(x: screenSize.width*0.146 , y: screenSize.height-screenSize.height*0.375)
        
        fightPlayer.enemy = fightEnemy
        fightEnemy.enemy = fightPlayer
        
        let sleepThread: NSThread = NSThread(target: self, selector: "sendCommand", object: nil)
        sleepThread.start()
        self.sock.delegate = self
        
       // self.sock.send(BTCommand.CStatusSynchronized)
    }
    
    func sendCommand() {
        NSThread.sleepForTimeInterval(3)
        self.sock.send(BTCommand.CStatusSynchronized)
    }
    
    
}




extension FTSynchronizingScene: SLBattleFieldNetDelegate {
    func websocketDidConnected(socket: SLBattleFieldNet) {
        
    }
    
    func websocketDidDisconnected(socket: SLBattleFieldNet, error: NSError?) {
        
    }
    
    func websocketDidReceiveMessage(msg: BTMessage, net: SLBattleFieldNet) {
        switch msg.command {
        case .SStartFighting:
            let nextScene = FightScene()
            nextScene.size = self.view!.frame.size
            nextScene.fightPlayer = self.fightPlayer
            nextScene.fightEnemy = self.fightEnemy
            nextScene.sock = self.sock
            let transtion = SKTransition.crossFadeWithDuration(2.0)
            self.view?.presentScene(nextScene, transition: transtion)
            
        default:
            print("stare fighting error")
            
        }
    }
}














