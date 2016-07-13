//
//  Skill.swift
//  OctGame
//
//  Created by zc on 16/7/1.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit
import Starscream
class SkillSystem {

    var entityName: String!
    var skillSpeed: CGVector!
    var entity: Entity!
    var touchPointArray: NSMutableArray!
    var harmAreas = [HarmArea]()
    var bollGroup: Int!
//    init() {
//    //    super.init()
////        self.entity = entity
////        self.entityName = entityName
//        
//    }
//    
    
//    
//    func createSkill(skill: Skill) {
//        skill.initSkill()
//    }
//    
//    func runSkill (skill: Skill) {
//        skill.throwSkill()
//    }
    
    func willAddHarmArea(area: HarmArea) {
        
    }
    
    func addHarmArea(harmArea: HarmArea) {
        self.willAddHarmArea(harmArea)
        self.harmAreas.append(harmArea)
        self.didAddHarmArea(harmArea)
    }
    
    func didAddHarmArea(area: HarmArea) {
        
    }
    
    func  addSkillObserver() {
        
    }
    
    func harmAreaForClass<harmArea: HarmArea>(harmAreaClass:harmArea.Type)->harmArea? {
        for temp in self.harmAreas {
            if let result = temp as? harmArea {
                return result
            }
        }
        return nil
    }
    
    func reckonHarmArea(toHarmPlayer: FightPlayer, originalConterPoint: CGPoint) {
        
    }
    func throwSkill() {
    
    }
    
    func initSkill(initBitmask: UInt32)  {
        
    }
    
    func didContact(contact: SKPhysicsContact) {
        
    }
    
    func toucheBegan(touches: Set<UITouch>, withEvent event: UIEvent?,scene: FightScene) {
        
    }
    
    func toucheMoved(touches: Set<UITouch>, withEvent event: UIEvent?,scene: FightScene) {
        
    }
    
    func toucheEnded(touches: Set<UITouch>, withEvent event: UIEvent?,scene: FightScene) {
        
    }
    
    func checkState(time: NSTimeInterval) {
        
    }
    
    static func reckonSkillSpeed(speed: CGVector)->CGVector {
        let mo = sqrt( speed.dx*speed.dx+speed.dy*speed.dy)
        let unitX = speed.dx/mo
        let unitY = speed.dy/mo
        return CGVector(dx:unitX*FightSkillSpeed.huoqiu, dy:unitY*FightSkillSpeed.huoqiu)
    }
    
    static func reversalVector(percentX:CGFloat,percentY:CGFloat) -> CGVector {

        let x = -screenSize.width*percentX
        let y = -screenSize.height*percentY
        return CGVector(dx: x, dy: y)
    }
    
    static func reversalPoint(percentX:CGFloat,percentY:CGFloat) -> CGPoint {
        let x = screenSize.width*(1-percentX)
        let y = screenSize.height*(1-percentY)
        return CGPoint(x: x, y: y)
    }
}
