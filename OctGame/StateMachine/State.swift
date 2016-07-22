//
//  State.swift
//  OctGame
//
//  Created by zc on 16/7/22.
//  Copyright © 2016年 oct. All rights reserved.
//

import Foundation


class State {
    
    weak var stateMachine: StateMachine?
    
    func canEnterNextState(state: State) -> Bool {
        return true
    }
    
    func didEnterWithPreviousState(previousState: State?) {
        
    }
    
    func willExitWithNextState(nextState: State) {
    
    }
    
    
}

//
//extension FightScene {
//    func initStateMachine() {
//        let stateMachine = StateMachine([GameBeginState(),
//                                        Game])
//        
//        let a = GameBeginState()
//        let b = GameFightState()
//        
//        self.machine = StateMachine([a, b])
//        a.stateMachine = machine
//        b.stateMachine = machine
//    }
//}