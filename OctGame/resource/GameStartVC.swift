//
//  GameStartVC.swift
//  OctGame
//
//  Created by zc on 16/7/18.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit


class GameStartVC: UIViewController {
    var glodGameBtn: UIButton!
    var fightGameBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let helloLabel = UILabel(frame: CGRect(x: screenSize.width/2-125, y: 150, width: 250, height: 50))
        helloLabel.text = "Welcome to Oct World"
        helloLabel.font = UIFont.systemFontOfSize(24)
        helloLabel.textColor = UIColor.blackColor()
        helloLabel.textAlignment = NSTextAlignment.Center
        helloLabel.backgroundColor = UIColor.clearColor()
        self.view.addSubview(helloLabel)
        
        glodGameBtn = UIButton.init(frame: CGRect(x: screenSize.width/2-60, y: screenSize.height-20-160 , width: 120 , height: 40))
        glodGameBtn.setTitle("天降奇财", forState: UIControlState.Normal)
        glodGameBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        glodGameBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        glodGameBtn.backgroundColor = UIColor.greenColor()
        glodGameBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        glodGameBtn.addTarget(self, action: #selector(goInGlodGame), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(glodGameBtn)
        
        fightGameBtn = UIButton.init(frame: CGRect(x: screenSize.width/2-60, y: screenSize.height-20-80 , width: 120 , height: 40))
        fightGameBtn.setTitle("卡尔传奇", forState: UIControlState.Normal)
        fightGameBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        fightGameBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        fightGameBtn.backgroundColor = UIColor.greenColor()
        fightGameBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        fightGameBtn.addTarget(self, action: #selector(goInFightGame), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(fightGameBtn)
    }
    
    func goInGlodGame(sender: AnyObject) {
        let glodVC = GameGlodVC()
       // glodVC.view.frame = self.view.frame
        self.presentViewController(glodVC, animated: true) { 
            
        }
     
    }
    
    func goInFightGame(sender: AnyObject) {
        let fightGame = GameFightVC()
        self.presentViewController(fightGame, animated: true) { 
            
        }
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
