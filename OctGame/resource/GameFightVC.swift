//
//  GameFightVC.swift
//  OctGame
//
//  Created by zc on 16/7/1.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class GameFightVC: UIViewController {
    var skView:SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = FTMatchScene()
        let skV = SKView(frame: self.view.frame)
        self.view = skV
        skView = self.view as! SKView
        skView.showsFPS = true
       // skView.ignoresSiblingOrder = true
       // skView.showsPhysics = true
        //skView.showsNodeCount = true
        scene.scaleMode = .AspectFill
        scene.size = skView.frame.size
        skView.presentScene(scene)
        
       
    }

    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            return .Portrait
//        }else {
//            return .All
//        }
        return .Portrait
    }
    
    
    
    
}
