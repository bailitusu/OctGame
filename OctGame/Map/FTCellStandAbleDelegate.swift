//
//  FTCellStandAbleDelegate.swift
//  OctGame
//
//  Created by zc on 16/7/14.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

protocol FTCellStandAbleDelegate {
    var HP: Int{set get}
    func didBeHit(hitValue: Int)
}
