//
//  FTMapCell.swift
//  OctGame
//
//  Created by zc on 16/7/4.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit


class FTMapCell: SKSpriteNode {
    var obj:FTCellStandAbleDelegate?
    
    init(imageName: String, size: CGSize) {
        super.init(texture: SKTexture(imageNamed:imageName), color: UIColor.clearColor(), size: size)
        
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}