//
//  FTFightInjuredState.swift
//  OctGame
//
//  Created by zc on 16/7/23.
//  Copyright © 2016年 oct. All rights reserved.
//

import Foundation


class FTFightPlayerInjuredState: FTFightPlayerState {
    
    override func canEnterNextState(state: State) -> Bool {
        return true
    }
    
    override func didEnterWithPreviousState(previousState: State?) {
        //player animation
        
        //after 0.5s
        
        
        if let _ = self.stateMachine!.currentState! as? FTFightPlayerInjuredState {
            self.stateMachine?.enterState(previousState!)
        }
    }
    
    override func willExitWithNextState(nextState: State) {
        
    }
}