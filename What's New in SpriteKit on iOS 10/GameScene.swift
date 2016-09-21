//
//  GameScene.swift
//  What's New in SpriteKit on iOS 10
//
//  Created by Tatsuya Tobioka on 9/21/16.
//  Copyright © 2016 tnantoka. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        let label = SKLabelNode(text: "hello, world")
        label.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(label)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
