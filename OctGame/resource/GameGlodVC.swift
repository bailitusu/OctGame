//
//  GameGlodVC.swift
//  Oct_Game
//
//  Created by zc on 16/6/10.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit
class GameGlodVC: UIViewController {
    var skView:SKView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = BeginScene()
        let skv = SKView(frame: self.view.frame)
        self.view = skv
        skView = self.view as! SKView
     //   skView.multipleTouchEnabled = false
        skView.showsFPS = true
//        skView.showsPhysics = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .AspectFill
        scene.size = skView.frame.size
        skView.presentScene(scene)
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .LandscapeRight
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
