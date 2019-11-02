//
//  GameScene.swift
//  Geometric
//
//  Created by Pedro Cacique on 02/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftGameOfLife

class GameScene: SKScene {
    
    var grid: Grid = Grid(width: 10, height: 10)
    var matrixSize: Int = 20
    var renderTime: TimeInterval = 0
    let duration: TimeInterval = 0.2
    var nodes:[SKSpriteNode] = []
    var textures:[[SKTexture]] = []
    
    override func didMove(to view: SKView) {
        restart()
    }
    
    func restart(){
        self.removeAllActions()
        self.removeAllChildren()
        
        self.backgroundColor = UIColor(red: 0/255, green: 41/255, blue: 60/255, alpha: 1)
        
        let prop = Int(UIScreen.main.bounds.height / UIScreen.main.bounds.width) + 1
        
        grid = Grid(width: prop*matrixSize, height: matrixSize, isRandom: true, proportion: 50)
        grid.addRule(CountRule(name: "Solitude", startState: .alive, endState: .dead, count: 2, type: .lessThan))
        grid.addRule(CountRule(name: "Survive2", startState: .alive, endState: .alive, count: 2, type: .equals))
        grid.addRule(CountRule(name: "Survive3", startState: .alive, endState: .alive, count: 3, type: .equals))
        grid.addRule(CountRule(name: "Overpopulation", startState: .alive, endState: .dead, count: 3, type: .greaterThan))
        grid.addRule(CountRule(name: "Birth", startState: .dead, endState: .alive, count: 3, type: .equals))

        
        for i in 0..<grid.width{
            var temp:[SKTexture] = []
            for j in 0..<grid.height{
                temp.append(getRandomTexture())
            }
            textures.append(temp)
        }
    }
    
    func showGen(){
        var posX = 0 - UIScreen.main.bounds.width/2
        var posY = 0 - UIScreen.main.bounds.height/2
        let s = UIScreen.main.bounds.width / CGFloat(matrixSize)
        for i in 0..<grid.width {
            for j in 0..<grid.height {
                if grid.cells[i][j].state == .alive {
                    placeNode(pos: CGPoint(x: posX, y: posY), i, j)
                }
                posX += s
            }
            posY += s
            posX = 0 - UIScreen.main.bounds.width/2
        }
        
            
    }
    
    func placeNode(pos:CGPoint, _ i:Int = 0, _ j:Int = 0){
        let minDim:ScaleType = (min(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == UIScreen.main.bounds.height) ? .HEIGHT : .WIDTH
        
        var texture = getRandomTexture()
        
        
        let neighbors: [Cell] = grid.getLiveNeighbors(cell: grid.cells[i][j])
        if neighbors.count>0 {
            texture = textures[neighbors[0].x][neighbors[0].y]
        }
        textures[i][j] = texture
        
        let n = SKSpriteNode(texture: texture)
//        let s:CGFloat = CGFloat(Float.random(in: 0.8...2)) / CGFloat(matrixSize)
        let s:CGFloat = CGFloat(1) / CGFloat(matrixSize)
        scaleObject(obj: n, screenScale: s, type: minDim)
        n.position = CGPoint(x: pos.x + n.size.width/2, y: pos.y + n.size.height/2)
        self.addChild(n)
        nodes.append(n)
        
        n.alpha = CGFloat.random(in: 0.2...1)
        n.run(SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat.random(in: -0.1...0.1), duration: duration),
            SKAction.removeFromParent()
        ]))
    }
    
    func getRandomTexture() -> SKTexture{
        let f = TextureManager.instance.getTextureAtlasFrames(TextureManager.instance.sprites)
        return f[ Int.random(in: 0..<f.count) ]
    }
    
    func scaleObject(obj:SKSpriteNode, screenScale:CGFloat, type:ScaleType = .WIDTH){
        
        let w = obj.size.width
        let h = obj.size.height
        var nh = w
        var nw = h
        if type == .HEIGHT{
            nh = UIScreen.main.bounds.height * screenScale
            nw = (w * nh)/h
        } else {
            nw = UIScreen.main.bounds.width * screenScale
            nh = (h * nw)/w
        }
        obj.scale(to: CGSize(width: nw, height: nh))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if currentTime > renderTime {
            grid.applyRules()
            showGen()
            renderTime = currentTime + duration
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        restart()
    }
    
}
    
public enum ScaleType{
    case WIDTH, HEIGHT
}
