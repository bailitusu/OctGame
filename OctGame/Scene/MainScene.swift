//
//  MainScene.swift
//  Oct_Game
//
//  Created by zc on 16/6/10.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit
enum GameState {
    case unstart
    case start
    case finish
    case stop
}
class MainScene: BaseScene,SKPhysicsContactDelegate {
    var player :Player!
    var zombie :Zombie!
    var fenshen:FenShen!
    var enemy:Enemy!
    var screenSize : CGSize!
    var state:GameState = GameState.unstart
    var chongciNode: SKProgressNode!
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        backGround = SKSpriteNode(imageNamed: "jjc.jpg")
        backGround.size = CGSize(width: (self.frame.width), height: (self.frame.height))
        backGround.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backGround.zPosition = SpriteLevel.background.rawValue;
        
        self.addChild(backGround)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = gravity
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.screenSize = CGSize(width: self.frame.width, height: self.frame.height)
        player = Player(screenView: self.screenSize)
        player.sprite.position = CGPoint(x: self.screenSize.width/2, y: player.sprite.size.height/2)
        zombie = Zombie(screenView: self.screenSize)
        zombie.sprite.position = CGPoint(x: self.screenSize.width/2, y: self.screenSize.height-zombie.sprite.size.height/2)
     //   zombie.sprite.position = CGPoint(x: 50, y: self.screenSize.height-zombie.sprite.size.height/2)
        enemy = Enemy()
        enemy.sprite.position = CGPoint(x: self.screenSize.width/3, y: self.screenSize.height-enemy.sprite.size.height/2)
        
        addEntity(player)
        addEntity(zombie)
        addEntity(enemy)
        fenshen = FenShen(zhushen: player, screenView: self.screenSize)
//        addEntity(fenshen)
//        player.addComponent(FenshenComponent(screenSize: self.screenSize, fenShen: fenshen,duration: 100.0))
        configBitMask()
        
