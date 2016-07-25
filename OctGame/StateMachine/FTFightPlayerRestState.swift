//
//  FTFightPlayerRestState.swift
//  OctGame
//
//  Created by zc on 16/7/23.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit



class FTFightPlayerState: State {
    
    weak var player: FightPlayer?
    
    init(player: FightPlayer) {
        self.player = player
    }
    
}


class FTFightPlayerRestState: FTFightPlayerState {
    
    override func canEnterNextState(state: State) -> Bool {
        return true
    }
    
    override func didEnterWithPreviousState(previousState: State?) {
         FTAnimation.runAnimation(self.player!.sprite, role: FTRoleName.huangdi, state: FTAnimationState.rest, direction: FTDirection.none)
    }
    
    override func willExitWithNextState(nextState: State) {
        
    }
}
