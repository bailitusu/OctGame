//
//  SecondGame.swift
//  OctGame
//
//  Created by zc on 16/6/21.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit

class SecondGame : BaseScene , SKPhysicsContactDelegate{
   // var sheep: Sheep!
    var screenSize: CGSize!
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.screenSize = CGSize(width: self.frame.width, height: self.frame.height)
        self.backGround = SKSpriteNode(imageNamed: "road.jpg")
        self.backGround.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.backGround.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.backGround.zPosition = SpriteLevel.background.rawValue;
        self.addChild(self.backGround)
        
        let shanDianBtn = SpriteButton(titleText: "", normalImageName: "flash.png", callBack: { () -> () in
                self.electricSheep()
            }, frame: CGRect(x: self.frame.width*1/6, y: self.frame.height*1/6, width: 100, height: 100))
        shanDianBtn.zPosition = SpriteLevel.sprite.rawValue
        self.addChild(shanDianBtn)
        AddResource.addAllAnimationResource()
//        let map = Map(startPoint: CGPoint(x: 100, y: self.screenSize.height-100), EndPoint: CGPoint(x: self.screenSize.width-100, y: 100), ScreenSize: self.screenSize)
//        Map.MoveWithPath(sheep)
//        
//        let screen = UIScreen.mainScreen().bounds
//        let path = CGPathCreateMutable()
//        
//        let p = 10 as CGPoint
//        convertPoint(<#T##point: CGPoint##CGPoint#>, fromNode: <#T##SKNode#>) 
//       // let p = convertPoint(CGPoint(x, toNode: <#T##SKNode#>)
//        
//        CGPathMoveToPoint(path, nil, 100, 100)
//        //        path.lineWidth = 5.0
//        CGPathAddCurveToPoint(path, nil, 180,screen.height-100, 330,screen.height-200, screen.width-100,screen.height-100)
//        //  let context = UIGraphicsGetCurrentContext()
//        //        CGContextAddPath(ctx, path)
//        //        UIColor.blueColor().setStroke()
//        //        CGContextDrawPath(ctx, CGPathDrawingMode.Stroke)
////        CGPathAddRect(path, nil, CGRect(x: 180, y: screen.height-100, width: 1, height: 1))
////        CGPathAddRect(path, nil, CGRect(x: 230, y: screen.height-200, width: 1, height: 1))
//        let pathTrack = CAShapeLayer()
//        pathTrack.path = path
//        pathTrack.strokeColor = UIColor.blackColor().CGColor
//        pathTrack.fillColor = UIColor.clearColor().CGColor
//        pathTrack.lineWidth = 1.0
//        view.layer.addSublayer(pathTrack)
//
//        
//        let path1 = CGPathCreateMutable()
//        
//        CGPathMoveToPoint(path1, nil, 180, screen.height-100)
//        CGPathAddRect(path1, nil, CGRect(x: 180, y: screen.height-100, width: 3, height: 3))
//        CGPathAddRect(path1, nil, CGRect(x: 330, y: screen.height-200, width: 3, height: 3))
//        let pathTrack1 = CAShapeLayer()
//        pathTrack1.path = path1
//        pathTrack1.strokeColor = UIColor.blackColor().CGColor
//        pathTrack1.fillColor = UIColor.clearColor().CGColor
//        pathTrack1.lineWidth = 1.0
//        view.layer.addSublayer(pathTrack1)
        
    }
    func electricSheep() {
        let temp = CreateProduct.sheepArray[0] as! Sheep
        if temp.sprite.position.y <= 90 || temp.sprite.position.y >= 30 {
            temp.sprite.removeAllActions()
            //let dianji =
        }
    }
    override func update(currentTime: NSTimeInterval) {
        if CreateProduct.sheepArray.count != 0 {
            for temp in CreateProduct.sheepArray {
                if let realSheep = temp as? Sheep {
                    if realSheep.sprite.position.y <= self.screenSize.height/2 {
                        if realSheep.state == AnimationState.walkLeft {
                            realSheep.sprite.removeActionForKey("realSheep.state")
                            realSheep.state = AnimationState.walkRight
                            realSheep.runAnimation(realSheep.state)
                        }
                    }
                }
                
            }
            
            
            
            let tempSprite = CreateProduct.sheepArray[0] as! Sheep
            if tempSprite.sprite.position.y <= 25 {
                CreateProduct.sheepArray.removeObjectAtIndex(0)
                tempSprite.sprite.removeAllActions()
                tempSprite.sprite.removeFromParent()
            }
        }
    }
    func start() {

        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(SecondGame.createSheep), userInfo: nil, repeats: true)

    }
    
    func createSheep() {
        let sheep = CreateProduct.createSheep()
        sheep.sprite.position = CGPoint(x: 420, y: self.screenSize.height-110)
        self.addChild(sheep.sprite)
//        sheep.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(AddResource.animationDic[AnimationState.walkLeft]!, timePerFrame: 0.05)), withKey: AnimationState.walkLeft.rawValue)
        sheep.runAnimation(AnimationState.walkLeft)
        let map = Map(startPoint: CGPoint(x: 420, y: self.screenSize.height-110), EndPoint: CGPoint(x: 500, y: 100))
        map.MoveWithPath(sheep.sprite, speed: 5)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.start()
    }
}

