//
//  AnimationComponent.swift
//  OctGame
//
//  Created by zc on 16/6/17.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

enum AnimationState: String {
    case walkLeft = "walkLeft"
    case walkRight = "walkRight"
    case frozenLeft = "frozenLeft"
    case frozenRight = "frozenRight"
 //   case wudi = "wudi"
//    case wudiLeft = "wudiLeft"
//    case wudiRight = "wudiRight"
//    case citieLeft = "citieLeft"
//    case citieRight = "citieRight"
//    case citie = "citie"
    case fenshen = "fenshen"
    case none = "none"
//    var oneTextureName: String {
//        switch self {
//        case .walkLeft:
//            return "xiaojiangshi_walk_left"
//        case .walkRight:
//            return "xiaojiangshi_walk_right"
//        case .frozenLeft:
//            return "xiaojiangshi_frozen_left"
//        case .frozenRight:
//            return "xiaojiangshi_frozen_right"
//        case .wudiLeft:
//            return "xiaojiangshi_wudi_left"
//        case .wudiRight:
//            return "xiaojiangshi_wudi_right"
//        case .citieLeft:
//            return "xiaojiangshi_citie_left"
//        case .citieRight:
//            return "xiaojiangshi_citie_right"
//        default:
//            return ""
//        }
//    }
     static var all = [walkLeft,walkRight,frozenLeft,frozenRight]
}
enum AtlasName: String {
    case walkLeft = "walkLeft"
    case walkRight = "walkRight"
    case frozenLeft = "frozenLeft"
    case frozenRight = "frozenRight"
//    case wudiLeft = "wudiLeft"
//    case wudiRight = "wudiRight"
//    case citieLeft = "citieLeft"
//    case citieRight = "citieRight"
    case wudi = "wudi"
    case citie = "citie"
    static var all = [walkLeft,walkRight,frozenLeft,frozenRight]
}
enum OneTextureName: String {
    case oneWalkLeft = "xiaojiangshi_walk_left"
    case oneWaltRight = "xiaojiangshi_walk_right"
    case oneFrozenLeft = "xiaojiangshi_frozen_left"
    case oneFrozenRight = "xiaojiangshi_frozen_right"
//    case oneWudiLeft = "xiaojiangshi_wudi_left"
//    case oneWudiRight = "xiaojiangshi_wudi_right"
//    case oneCitieLeft = "xiaojiangshi_citie_left"
//    case oneCitieRight = "xiaojiangshi_citie_right"
    case oneWudi = "wudiState"
    case oneCitie = "xitieshi"

    static var all = [oneWalkLeft,oneWaltRight,oneFrozenLeft,oneFrozenRight]
}



class AnimationComponent: Component {
    var time:NSTimeInterval!
//    init(duration:NSTimeInterval) {
//        self.time = duration
//    }
    var state:AnimationState
    var atlasDic = [AtlasName:SKTextureAtlas]()
    var animationDic = [AnimationState : [SKTexture]]()
    var prevState: AnimationState = .none
 //   var spriteAnimation:SKSpriteNode!
    var sprite:SKSpriteNode {
        return (self.entity?.componentForClass(SpriteComponent.self)?.sprite)!
    }
    override func didAddToEntity(entity: Entity) {
      //  self.addAnimationAtlas("\(AnimationState.walkLeft.rawValue).atlas", onetextur: "")
        self.addAllAnimationResource()
        self.entity?.atlas = atlasDic[AtlasName.walkLeft]
 
    }
    override init() {
        self.state = AnimationState.none
        super.init()
      //  self.spriteAnimation = SKSpriteNode()
    }
//    func addAnimationAtlas(atlasName:String, onetextur:String) {
//        self.entity?.atlas = SKTextureAtlas(named: atlasName)
//        var tempName:String
//        var arrayTexture = [SKTexture]()
//        for (var i = 1; i <= self.entity?.atlas.textureNames.count; i++) {
//            tempName = "\(onetextur)\(i).png"
//            let texture = self.entity?.atlas.textureNamed(tempName)
//            arrayTexture.append(texture!)
//        }
//    }
    func addAllAnimationResource() {
        var i = 0
        for atlasName in AtlasName.all {
            let atlas = SKTextureAtlas(named: "\(atlasName.rawValue).atlas")
            atlasDic.updateValue(atlas, forKey:AtlasName.all[i])
            var tempName:String
            var arrayTexture = [SKTexture]()
            for j in 1 ..< (atlas.textureNames.count+1) {
                tempName = "\(OneTextureName.all[i].rawValue)\(j).png"
                let texture = atlas.textureNamed(tempName)
                arrayTexture.append(texture)
            }
            animationDic.updateValue(arrayTexture, forKey: AnimationState.all[i])
            i += 1
        }
    }
//    func runAnimation(state:AnimationState) {
//        self.entity?.textureArray = animationDic[state]!
//    }
    override func updateWithDeltaTime(second: NSTimeInterval) {
    //    let state:AnimationState

        if self.state == .none {
            return
        }else {
            //        switch state {
            //        case .none :
            //            break
            //        case .walkLeft :
            //            self.runAnimation(.walkLeft)
            //        default:
            //            break
            //        }
            if self.state != self.prevState {
                if self.prevState != .none {
                   self.sprite.removeActionForKey(self.prevState.rawValue) 
                }
                
                self.sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(animationDic[state]!, timePerFrame: 0.05)), withKey: self.state.rawValue)
                self.prevState = self.state
            }
           // self.entity?.textureArray = animationDic[state]!
        }
    }
    
    
    
    
}
