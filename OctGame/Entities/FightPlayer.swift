//
//  FightPlayer.swift
//  OctGame
//
//  Created by zc on 16/7/1.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit
import SwiftyJSON
import Starscream
enum SkillName: String {
    case fire = "fire"
    case boom = "boom"
    case wall = "wall"
}
class FightPlayer: Entity, FTCellStandAbleDelegate {
  //  var delegate: OnlineGameConvertable?
    var playerStateUI: FTPlayerStateUI!
    var roleName: String!
    var fightMap: FightMap!
    var enemy: FightPlayer!
    var scene: FightScene?
    var skillSystemArray = [SkillSystem]()

    var configureSkill: ConfigureSkill!
    
    var HP: Int = 10 {
        didSet {
            if self.HP <= 0 {
                var temp: String = "loser"
                if self.roleName == "fightPlayer" {
                    
                        // self.scene!.sock.send(BTCommand.CStatusEnding)
                   temp = "loser"
                   
                }
                if self.roleName == "fightEnemy" {
                    
                        // self.scene!.sock.send(BTCommand.CStatusEnding)
                   temp = "winner"
                    
                }
                self.scene?.sock.send(BTCommand.CStatusEnding, withParams: self.toResult(temp))
                SuccessView.gameOver((self.scene?.view)!, isSuccess: nil)
            }
            

        }
    }
    var configCurrentBallArray = [Ball]()
    var mapCellIndex: Int! = 4 {
        didSet {
  
        self.moveToCell(self.fightMap.mapArray.objectAtIndex(self.mapCellIndex) as! FTMapCell)
            
        }
    }
    
//    var isInitSkillSprite: Bool! = false {
//        didSet {
//            if self.isInitSkillSprite == true {
//                self.fireSys.initSkill((enemy.sprite.physicsBody?.categoryBitMask)!)
//               //self.fireSys.initSkill(self)
//                
//            }
//        }
//    }
//    var isThrowFire: Bool = false
//    var fireVector: CGVector! {
//        didSet {
//            self.fireSys.throwSkill(self, speed: fireVector)
//        }
//    }
    var sprite: SKSpriteNode {
        return (self.componentForClass(SpriteComponent.self)?.sprite)!
    }
    
