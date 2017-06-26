//
//  Lost.swift
//  IK-Ninja
//
//  Created by Thomas Meinhart on 25/06/2017.
//  Copyright © 2017 Ken Toh. All rights reserved.
//

import SpriteKit

class Lost: SKScene{
    var button: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        button = childNode(withName: "button") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if button.contains((touches.first?.location(in: self.button))!){
            button.texture = SKTexture(imageNamed: "red_button2")
            button.run(SKAction.wait(forDuration: 0.3)){
                self.button.texture = SKTexture(imageNamed: "red_button1")
                let tempScene = GameScene(fileNamed: "GameScene")
                self.view?.presentScene(tempScene!, transition: SKTransition.fade(withDuration: 1))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        button.texture = SKTexture(imageNamed: "red_button1")
    }
}
