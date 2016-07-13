//
//  CheckCollide.swift
//  OctGame
//
//  Created by zc on 16/6/16.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit


class AddResource: NSObject {
   static var atlasDic = [AtlasName:SKTextureAtlas]()
   static var animationDic = [AnimationState : [SKTexture]]()
    
    static func addEntityAtlas(entity:Entity,atlasName name:String) {
      //  self.textureDic.setValue(entity, forKey: key)
        entity.atlas = SKTextureAtlas(named: "\(name).atlas")
    }
    
    static func addAllAnimationResource() {
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

    
//    
//    static func loadTexture(name: String) {
//        var a = [AnimationState: [Direction: Animation]]()
//        
//        for state in AnimationState.all {
//            for dir in Direction.all {
//                a.updateValue([dir: loadSingleTexture(name, state: state, dir: dir)], forKey: state)
//            }
//        }
//        
//    }
//    
//    static func loadSingleTexture(name: String, state: AnimationState, dir: Direction) -> Animation {
//        let file = "\(name)_\(state)_\(dir)"
//    }
    
}