    init(roleName: String) {
        super.init()
     //   self.delegate = MyDaili()
        let sprite = SKSpriteNode(imageNamed: "fightOne.jpg")
        sprite.name = roleName
        sprite.size = fightPlayerSize
        sprite.zPosition = SpriteLevel.sprite.rawValue
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size, center: CGPoint(x: 0.5, y: 0.5))
        sprite.physicsBody?.affectedByGravity = false;
        sprite.physicsBody?.mass = 10000;
        sprite.physicsBody?.allowsRotation = false;
        sprite.physicsBody?.dynamic = false
        self.addComponent(SpriteComponent(sprite: sprite))
        self.roleName = roleName
     
        
        self.initSkillSystemArray(FireSystem())
       // self.skillSystemForClass(FireSystem.self)?.addHarmArea(HengPaiHarm())
        self.skillSystemForClass(FireSystem.self)?.addHarmArea(SinglePointHarm())
        self.initSkillSystemArray(BoomSystem())
        self.skillSystemForClass(BoomSystem.self)?.addHarmArea(SinglePointHarm())
        self.initSkillSystemArray(WallSystem())
        
    
       // self.yidong = false
    }

    func initConfigureSkillBall() {
        self.configureSkill.initOwnBoll(BallCategory.fireBall)
        self.configureSkill.initOwnBoll(BallCategory.waterBall)
        self.configureSkill.initOwnBoll(BallCategory.electricBoll)
        
        self.configureSkill.addTakeBoll(BallCategory.fireBall)
        self.configureSkill.addTakeBoll(BallCategory.waterBall)
        self.configureSkill.addTakeBoll(BallCategory.electricBoll)
    }
    
    func initSkillSystemArray(skillSystem: SkillSystem) {
        self.skillSystemArray.append(skillSystem)
        skillSystem.entity = self
        skillSystem.entityName = self.roleName
        skillSystem.addSkillObserver()
    }
    
    func skillSystemForClass<skillSystem: SkillSystem>(skillSystemClass:skillSystem.Type) -> skillSystem? {
        for temp in self.skillSystemArray {
            if let result = temp as? skillSystem {
                return result
            }
        }
        return nil
    }
    
    func moveToCell(locationSprite: FTMapCell) {
        if abs(locationSprite.position.x - self.sprite.position.x) < locationSprite.size.width+1 && abs(locationSprite.position.y - self.sprite.position.y) < locationSprite.size.height+1 {
            if locationSprite.obj == nil || ((locationSprite.obj as? Boom) != nil)  {
                let beforePlayerStandCell = self.fightMap.mapArray.objectAtIndex(self.fightMap.getCurrentPointMapCell(self.sprite.position)!) as! FTMapCell
                beforePlayerStandCell.obj = nil
                
                locationSprite.obj = self
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName("playerMove", object: self, userInfo: ["moveToMapCell" : locationSprite])
                let move = SKAction.moveTo(locationSprite.position, duration: 0.3)
                //            let block = SKAction.runBlock({
                //                locationSprite.obj = self
                //            })
                self.sprite.runAction(SKAction.sequence([move]))
            }

//            self.yidong = true
//            let formatter = NSDateFormatter()
//            formatter.dateFormat = "yyy-MM-dd HH:mm:ss:SSS"
//            let date = formatter.stringFromDate(NSDate())
//            print("yidong begin    \(date)")
//            print(<#T##items: Any...##Any#>, separator: <#T##String#>, terminator: <#T##String#>)
        }

    }
    
    func checkState(time: NSTimeInterval) {
        for temp in self.skillSystemArray {
            temp.checkState(time)
        }
    }
    
    func didContact(contact: SKPhysicsContact) {
        for temp in self.skillSystemArray {
            temp.didContact(contact)
        }

    }
    
    func toucheBegan(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        for temp in self.skillSystemArray {
            temp.toucheBegan(touches, withEvent: event, scene: scene)
        }
    }
    
    func toucheMoved(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        for temp in self.skillSystemArray {
            temp.toucheMoved(touches, withEvent: event, scene: scene)
        }
    }
    
    func toucheEnded(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        for temp in self.skillSystemArray {
            temp.toucheEnded(touches, withEvent: event, scene: scene)
        }
    }
    
    override func updateWithDeltaTime(second: NSTimeInterval) {
        super.updateWithDeltaTime(second)
        
    }
    
    func createSkillSprite<skillSystem: SkillSystem>(skillSystemClass:skillSystem.Type) {
        let system =  self.skillSystemForClass(skillSystemClass)
        system?.initSkill()
//        var dict = Dictionary<String, AnyObject>()
//        dict.updateValue(SkillName.fire.rawValue, forKey: "skillname")
        
    }
    
    func didBeHit(hitValue: Int) {
        self.HP = self.HP - hitValue
        self.playerStateUI.changeHpUI(self.HP)
       // print(self.HP)
    }
//    func runCurrentSkill<skillSystem: SkillSystem>(skillSystemClass:skillSystem.Type, speed: CGVector) {
//        let system =  self.skillSystemForClass(skillSystemClass)
//        system?.throwSkill(speed)
//    }
    
//    func createSkill() {
//       // let a = FireSkill(entity: self, entityName: "fightPlayer")
//    }
//    
//    func throwSkill(speed: CGVector) {
////        let a = FireSkill(entity: self, entityName: "fightPlayer")
////        self.skill.throwSkill(a , speed: speed)
//        
//        self.delegate?.sendMeg()
//        
//    }
    
}


//class MyDaili: OnlineGameConvertable {
//    func sendMeg() {
//        print("")
//    }
//}
//var tempBoom : Boom!
extension FightPlayer: OnlineGameObjectType {
    
