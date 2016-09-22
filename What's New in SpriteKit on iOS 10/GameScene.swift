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
    
    var mapNode: SKTileMapNode!
    var playerNode: SKShapeNode!
    var column = 0
    var row = 0
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        createMapExample()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private func createImage(color: UIColor) -> UIImage {
        let size = CGSize(width: 32.0, height: 32.0)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        let opaque = true
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        color.setFill()
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    private func move(x: Int, y: Int) {
        if case let newColumn = column + x, 1..<mapNode.numberOfColumns - 1 ~= newColumn {
            column = newColumn
        }
        if case let newRow = row + y, 1..<mapNode.numberOfRows - 1 ~= newRow {
            row = newRow
        }
        let point = mapNode.centerOfTile(atColumn: column, row: row)
        let converted = mapNode.convert(point, to: self)
        
        let action = SKAction.move(to: converted, duration: 0.3)
        playerNode.run(action)
    }
    
    private func createMapExample() {
        let loadTexture = SKTexture(image: createImage(color: UIColor.lightGray))
        let loadDef = SKTileDefinition(texture: loadTexture)
        let loadGroup = SKTileGroup(tileDefinition: loadDef)
        
        let wallTexture = SKTexture(image: createImage(color: UIColor.brown))
        let wallDef = SKTileDefinition(texture: wallTexture)
        let wallGroup = SKTileGroup(tileDefinition: wallDef)
        
        let tileSet = SKTileSet(tileGroups: [loadGroup, wallGroup])
        
        mapNode = SKTileMapNode(tileSet: tileSet, columns: 7, rows: 7, tileSize: loadDef.size, fillWith: loadGroup)
        [0, mapNode.numberOfColumns - 1].forEach { i in
            (0..<mapNode.numberOfRows).forEach { j in
                mapNode.setTileGroup(wallGroup, forColumn: i, row: j)
                mapNode.setTileGroup(wallGroup, forColumn: j, row: i)
            }
        }
        
        mapNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(mapNode)
        
        playerNode = SKShapeNode(circleOfRadius: loadDef.size.width / 2)
        playerNode.fillColor = UIColor.black
        playerNode.strokeColor = UIColor.clear
        addChild(playerNode)
        
        move(x: 1, y: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        var x = 0
        var y = 0
        if location.x > playerNode.frame.maxX {
            x += 1
        } else if location.x < playerNode.frame.minX {
            x -= 1
        } else if location.y > playerNode.frame.maxY {
            y += 1
        } else if location.y < playerNode.frame.minY {
            y -= 1
        }
        
        move(x: x, y: y)
    }
}
