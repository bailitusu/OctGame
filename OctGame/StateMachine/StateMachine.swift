//
//  StateMachine.swift
//  OctGame
//
//  Created by zc on 16/7/22.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class StateMachine {
    
    var currentState: State?
    
    var stateArray = [State]()
    
    init(_ stateArray: [State]) {
        self.stateArray = stateArray.map {
            $0.stateMachine = self
            return $0
        }
        self.currentState = stateArray[0]
        self.currentState?.didEnterWithPreviousState(nil)
    }
    
    func enterState(state: State) -> Bool {
        if self.currentState != nil {
            self.currentState?.willExitWithNextState(state)
            
        }
        
        if (self.currentState?.canEnterNextState(state))! == true {
            let preState = self.currentState
            self.currentState = state
            self.currentState?.didEnterWithPreviousState(preState)
            return true
        }
        return false
    }
    
    func getState<state: State>(stateClass: state.Type)->state? {
        for temp in self.stateArray {
            if let result = temp as? state {
                return result
            }
        }
        return nil
    }
//    func stateForClass
}
