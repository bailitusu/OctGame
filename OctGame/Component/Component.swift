//
//  Component.swift
//  Oct_Game
//
//  Created by zc on 16/6/10.
//  Copyright © 2016年 oct. All rights reserved.
//

import Foundation

class Component: NSObject {
    weak var entity:Entity?
    func willAddToEntity(entity: Entity) {
    
    }
    
    func didAddToEntity(entity: Entity) {
        
    }
    
    func willRemoveFromEntity(entity: Entity) {
        
    }
    
    func didRemoveFromEntity(entity: Entity) {
        
    }
    
    
    func updateWithDeltaTime(second: NSTimeInterval) {
        
    }
}
