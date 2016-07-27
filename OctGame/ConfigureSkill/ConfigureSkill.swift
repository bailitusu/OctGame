//
//  ConfigureSkill.swift
//  OctGame
//
//  Created by zc on 16/7/12.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

//struct BollKinds {
//    static let fireBoll: NSInteger = 1
//    static let waterBoll: NSInteger = 11
//    static let electricBoll: NSInteger = 21
//    
//    
//}
enum BallCategory: Int {
    case fireBall = 1
    case waterBall = 10
    case electricBoll = 100
    var imageName: String {
        switch  self {
        case .fireBall:
            return "huoqiu.png"
        case .waterBall:
            return "shuiqiu.png"
        case .electricBoll:
            return "dianqiu.png"
        }
    }
    
    
    
    
    var name: String {
        switch self {
        case .fireBall:
            return "fireBall"
        case .waterBall:
            return "waterBall"
        case .electricBoll:
            return "electricBoll"
        }
    }
    
    
    
    static func decode(name: String) -> BallCategory? {
        switch name {
        case "fireBall":
            return .fireBall
        case "waterBall":
            return .waterBall
        case "electricBoll":
            return .electricBoll
        default:
            print("ERROR \(name)")
            return nil
            
        }
        
    }
    
    
}

let currentBallMaxNum = 5

class ConfigureSkill {
    var playerHasBallArray = [BallCategory]()
    var takeBallArray = [BallCategory]()
    var currentBallArray = NSMutableArray()
    var scene: FightScene!
    var player: FightPlayer!
    var isConfigOK: Bool!
    var removeItem: NoSaveSkillProtocal?
    
    func initOwnBoll(ball: BallCategory) {
        playerHasBallArray.append(ball)
    }
    
    func addTakeBoll(ball: BallCategory) {
        takeBallArray.append(ball)
    }
    
    init(player: FightPlayer) {
      //  self.scene = scene
        self.player = player
        self.isConfigOK = false
    }
    
    func createCurrentBall() {
        self.player.configCurrentBallArray.removeAll()
        for temp in currentBallArray {
            (temp as! Ball).sprite.removeFromParent()
        }
        currentBallArray.removeAllObjects()
        var noHaveSkillFlag = true
        while noHaveSkillFlag {
            currentBallArray.removeAllObjects()
            for i in 0 ..< currentBallMaxNum {
                let num = Int(arc4random() % UInt32(takeBallArray.count))
                
                let ballSprite = Ball(ballKinds: takeBallArray[num])
                currentBallArray.addObject(ballSprite)
            }
            if isHasSkill() {
                noHaveSkillFlag = false
                self.setOriginalBallPoint()
            }

        }

        
    }
    
    func isHasSkill() -> Bool{
        
        var oneBall: Ball
        var twoBall: Ball
        var thirdBall: Ball
        
        var tempArray = [Int]()
        
        for i in 0 ..< currentBallArray.count {
                oneBall = currentBallArray.objectAtIndex(i) as! Ball
            for j in i+1 ..< currentBallArray.count {
                twoBall = currentBallArray.objectAtIndex(j) as! Ball
                for k in j+1 ..< currentBallArray.count {
                    thirdBall = currentBallArray.objectAtIndex(k) as! Ball
                    tempArray.append(oneBall.ballID+twoBall.ballID+thirdBall.ballID)
                }
            }
        }
        for temp in player.skillSystemArray {
            for i in 0 ..< tempArray.count {
                if temp.bollGroup == tempArray[i] {
                    return true
                }
            }
        }
        
        return false
    }
    
    func setOriginalBallPoint() {
        var pointX = screenSize.width*0.113 + screenSize.width*0.133/2
        for temp in currentBallArray {
            let ball = temp as! Ball
            let pointY = CGFloat(arc4random()%100) + screenSize.height*0.42
            ball.sprite.position = CGPoint(x: pointX, y: pointY)
            pointX += (10 + screenSize.width*0.133)
            self.scene.addChild(ball.sprite)
        }
        
    }
    
    func confirmSkill(configBallArray: [Ball]) {
        var skillNum: Int = 0
        
        for temp in configBallArray {
            skillNum = temp.ballID + skillNum
        }
        switch skillNum {
        case BallCategory.fireBall.rawValue + BallCategory.electricBoll.rawValue + BallCategory.fireBall.rawValue:
            self.scene.fightPlayer.createSkillSprite(FireSystem.self)
            
            var dict = [String: AnyObject]()
            dict.updateValue(SkillName.fire.rawValue, forKey: "initSkill")
           // self.scene.websocket.writeMessage(BTMessage(command: BTCommand.CreateSpell, params: self.scene.fightPlayer.toInitSkill(dict)))
            self.scene.sock.send(BTCommand.CCreateSpell, withParams: self.scene.fightPlayer.toInitSkill(dict))
            break
        case BallCategory.fireBall.rawValue + BallCategory.waterBall.rawValue + BallCategory.electricBoll.rawValue:
            if removeItem != nil {
                removeItem?.removeSkillItem()
            }
            self.scene.fightPlayer.createSkillSprite(BoomSystem.self)

            removeItem = self.scene.fightPlayer.skillSystemForClass(BoomSystem.self)
  
            var dict = [String: AnyObject]()
            dict.updateValue(SkillName.boom.rawValue, forKey: "initSkill")
    
            self.scene.sock.send(BTCommand.CCreateSpell, withParams: self.scene.fightPlayer.toInitSkill(dict))
            break
        case BallCategory.fireBall.rawValue + BallCategory.fireBall.rawValue + BallCategory.waterBall.rawValue:
            if removeItem != nil {
                removeItem?.removeSkillItem()
                removeItem = nil
            }
            self.scene.fightPlayer.createSkillSprite(WallSystem.self)
            var dict = [String: AnyObject]()
            dict.updateValue(SkillName.wall.rawValue, forKey: "initSkill")
      
            self.scene.sock.send(BTCommand.CCreateSpell, withParams: self.scene.fightPlayer.toInitSkill(dict))
            break
        case BallCategory.waterBall.rawValue + BallCategory.waterBall.rawValue + BallCategory.fireBall.rawValue:
            self.scene.fightPlayer.createSkillSprite(JianTowerSystem.self)
            var dict = [String: AnyObject]()
            dict.updateValue(SkillName.tower.rawValue, forKey: "initSkill")
            
            self.scene.sock.send(BTCommand.CCreateSpell, withParams: self.scene.fightPlayer.toInitSkill(dict))
            break
            
        case BallCategory.waterBall.rawValue + BallCategory.waterBall.rawValue + BallCategory.waterBall.rawValue:
            self.scene.fightPlayer.createSkillSprite(FogSystem.self)
            var dict = [String: AnyObject]()
            dict.updateValue(SkillName.fog.rawValue, forKey: "initSkill")
            
            self.scene.sock.send(BTCommand.CCreateSpell, withParams: self.scene.fightPlayer.toInitSkill(dict))
            break
        default:
            
            print("configskill  error")
        }
        
        for temp in self.currentBallArray {
            (temp as! Ball).sprite.removeFromParent()
        }
        self.currentBallArray.removeAllObjects()
        
      
    }
    
}