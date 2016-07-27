//
//  FTFightWalkState.swift
//  OctGame
//
//  Created by zc on 16/7/23.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class FTFightPlayerWalkState: FTFightPlayerState {
    var  toCell: FTMapCell?
    
    override func canEnterNextState(state: State) -> Bool {
        return true
    }
    
    override func didEnterWithPreviousState(previousState: State?) {
        self.MoveToCell(self.toCell!)
    }
    
    override func willExitWithNextState(nextState: State) {
        
    }
    
    func MoveToCell(locationSprite: FTMapCell) {
        if abs(locationSprite.position.x - self.player!.sprite.position.x) < locationSprite.size.width+1 && abs(locationSprite.position.y - self.player!.sprite.position.y) < locationSprite.size.height+1 {
            if locationSprite.obj == nil || ((locationSprite.obj as? Boom) != nil)  {
                let beforePlayerStandCell = self.player!.fightMap.mapArray.objectAtIndex(self.player!.fightMap.getCurrentPointMapCell(self.player!.sprite.position)!) as! FTMapCell
                beforePlayerStandCell.obj = nil

                locationSprite.obj = self.player!

                if locationSprite.position.x - self.player!.sprite.position.x > 1 {
                    self.player!.fangxiang = FTDirection.right
               
                }else if locationSprite.position.x - self.player!.sprite.position.x < -1 {
                    self.player!.fangxiang = FTDirection.left
                   
                }else if locationSprite.position.y - self.player!.sprite.position.y > 1 {
                    self.player!.fangxiang = FTDirection.up
                  
                }else if locationSprite.position.y - self.player!.sprite.position.y < -1 {
                    self.player!.fangxiang = FTDirection.down
                  
                }
                FTAnimation.runAnimation(self.player!.sprite, role: FTRoleName.huangdi, state: FTAnimationState.walk, direction: (self.player?.fangxiang)!)
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName("playerMove", object: self.player!, userInfo: ["moveToMapCell" : locationSprite])
                let move = SKAction.moveTo(locationSprite.position, duration: 0.3)
                let block = SKAction.runBlock({
                     self.stateMachine!.enterState(self.stateMachine!.getState(FTFightPlayerRestState.self)!)
                })
                self.player!.sprite.runAction(SKAction.sequence([move,block]))
            }

        }

    }

}