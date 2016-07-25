//
//  Animation.swift
//  OctGame
//
//  Created by zc on 16/7/22.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit
enum FTRoleName: String {
    case huangdi = "huangdi"
    case chiyou = "chiyou"
    var name: String {
        switch self {
        case .huangdi:
            return "huangdi"
        case .chiyou:
            return "chiyou"
        }
    }
    static var all = [huangdi,chiyou]
}

enum FTDirection: String {
    case left = "left"
    case right = "right"
    case up = "up"
    case down = "down"
    case none = "none"
    var name: String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        case .up:
            return "up"
        case .down:
            return "down"
        case .none:
            return "none"
        }
    }
    static var all = [left,right,up,down,none]
}
enum FTAnimationState: String {
    case walk = "walk"
    case rest = "rest"
    case createSkill = "createSkill"
    case releaseSkill = "releaseSkill"
    case injured = "injured"
    case dead = "dead"
    static var all = [createSkill,walk,rest,releaseSkill,injured,dead]
}
//enum FTAtlasName: String {
//    case walk = "walk"
//    case rest = "rest"
//    case createSkill = "createSkill"
//    static var all = [walk,rest,createSkill]
//}
//
//enum  FTOneTextureName: String {
//    case walk = "walk"
//    case rest = "rest"
//    case createSkill = "createSkill"
//    static var all = [walk,rest,createSkill]
//}

class FTAnimation {
//    var atlasNameDic = [FTAnimationState: FTAtlasName]()
    static var resourceDic = [String : [SKTexture]]()
    
    static func  addPlayerFTAnimationResource(ftUserArray: [SLUser]?) {

        for role in FTRoleName.all {
            for state in FTAnimationState.all {
                for direction in FTDirection.all {
                    let atlas = SKTextureAtlas(named: "\(role.rawValue)_\(state.rawValue)_\(direction.rawValue).atlas")
//                    if atlas == nil {
//                        break
//                    }
                    var textureArray = [SKTexture]()
                    var tempName: String
                    for j in 0 ..< atlas.textureNames.count {
                        tempName = "\(role.rawValue)_\(state.rawValue)_\(direction.rawValue)\(j).png"
                        let texture = atlas.textureNamed(tempName)
                        textureArray.append(texture)
                    }
                    resourceDic.updateValue(textureArray, forKey: "\(role.rawValue)_\(state.rawValue)_\(direction.rawValue)")
                }
            }
        }
    }
    
    static func runAnimation(sprite: SKSpriteNode, role: FTRoleName, state: FTAnimationState, direction: FTDirection) {
        
        let animationKey = "\(role.rawValue)_\(state.rawValue)_\(direction.rawValue)"
        sprite.removeActionForKey("kkk")
        let action = SKAction.repeatActionForever(SKAction.animateWithTextures(resourceDic[animationKey]!, timePerFrame: 0.05))
        sprite.runAction(action, withKey: "kkk")
    }
}