    func toDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
       // dict.updateValue(self.roleName, forKey: "roleName")
        dict.updateValue(self.mapCellIndex, forKey: "mapCellNumber")
//        dict.updateValue(self.isInitFireBoll, forKey: "isInitFireBoll")
//        dict.updateValue(self.isThrowFire, forKey: "isThrowFire")
//        if self.isThrowFire == true {
//            let percentX = self.currentHuoqiu.dircspeed.dx / screenSize.width
//            let percentY = self.currentHuoqiu.dircspeed.dy / screenSize.height
//            dict.updateValue(percentX, forKey: "percentX")
//            dict.updateValue(percentY, forKey: "percentY")
//            self.isThrowFire = false
//        }
//        self.isInitFireBoll = false
       // let json = JSON(dict)
        return dict
        
    }
    
    func toInitSkill(dict: [String: AnyObject]) -> [String: AnyObject] {
        return dict
    }
    
    func toReleaseSkill(dict: [String: AnyObject]) -> [String: AnyObject] {

        
        
//        let json = JSON(dict)
        return dict
    }
    
    func toResult(result: String) -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        dict.updateValue(result, forKey: "result")
        return dict
    }
    
    func fromDictionary(json: JSON) {
       // self.roleName = json["rolename"].stringValue
        self.mapCellIndex = json["mapCellNumber"].intValue

//        self.isInitFireBoll = json["isInitFireBoll"].boolValue
//        if json["isThrowFire"].boolValue == true {
//            self.isThrowFire = true
//            let percentX = CGFloat(json["percentX"].floatValue)
//            let percentY = CGFloat(json["percentY"].floatValue)
//            self.fireVector = SkillSystem.reversalVector(percentX, percentY: percentY)
//        }
    }
    
    func fromInitSkill(json: JSON) {
        //dict.updateValue(SkillName.fire.rawValue, forKey: "initSkill")
        if json["initSkill"].stringValue == SkillName.fire.rawValue {
            self.createSkillSprite(FireSystem.self)
        }
        
        if json["initSkill"].stringValue == SkillName.boom.rawValue {
            self.createSkillSprite(BoomSystem.self)
        }
        
        if json["initSkill"].stringValue == SkillName.wall.rawValue {
            self.createSkillSprite(WallSystem.self)
        }
    }
    
    func fromReleaseSkill(json: JSON) {
        if json["initSkill"].stringValue == SkillName.fire.rawValue {
            let percentX = CGFloat(json["percentX"].floatValue)
            let percentY = CGFloat(json["percentY"].floatValue)
            self.skillSystemForClass(FireSystem.self)?.throwSkill(SkillSystem.reversalVector(percentX, percentY: percentY))
          //  self.runCurrentSkill(FireSystem.self, speed: )
        }
        
        if json["initSkill"].stringValue == SkillName.boom.rawValue {
            let percentX = CGFloat(json["percentX"].floatValue)
            let percentY = CGFloat(json["percentY"].floatValue)
            
            self.skillSystemForClass(BoomSystem.self)?.noLaunchBoom!.position = SkillSystem.reversalPoint(percentX, percentY: percentY)
            self.skillSystemForClass(BoomSystem.self)?.noLaunchBoom!.isControl = false
            self.skillSystemForClass(BoomSystem.self)?.noLaunchBoom!.physicsBody?.dynamic = true
            let tempBoom = (self.skillSystemForClass(BoomSystem.self)?.noLaunchBoom)!
            self.skillSystemForClass(BoomSystem.self)?.boomArray.addObject((self.skillSystemForClass(BoomSystem.self)?.noLaunchBoom)!)
            self.skillSystemForClass(BoomSystem.self)?.noLaunchBoom = nil
            
          //  print("set--\(self.skillSystemForClass(BoomSystem.self)?.currentBoom.BoomID)")
            self.skillSystemForClass(BoomSystem.self)?.bogusBoomRun({
                let wait = SKAction.waitForDuration(7)
                let appear = SKAction.fadeAlphaTo(1, duration: 0.3)
//                let block = SKAction.runBlock({
//          //         print("chuxian-----\(tempBoom.BoomID)")
//                })
                tempBoom.runAction(SKAction.sequence([wait,appear]))
//                
            })
 
        }
        
        if json["initSkill"].stringValue == SkillName.wall.rawValue {
            let percentX = CGFloat(json["percentX"].floatValue)
            let percentY = CGFloat(json["percentY"].floatValue)
            
            self.skillSystemForClass(WallSystem.self)?.currentWall.wallSprite.position = SkillSystem.reversalPoint(percentX, percentY: percentY)
            self.skillSystemForClass(WallSystem.self)?.currentWall.isControl = false

            let wallMapCellNum = self.fightMap.getCurrentPointMapCell((self.skillSystemForClass(WallSystem.self)?.currentWall.wallSprite.position)!)
            (self.fightMap.mapArray.objectAtIndex(wallMapCellNum!) as! FTMapCell).obj = self.skillSystemForClass(WallSystem.self)?.currentWall
//            self.skillSystemForClass(WallSystem.self)?.currentWall.wallSprite.physicsBody?.dynamic = true
         //   let tempBoom = (self.skillSystemForClass(BoomSystem.self)?.currentBoom)!
            //  print("set--\(self.skillSystemForClass(BoomSystem.self)?.currentBoom.BoomID)")
//            self.skillSystemForClass(BoomSystem.self)?.bogusBoomRun({
//                let wait = SKAction.waitForDuration(7)
//                let appear = SKAction.fadeAlphaTo(1, duration: 0.3)
//                let block = SKAction.runBlock({
//                    //         print("chuxian-----\(tempBoom.BoomID)")
//                })
//                tempBoom.runAction(SKAction.sequence([wait,appear,block]))
//                //
//            })
            
        }

    }
//    func moveToCell(index: Int) {
//        
//    }
    
}









