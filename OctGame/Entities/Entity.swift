//
//  Entity.swift
//  Oct_Game
//
//  Created by zc on 16/6/10.
//  Copyright © 2016年 oct. All rights reserved.
//

import Foundation
import SpriteKit
class Entity: NSObject {
    var components = [Component]()
    var atlas:SKTextureAtlas!
    var textureArray = [SKTexture]()
//    var dic:NSMutableDictionary!
 //   var runAnimationTime:NSTimeInterval!
    
    func addComponent(component: Component) {
        component.willAddToEntity(self)
        self.components.append(component)
        component.entity = self
        component.didAddToEntity(self)
    }
    
    func componentForClass<componentType: Component>(componentClass:componentType.Type)->componentType? {
        for com in self.components {
            if let result = com as? componentType {
                return result
            }
        }
        return nil
    }
    func updateWithDeltaTime(second: NSTimeInterval) {
        for component in self.components {
            component.updateWithDeltaTime(second)
        }
    }
    
    func removeComponent(componentClass: Component.Type) {
        
        self.components = components.filter() {
            if $0.classForCoder == componentClass {
                $0.willRemoveFromEntity(self)
                return false
            }
            return true
        }
        
    }
    func hasComponent<componentType: Component>(componentClass: componentType.Type) -> Bool {
        return (self.componentForClass(componentClass) != nil)
    }

}
