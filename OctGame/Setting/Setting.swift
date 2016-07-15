//
//  Setting.swift
//  OctGame
//
//  Created by zc on 16/6/23.
//  Copyright © 2016年 oct. All rights reserved.
//


import UIKit
import SpriteKit

let fightMapCellSize: CGSize = CGSize(width: screenSize.width/5.5, height: screenSize.width/5.5/5*4)

let userID:Int = 123

let screenSize = UIScreen.mainScreen().bounds

let playerSize: CGSize = CGSize(width: screenSize.width*0.105, height: screenSize.width*0.105*10/7)

let enemySize: CGSize = CGSize(width: screenSize.width*0.09, height: screenSize.width*0.09)

//let fightPlayerSize: CGSize = CGSize(width: screenSize.width*0.133, height: screenSize.width*0.133)
let fightPlayerSize: CGSize = CGSize(width: screenSize.width/5.5, height: screenSize.width/5.5)
let cloudSize: CGSize = CGSize(width: screenSize.width*0.238, height: screenSize.width*0.238*40/53)

var createProductSpeed: NSTimeInterval = 1
var throwBadPropSpeed: NSTimeInterval = 1
let createProductSpeedMax: NSTimeInterval = 0.2
var gravity: CGVector = CGVector(dx: 0, dy: -3)
let gravityMax: CGVector = CGVector(dx: 0, dy: -10)
struct GoldSizeType {
   static let gold = CGSize(width: screenSize.width*0.03, height: screenSize.width*0.03)
   static let crystal = CGSize(width: screenSize.width*0.08, height: screenSize.width*0.08)
}

struct PropSizeType {
   static var prop = CGSize(width: screenSize.width*0.045, height: screenSize.width*0.045)
}

struct VelocityType {
    static var playerVelocity = screenSize.width*0.03
    static var enemyVelocity = screenSize.width*0.03*1.2
    static let velocityMax = screenSize.width*0.03*4
}

struct BuffTime {
    static let wudi = 1000.0
    static let wuyun = 5.0
    static let dingshen = 2.0
    static let bianxiao = 1000.0
    static let bianda = 1000.0
    static let citie = 2.0
}

struct SkillSize {
    static let huoqiu = CGSize(width: screenSize.width*0.08, height: screenSize.width*0.08)
    static let dilei = CGSize(width: screenSize.width*0.08, height: screenSize.width*0.08)
    static let wall = CGSize(width: screenSize.width*0.16, height: screenSize.width*0.16)
}

struct FightSkillSpeed {
    static let huoqiu: CGFloat = 400.0
}

struct FightSkillCollideMaxCount {
    static let huoqiu:UInt32 = 5
}














