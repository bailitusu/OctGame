//
//  FTFightWalkState.swift
//  OctGame
//
//  Created by zc on 16/7/23.
//  Copyright © 2016年 oct. All rights reserved.
//

import Foundation


class FTFightPlayerWalkState: FTFightPlayerState {
    
    override func canEnterNextState(state: State) -> Bool {
        return true
    }
    
    override func didEnterWithPreviousState(previousState: State?) {
        FTAnimation.runAnimation(self.player!.sprite, role: FTRoleName.huangdi, state: FTAnimationState.walk, direction: (self.player?.fangxiang)!)
    }
    
    override func willExitWithNextState(nextState: State) {
        
    }
}