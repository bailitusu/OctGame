//
//  Player.swift
//  OctGame
//
//  Created by zc on 16/6/14.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class Player: Entity {
    static var playerImageName = "zhujiao.png"
    var screenSize:CGSize!
    var sprite:SKSpriteNode {
        return (self.componentForClass(SpriteComponent.self)?.sprite)!
    }
//    var direction:String! //false: left true: right
    var velocity = 0 as CGFloat {
        didSet {
            if let movement = self.componentForClass(MoveComponent.self) {
                if velocity > 0 {
                   // movement.toRight(velocity)
                    movement.speed = velocity
//                    self.direction = "right"
                } else {
                   // movement.toLeft(velocity)
                    movement.speed = velocity
//                    self.direction = "left"
                }
            }
        }
    }
    
    init(screenView:CGSize) {
        super.init()
        self.screenSize = screenView

        AddResource.addEntityAtlas(self, atlasName: AtlasName.walkLeft.rawValue)
       // let sprite = SKSpriteNode(imageNamed: Player.playerImageName)
        let texturename:String = "\(OneTextureName.oneWalkLeft.rawValue)1.png"
        let sprite = SKSpriteNode(texture: self.atlas.textureNamed(texturename))
        sprite.size = playerSize
        sprite.zPosition = SpriteLevel.sprite.rawValue
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size, center: CGPoint(x: 0.5, y: 0.5))
        sprite.physicsBody?.affectedByGravity = false;
        sprite.physicsBody?.mass = 10000;
        sprite.physicsBody?.allowsRotation = false;

        self.addComponent(SpriteComponent(sprite: sprite))
        self.addComponent(MoveComponent())
        self.addComponent(AnimationComponent())
      //  self.addComponent(InvincibleComponent(duration: 100.0))
//        var tempName:String
//        for (var i = 1; i <= self.atlas.textureNames.count ; i++){
//            tempName = "\(OneTextureName.oneLeftWalk.rawValue)\(i).png"
//            let texture = self.atlas.textureNamed(tempName)
//            self.textureArray.append(texture)
//        }
 //       self.addComponent(MagnetComponent())
 //       self.addComponent(LargenMinifyComponent(isBig:false, duration: 1000.0))
//        self.addComponent(DashComponent(duration: 20))
       // self.runAnimation()
    }
//    func runAnimation() {
//        self.sprite.runAction(SKAction.repeatActionForever(
//            SKAction.animateWithTextures(self.textureArray, timePerFrame: 0.05)))
//        
//    }
    func chongci(playerDirection:NSString) {
        if let movement = self.componentForClass(MoveComponent.self) {
            if playerDirection == "right" {
                if self.hasComponent(LargenMinifyComponent.self) == true {
                    movement.toRightChongci(abs(self.velocity)*3)
                }else {
                    movement.toRightChongci(VelocityType.playerVelocity*3)
                }
                
            }else if playerDirection == "left"{
                if self.hasComponent(LargenMinifyComponent.self) == true {
                    movement.toLeftChongci(-abs(self.velocity)*3)
                }else {
                    movement.toLeftChongci(-VelocityType.playerVelocity*3)
                }
            }
        }

    }
    
    
    override func updateWithDeltaTime(second: NSTimeInterval) {
        super.updateWithDeltaTime(second)
        
        if self.sprite.position.x <= self.sprite.size.width/2 {
            self.sprite.position.x = self.sprite.size.width/2
           // self.velocity = 0
        }else if self.sprite.position.x >= (self.screenSize.width-self.sprite.size.width/2-1) {
            self.sprite.position.x = self.screenSize.width-self.sprite.size.width/2
           // self.velocity = 0
        }
        if self.sprite.zRotation != 0 {
            self.sprite.zRotation = 0
        }
        
        if UInt32(self.sprite.position.y) != UInt32(self.sprite.size.height/2) {
            self.sprite.position.y = self.sprite.size.height/2
        }
//        if self.hasComponent(AnimationComponent.self) {
//            let animattion = self.componentForClass(AnimationComponent.self)
//            if animattion?.state != animattion?.prevState {
//                self.runAnimation()
//                animattion?.prevState = animattion!.state
//                
//            }
//        }
    }
    
}
