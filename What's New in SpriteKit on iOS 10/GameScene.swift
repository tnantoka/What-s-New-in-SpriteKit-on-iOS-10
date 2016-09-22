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
    var playerNode: SKSpriteNode!
    var column = 0
    var row = 0
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        createMap()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private func createImage(color: UIColor, circle: Bool = false) -> UIImage {
        let size = CGSize(width: 32.0, height: 32.0)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        let opaque = false
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        color.setFill()
        if circle {
            context.fillEllipse(in: rect)
        } else {
            context.fill(rect)
        }
        
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
        
        let move = SKAction.move(to: converted, duration: 0.3)
        
        playerNode.run(SKAction.group([move, warpAction()]))
    }
    
    private func createMap() {
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
        
        let playerTexture = SKTexture(image: createImage(color: UIColor.black, circle: true))
        playerNode = SKSpriteNode(texture: playerTexture)
        addChild(playerNode)
        
        move(x: 1, y: 1)
    }
    
    private func warpAction() -> SKAction {
        let source = [
            float2(0, 0), float2(0.5, 0), float2(1, 0),
            float2(0, 0.5), float2(0.5, 0.5), float2(1, 0.5),
            float2(0, 1), float2(0.5, 1), float2(1, 1)
        ]
        let dest = [
            float2(0.5, 0.5), float2(0.5, 0), float2(0.5, 0.5),
            float2(0, 0.5), float2(0.5, 0.5), float2(1, 0.5),
            float2(0.5, 0.5), float2(0.5, 1), float2(0.5, 0.5)
        ]

        let warpGrid = SKWarpGeometryGrid(columns: 2, rows: 2, sourcePositions: source, destinationPositions: dest)
        let noWarpGrid = SKWarpGeometryGrid(columns: 2, rows: 2)
        
        playerNode.warpGeometry = noWarpGrid
        let warp = SKAction.animate(withWarps:[warpGrid, noWarpGrid], times: [0.2, 0.4])
        
        return warp!
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