       chongciNode = CommonFunc.initChongCiCd(self)
       // addTapGesture()
    }
    func addTapGesture() {
        let single:UITapGestureRecognizer  = UITapGestureRecognizer(target: self, action: #selector(MainScene.handleSingle(_:)))
        single.numberOfTapsRequired = 1
        single.numberOfTouchesRequired = 1
        self.view?.addGestureRecognizer(single)
        
        let double = UITapGestureRecognizer(target: self, action: #selector(MainScene.handleDoubleTap(_:)))
        double.numberOfTapsRequired = 2
        double.numberOfTouchesRequired = 1
        self.view?.addGestureRecognizer(double)
        [single .requireGestureRecognizerToFail(double)]
    }
    func configBitMask() {
        self.physicsBody?.categoryBitMask = BitMaskType.background
        
        player.physicsBody?.categoryBitMask = BitMaskType.player
        player.physicsBody?.collisionBitMask = BitMaskType.gold | BitMaskType.player
        player.physicsBody?.contactTestBitMask = BitMaskType.gold
        player.physicsBody?.fieldBitMask = 0
     
        zombie.physicsBody?.categoryBitMask = BitMaskType.zombie
        zombie.physicsBody?.collisionBitMask = BitMaskType.zombie
        zombie.physicsBody?.contactTestBitMask = BitMaskType.zombie
        zombie.physicsBody?.fieldBitMask = 0
        
        enemy.physicsBody?.categoryBitMask = BitMaskType.enemy
        enemy.physicsBody?.collisionBitMask = BitMaskType.enemy
        enemy.physicsBody?.contactTestBitMask = BitMaskType.enemy
        enemy.physicsBody?.fieldBitMask = 0
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        let animationComponent = player.componentForClass(AnimationComponent.self)
        
        if bodyA.categoryBitMask == BitMaskType.gold {
            if bodyB.categoryBitMask == BitMaskType.background || bodyB.categoryBitMask == BitMaskType.player {
                bodyA.node?.removeFromParent()
            }
        }else if bodyB.categoryBitMask == BitMaskType.gold {
            if bodyA.categoryBitMask == BitMaskType.background || bodyA.categoryBitMask == BitMaskType.player  {
                bodyB.node?.removeFromParent()
            }
        }
        //定身
        if bodyA.categoryBitMask == BitMaskType.dingShen {
            if bodyB.categoryBitMask == BitMaskType.player {
                bodyA.node?.removeFromParent()
                if player.hasComponent(InvincibleComponent.self) == false {
                    if player.velocity > 0 {
                        animationComponent?.state = AnimationState.frozenRight
                    }else if player.velocity < 0 {
                        animationComponent?.state = AnimationState.frozenLeft
                    }
                    player.addComponent(HaltComponent(duration: BuffTime.dingshen))
                    player.velocity = 0
                    CommonFunc.skillMeun("dingshen", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huidingshen", timeCd: CGFloat(BuffTime.dingshen), scene: self, name: "dingshen")
                    print("commonfunc skillmenu over")
                }else {
                    player.removeComponent(InvincibleComponent.self)
                    CommonFunc.finishCurrentSkillCd("wudi")
                }
            }
            if bodyA.categoryBitMask == BitMaskType.background {
                bodyA.node?.removeFromParent()
            }
        }else if bodyB.categoryBitMask == BitMaskType.dingShen {

            if bodyA.categoryBitMask == BitMaskType.player {
                bodyB.node?.removeFromParent()
                if player.hasComponent(InvincibleComponent.self) == false {
                    if player.velocity > 0 {
                        animationComponent?.state = AnimationState.frozenRight
                    }else if player.velocity < 0 {
                        animationComponent?.state = AnimationState.frozenLeft
                    }
                    player.addComponent(HaltComponent(duration: BuffTime.dingshen))
                    player.velocity = 0
                    CommonFunc.skillMeun("dingshen", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huidingshen", timeCd: CGFloat(BuffTime.dingshen), scene: self,name: "dingshen")
                                        print("commonfunc skillmenu over")
                }else {
                    player.removeComponent(InvincibleComponent.self)
                    CommonFunc.finishCurrentSkillCd("wudi")
                }
            }
            if bodyA.categoryBitMask == BitMaskType.background {
                bodyB.node?.removeFromParent()
            }
        }
        //变小
        if bodyA.categoryBitMask == BitMaskType.changeSmall {
            if bodyB.categoryBitMask == BitMaskType.player {
                bodyA.node?.removeFromParent()
                if player.componentForClass(LargenMinifyComponent.self)?.isBig == true {
                    player.removeComponent(LargenMinifyComponent.self)
                    CommonFunc.finishCurrentSkillCd("bianda")
                }else {
                    player.addComponent(LargenMinifyComponent(isBig: false, duration: BuffTime.bianxiao))
                    CommonFunc.skillMeun("bianxiao", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huibianxiao", timeCd: CGFloat(BuffTime.bianxiao), scene: self,name: "bianxiao")
                }
            }
            if bodyB.categoryBitMask == BitMaskType.background {
                bodyA.node?.removeFromParent()
            }
        }else if bodyB.categoryBitMask == BitMaskType.changeSmall {
            if bodyA.categoryBitMask == BitMaskType.player {
                bodyB.node?.removeFromParent()
                if player.componentForClass(LargenMinifyComponent.self)?.isBig == true {
                    player.removeComponent(LargenMinifyComponent.self)
                    CommonFunc.finishCurrentSkillCd("bianda")
                }else {
                    player.addComponent(LargenMinifyComponent(isBig: false, duration: BuffTime.bianxiao))
                    CommonFunc.skillMeun("bianxiao", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huibianxiao", timeCd: CGFloat(BuffTime.bianxiao), scene: self,name: "bianxiao")
                }
                
            }
            if bodyA.categoryBitMask == BitMaskType.background {
                bodyB.node?.removeFromParent()
            }
        }
        //变大
        if bodyA.categoryBitMask == BitMaskType.changeBig {
            if bodyB.categoryBitMask == BitMaskType.player {
                bodyA.node?.removeFromParent()
                if player.componentForClass(LargenMinifyComponent.self)?.isBig == false {
                    player.removeComponent(LargenMinifyComponent.self)
                    CommonFunc.finishCurrentSkillCd("bianxiao")
                }else {
                    player.addComponent(LargenMinifyComponent(isBig: true, duration: BuffTime.bianda))
                    CommonFunc.skillMeun("bianda", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huibianda", timeCd: CGFloat(BuffTime.bianda), scene: self,name: "bianda")
                }
            }
            if bodyB.categoryBitMask == BitMaskType.background {
                bodyA.node?.removeFromParent()
            }
        }else if bodyB.categoryBitMask == BitMaskType.changeBig {
            if bodyA.categoryBitMask == BitMaskType.player {
                bodyB.node?.removeFromParent()
                if player.componentForClass(LargenMinifyComponent.self)?.isBig == false {
                    player.removeComponent(LargenMinifyComponent.self)
                    CommonFunc.finishCurrentSkillCd("bianxiao")
                }else {
                    player.addComponent(LargenMinifyComponent(isBig: true, duration: BuffTime.bianda))
                    CommonFunc.skillMeun("bianda", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huibianda", timeCd: CGFloat(BuffTime.bianda), scene: self,name: "bianda")
                }
            }
            if bodyA.categoryBitMask == BitMaskType.background {
                bodyB.node?.removeFromParent()
            }
        }
        //吸铁石
        if bodyA.categoryBitMask == BitMaskType.magnet {
            if bodyB.categoryBitMask == BitMaskType.player {
                bodyA.node?.removeFromParent()
//                if player.velocity > 0 {
//                    animationComponent?.state = AnimationState.citie
//                }else if player.velocity < 0 {
//                    animationComponent?.state = AnimationState.citie
//                }
                player.addComponent(MagnetComponent(duration: BuffTime.citie))
                CommonFunc.skillMeun("xitieshi", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huicitie", timeCd: CGFloat(BuffTime.citie), scene: self, name: "xitieshi")
            }
            if bodyB.categoryBitMask == BitMaskType.background {
                bodyA.node?.removeFromParent()
            }
        }else if bodyB.categoryBitMask == BitMaskType.magnet {
            if bodyA.categoryBitMask == BitMaskType.player {
                bodyB.node?.removeFromParent()
//                if player.velocity > 0 {
//                    animationComponent?.state = AnimationState.citie
//                }else if player.velocity < 0 {
//                    animationComponent?.state = AnimationState.citie
//                }
                player.addComponent(MagnetComponent(duration: BuffTime.citie))
                CommonFunc.skillMeun("xitieshi", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huicitie", timeCd: CGFloat(BuffTime.citie), scene: self, name: "xitieshi")
            }
            if bodyA.categoryBitMask == BitMaskType.background {
                bodyB.node?.removeFromParent()
            }
        }
        //分身
        if bodyA.categoryBitMask == BitMaskType.fenshen {
            if bodyB.categoryBitMask == BitMaskType.player {
                bodyA.node?.removeFromParent()
                if fenshen.sprite.parent == nil {
                    if player.sprite.position.x >= self.screenSize.width/2 {
                        fenshen.fenshenDirection = "left"
                       // fenshen.position.x = player.sprite.position.x-player.sprite.size.width
                    }else {
                        fenshen.fenshenDirection = "right"
                       // fenshen.position.x = player.sprite.position.x+player.sprite.size.width
                    }
                    addEntity(fenshen)
                    player.addComponent(FenshenComponent(screenSize: self.screenSize, fenShen: fenshen,duration: 2.0))
                }
            }
            if bodyB.categoryBitMask == BitMaskType.background {
                bodyA.node?.removeFromParent()
            }
        }else if bodyB.categoryBitMask == BitMaskType.fenshen {
            if bodyA.categoryBitMask == BitMaskType.player {
                bodyB.node?.removeFromParent()
                if fenshen.sprite.parent == nil {
                    if player.sprite.position.x >= self.screenSize.width/2 {
                        fenshen.fenshenDirection = "left"
                        // fenshen.position.x = player.sprite.position.x-player.sprite.size.width
                    }else {
                        fenshen.fenshenDirection = "right"
                        // fenshen.position.x = player.sprite.position.x+player.sprite.size.width
                    }
                    addEntity(fenshen)
                    player.addComponent(FenshenComponent(screenSize: self.screenSize, fenShen: fenshen,duration: 2.0))
                }

            }
            if bodyA.categoryBitMask == BitMaskType.background {
                bodyB.node?.removeFromParent()
            }
        }
        //炸弹
        if bodyA.categoryBitMask == BitMaskType.boom {
            if bodyB.categoryBitMask == BitMaskType.player {
                bodyA.node?.removeFromParent()
                if player.hasComponent(InvincibleComponent.self) == false {
                    let gameOverScreen = BeginScene()
                    gameOverScreen.size = self.view!.frame.size
                    let door = SKTransition.doorsCloseHorizontalWithDuration(2.0)
                    self.view!.presentScene(gameOverScreen, transition: door)
                }else {
                    player.removeComponent(InvincibleComponent.self)
                    CommonFunc.finishCurrentSkillCd("wudi")
                }

            }
            if bodyB.categoryBitMask == BitMaskType.background {
                bodyA.node?.removeFromParent()
            }
        }else if bodyB.categoryBitMask == BitMaskType.boom {
            if bodyA.categoryBitMask == BitMaskType.player {
                bodyB.node?.removeFromParent()
                if player.hasComponent(InvincibleComponent.self) == false {
                    let gameOverScreen = BeginScene()
                    gameOverScreen.size = self.view!.frame.size
                    let door = SKTransition.doorsCloseHorizontalWithDuration(2.0)
                    self.view!.presentScene(gameOverScreen, transition: door)
                }else {
                    player.removeComponent(InvincibleComponent.self)
                    CommonFunc.finishCurrentSkillCd("wudi")
                }
            }
            if bodyA.categoryBitMask == BitMaskType.background {
                bodyB.node?.removeFromParent()
            }
        }
        //无敌
        if bodyA.categoryBitMask == BitMaskType.wudi {
            if bodyB.categoryBitMask == BitMaskType.player {
                bodyA.node?.removeFromParent()
//                if player.velocity > 0 {
//                    animationComponent?.state = AnimationState.wudiRight
//                }else if player.velocity < 0 {
//                    animationComponent?.state = AnimationState.wudiLeft
//                }
              //  animationComponent?.state = AnimationState.wudi
                player.addComponent(InvincibleComponent(duration: BuffTime.wudi))
                CommonFunc.skillMeun("wudi", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huiwudi", timeCd: CGFloat(BuffTime.wudi), scene: self, name: "wudi")
            }
            if bodyB.categoryBitMask == BitMaskType.background {
                bodyA.node?.removeFromParent()
            }
        }else if bodyB.categoryBitMask == BitMaskType.wudi {
            if bodyA.categoryBitMask == BitMaskType.player {
                 bodyB.node?.removeFromParent()
//                if player.velocity > 0 {
//                    animationComponent?.state = AnimationState.wudiRight
//                }else if player.velocity < 0 {
//                    animationComponent?.state = AnimationState.wudiLeft
//                }
              //  animationComponent?.state = AnimationState.wudi
                player.addComponent(InvincibleComponent(duration: BuffTime.wudi))
                CommonFunc.skillMeun("wudi", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huiwudi", timeCd: CGFloat(BuffTime.wudi), scene: self, name: "wudi")
            }
            if bodyA.categoryBitMask == BitMaskType.background {
                bodyB.node?.removeFromParent()
            }
        }
        //乌云
        if bodyA.categoryBitMask == BitMaskType.wuyun {
            if bodyB.categoryBitMask == BitMaskType.player {
                bodyA.node?.removeFromParent()
                player.addComponent(BlackCloudComponent(duration: BuffTime.wuyun))
                CommonFunc.skillMeun("wuyun", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huiwuyun", timeCd: CGFloat(BuffTime.wuyun), scene: self, name: "wuyun")
            }
            if bodyB.categoryBitMask == BitMaskType.background {
                bodyA.node?.removeFromParent()
            }
        }else if bodyB.categoryBitMask == BitMaskType.wuyun {
            if bodyA.categoryBitMask == BitMaskType.player {
                bodyB.node?.removeFromParent()
                player.addComponent(BlackCloudComponent(duration: BuffTime.wuyun))
                CommonFunc.skillMeun("wuyun", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huiwuyun", timeCd: CGFloat(BuffTime.wuyun), scene: self, name: "wuyun")
            }
            if bodyA.categoryBitMask == BitMaskType.background {
                bodyB.node?.removeFromParent()
            }
        }
    }
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
    }

    func handleSingle(pointValue:NSValue) {
        let touchPoint = pointValue.CGPointValue()
        let animation = player.componentForClass(AnimationComponent.self)
        if player.hasComponent(HaltComponent.self) == true {
         //   player.velocity = 0
            return
        }
        if player.hasComponent(LargenMinifyComponent.self) == true {
            
            if touchPoint.x > player.sprite.position.x {
                if player.componentForClass(LargenMinifyComponent.self)?.isBig == true {
                    player.velocity = VelocityType.playerVelocity/1.2
                }else {
                    player.velocity = VelocityType.playerVelocity*1.2
                }
                animation?.state = AnimationState.walkRight
            } else {
                if player.componentForClass(LargenMinifyComponent.self)?.isBig == true {
                    player.velocity = -VelocityType.playerVelocity/1.2
                }else {
                    player.velocity = -VelocityType.playerVelocity*1.2
                }
                //player.velocity = -abs(player.velocity)
                animation?.state = AnimationState.walkLeft
            }
            

                //  temp.velocity = temp.velocity*1.5
            return
        }
        if touchPoint.x > player.sprite.position.x {
            player.velocity = VelocityType.playerVelocity
            animation?.state = AnimationState.walkRight
        } else {
            player.velocity = -VelocityType.playerVelocity
            animation?.state = AnimationState.walkLeft
        }
        //    player.addComponent(LargenMinifyComponent(isBig: true, duration: 2.0))

    }
    func handleDoubleTap(pointValue:NSValue) {
        let touchPoint = pointValue.CGPointValue()
      //  var movement = player.componentForClass(MovementComponent.self)
        let animation = player.componentForClass(AnimationComponent.self)
        if player.hasComponent(HaltComponent.self) == true {
            return
        }
        if touchPoint.x > player.sprite.position.x{
           // player.addComponent(DashComponent(duration: 0.1))
//            let right = SKAction.moveByX(80, y: 0, duration: 0.2)
//            player.sprite.runAction(right)
       //     movement?.dashFlag = "chongci"
         //   movement?.velocity = 80
            if animation?.state != AnimationState.walkRight {
                animation?.state = AnimationState.walkRight
            }
//            if VelocityType.playerVelocity*2 >= VelocityType.velocityMax {
//                player.velocity = VelocityType.velocityMax
//            }else {
//            if player.hasComponent(LargenMinifyComponent.self) == true {
//                player.velocity = abs(player.velocity)*2
//            }else {
//                player.velocity = VelocityType.playerVelocity*2
//            }
//            }
            if Int(chongciNode.progress) == 1 {
                player.chongci("right")
                chongciNode.reStart()
                CommonFunc.runSkillCd(chongciNode, timeCd: chongciNode.time, completion: { () -> () in
                    
                })
            }
            
//            let wait = SKAction.waitForDuration(0.1)
//            let block = SKAction.runBlock({ () -> Void in
//                self.player.velocity = VelocityType.playerVelocity
//            })
//            player.sprite.runAction(SKAction.sequence([wait,block]))

            if player.hasComponent(FenshenComponent.self) {
//                movement = fenshen.componentForClass(MovementComponent.self)
//                movement?.dashFlag = "chongci"
//                movement?.velocity = 80
                fenshen.velocity = 80
            }

        }else if touchPoint.x < player.sprite.position.x{
//           // player.addComponent(DashComponent(duration: 0.1))
//            let left = SKAction.moveByX(-80, y: 0, duration: 0.2)
//            player.sprite.runAction(left)
//            if player.hasComponent(FenshenComponent.self) {
//                fenshen.sprite.runAction(left)
//            }

            if animation?.state != AnimationState.walkLeft {
                animation?.state = AnimationState.walkLeft
            }
//            player.velocity = -80
//            movement?.dashFlag = "chongci"
//            movement?.velocity = -80
//            if VelocityType.playerVelocity*2 >= VelocityType.velocityMax {
//                player.velocity = -VelocityType.velocityMax
//            }else {
//            if player.hasComponent(LargenMinifyComponent.self) == true {
//                player.velocity = -abs(player.velocity)*2
//            }else {
//                player.velocity = -VelocityType.playerVelocity*2
//            }
          //  }
//            let wait = SKAction.waitForDuration(0.1)
//            let block = SKAction.runBlock({ () -> Void in
//                self.player.velocity = -VelocityType.playerVelocity
//            })
//            player.sprite.runAction(SKAction.sequence([wait,block]))
            if Int(chongciNode.progress)  == 1 {
                player.chongci("left")
                chongciNode.reStart()
                CommonFunc.runSkillCd(chongciNode, timeCd: chongciNode.time, completion: { () -> () in
                    //self.chongciNode.progress = 1
                })
            }

            if player.hasComponent(FenshenComponent.self) {
//                movement = fenshen.componentForClass(MovementComponent.self)
//                movement?.dashFlag = "chongci"
//                movement?.velocity = -80
                fenshen.velocity = -80
            }
        }

    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let touch = touches.first
        let touchLocation = touch?.locationInNode(self)
     //   NSObject.cancelPreviousPerformRequestsWithTarget(self)
        if touch?.tapCount == 1 {
            self.performSelector(#selector(MainScene.handleSingle(_:)), withObject:NSValue(CGPoint:touchLocation!))
        }else if (touch?.tapCount >= 2) {
            self.handleDoubleTap(NSValue(CGPoint: touchLocation!))
        }


        if self.state == GameState.unstart {
            zombie.start()
            
            NSTimer.scheduledTimerWithTimeInterval(throwBadPropSpeed, target: enemy, selector: "disappear", userInfo: nil, repeats: true)
            NSTimer.scheduledTimerWithTimeInterval(createProductSpeed, target: zombie, selector: Selector("createProduct"), userInfo: nil, repeats: true)
       //     NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("changeSpeed"), userInfo: nil, repeats: true)
            
            NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(MainScene.checkPosition), userInfo: nil, repeats: true)

            self.state = GameState.start
//            let wait = SKAction.waitForDuration(Double.random())
//            let block = SKAction.runBlock({ () -> Void in
//                self.zombie.aiLogic(self.player)
//            })
//            zombie.sprite.runAction(SKAction.repeatActionForever(SKAction.sequence([wait,block])))
//            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
//            
//            dispatch_async(queue) { () -> Void in
//                while true {
//                    self.zombie.aiLogic(self.player)
//                    
//                    NSThread.sleepForTimeInterval(Double.random())
//                }
//            }
        }
        
    }
    
    func checkPosition() {
        if zombie.sprite.position.x <= (zombie.sprite.size.width/2+1) {
            zombie.velocity = VelocityType.enemyVelocity
        }else if zombie.sprite.position.x >= (screenSize.width - zombie.sprite.size.width/2-1) {
            zombie.velocity = -VelocityType.enemyVelocity
        }
//        
//        if enemy.sprite.position.x <= self.screenSize.width / 6 {
//            enemy.velocity = VelocityType.enemyVelocity
//        }else if enemy.sprite.position.x >= self.screenSize.width * 5 / 6 {
//            enemy.velocity = -VelocityType.enemyVelocity
//        }
    }
    
    func changeSpeed() {
        if VelocityType.playerVelocity <= VelocityType.velocityMax {
            VelocityType.playerVelocity = VelocityType.playerVelocity+5
            VelocityType.enemyVelocity = VelocityType.enemyVelocity+5
        }
        
        if createProductSpeed <= createProductSpeedMax {
            createProductSpeed = createProductSpeed - 0.1
        }
        
        if gravity.dy <= gravityMax.dy {
            gravity.dy = gravity.dy-1
        }
    }
    
}
