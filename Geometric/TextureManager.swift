//
//  TextureManager.swift
//  Geometric
//
//  Created by Pedro Cacique on 02/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import Foundation
import SpriteKit

public class TextureManager{
    static let instance = TextureManager()
    
    let sprites:SKTextureAtlas = SKTextureAtlas(named: "sprites")
    
    
    func preloadAssets(_ handler: @escaping () -> Void) {
        SKTextureAtlas.preloadTextureAtlases([sprites], withCompletionHandler: handler)
    }
    
    func getTextureAtlasFrames(_ textureAtlas:SKTextureAtlas) -> [SKTexture]{
        var frames = [SKTexture]()
        let names = textureAtlas.textureNames.sorted()
        for i in 0...names.count-1{
            frames.append(textureAtlas.textureNamed(names[i]))
            textureAtlas.textureNamed(names[i]).filteringMode = .nearest
        }
        return frames
    }
    
}



