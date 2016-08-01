//
//  CommonFunc.swift
//  OctGame
//
//  Created by zc on 16/6/27.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit
var skillcdArray: NSMutableArray = NSMutableArray()



class CommonFunc: NSObject {
    static func createRandomNum(minNum: UInt32, Max maxNum: UInt32) -> UInt32 {
        let temp = arc4random()%(maxNum-minNum+1)+minNum
        return temp
        
    }
    
    static func createSkillCd(imageName: String, size: CGSize, fillImageName: String, name: String)-> SKProgressNode {
        let skillNode = SKProgressNode(texture: SKTexture(imageNamed: imageName), size: size, fillSpriteName: fillImageName, name: name)
        return skillNode
    }
    
    static func reloadSkillPosition(removeSkillObj: SKProgressNode) {
     //   removeSkillObj.hidden = true
        var tempY:CGFloat = 0
        for i in 0 ..< skillcdArray.count {
            if removeSkillObj == (skillcdArray.objectAtIndex(i) as! SKProgressNode) {
                if skillcdArray.count < 2 {
                    break
                }else if i == (skillcdArray.count-1) {
                    break
                }else {
                    tempY = removeSkillObj.position.y - (skillcdArray.objectAtIndex(i+1) as! SKProgressNode).position.y
                }
                for j in i+1 ..< skillcdArray.count {
                    let move = SKAction.moveBy(CGVector(dx: 0, dy: tempY), duration: 0.3)
                    
                    (skillcdArray.objectAtIndex(j) as! SKProgressNode).runAction(move)
                }
                break
            }
        }
       // print("\(removeSkillObj.nodeName) will be removed")
        skillcdArray.removeObject(removeSkillObj)
        removeSkillObj.removeFromParent()
       // print("\(removeSkillObj.nodeName) removed")
    }
    static func hasThisProgressNode(thisNodeName: String) -> SKProgressNode? {
       // var hasThisNode = false
        if skillcdArray.count != 0 {
            for i in 0  ..< skillcdArray.count {
                if (skillcdArray.objectAtIndex(i) as! SKProgressNode).nodeName == thisNodeName {
                    // (skillcdArray.objectAtIndex(i) as! SKProgressNode).progress = 0
                    //         hasThisNode = true
                    return  (skillcdArray.objectAtIndex(i) as! SKProgressNode)
                }
            }
        }
        return nil
    }
    static func setSkillCdPosition(skillNode: SKProgressNode) {
        

        
        if skillcdArray.count == 0 {
            skillNode.position = CGPoint(x: skillNode.size.width/2+5, y: screenSize.height-100)
        }else {
            let temp = skillcdArray.lastObject as! SKProgressNode
            skillNode.position = CGPoint(x: skillNode.size.width/2+5, y: temp.position.y-temp.size.height-10)
        }

//        if skillcdArray.containsObject(skillNode) == true {
//            
//            //zc!! refresh bug
//            CommonFunc.runSkillCd(skillNode, timeCd: skillNode.time, completion: { () -> () in
//                 CommonFunc.reloadSkillPosition(skillNode)
//            })
        skillcdArray.addObject(skillNode)
        
    }
    
    static func runSkillCd(skillNode: SKProgressNode,timeCd: CGFloat, completion: ()->()) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
       // var progress: CGFloat = 0
        
        dispatch_async(queue) { () -> Void in
            while skillNode.progress < 1 {
                skillNode.progress = skillNode.progress + (0.1 / timeCd)
                skillNode.setFillAmount(skillNode.progress)
                NSThread.sleepForTimeInterval(0.1)
            }
          //  print("\(skillNode.nodeName) will be reloaded")
            completion()
          //  print("\(skillNode.nodeName) reloaded")
        }

    }
    
    static func skillMeun(imageName: String, size: CGSize, fillImageName: String,timeCd: CGFloat, scene: SKScene, name: String) {
        let skillNode = CommonFunc.createSkillCd(imageName, size: size, fillImageName: fillImageName, name: name)
        let node = hasThisProgressNode(skillNode.nodeName!)
        if  node == nil {
            scene.addChild(skillNode)
            skillNode.time = timeCd
            skillNode.zPosition = SpriteLevel.sprite.rawValue
            CommonFunc.setSkillCdPosition(skillNode)
            CommonFunc.runSkillCd(skillNode, timeCd: timeCd, completion: { () -> () in
                CommonFunc.reloadSkillPosition(skillNode)
            })

        } else {
            node!.reStart()
        }
    }
    
    
    static func finishCurrentSkillCd(currentNodeName: String) {
        let current = CommonFunc.hasThisProgressNode(currentNodeName)
        current?.finish()
    }
    
    static func initChongCiCd(scene: SKScene) -> SKProgressNode {
        let chongciNode: SKProgressNode! = CommonFunc.createSkillCd("huijiasu", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "jiasu", name: "chongci")
        chongciNode.time = 2.0
        chongciNode.zPosition = SpriteLevel.sprite.rawValue
        chongciNode.progress = 1
        chongciNode.setFillAmount(chongciNode.progress)
        chongciNode.position = CGPoint(x: screenSize.width - chongciNode.size.width/2-5, y: screenSize.height/2)
        scene.addChild(chongciNode)
        return chongciNode
    }
    
    static func fightIsEqualPoint(pointA: CGPoint, pointB: CGPoint) -> Bool{
        if Int(pointA.x) == Int(pointB.x) && Int(pointA.y) == Int(pointB.y) {
            return true
        }
        return false
    }
    
    static func fightPointDistance(pointA: CGPoint, pointB: CGPoint) -> UInt32 {
        let distance = (pointA.x-pointB.x)*(pointA.x-pointB.x)+(pointA.y-pointB.y)*(pointA.y-pointB.y)
        return UInt32(distance)
    }
}




public extension Double {
    public static func random(lower: Double = 0.5, Max upper: Double = 1) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}
