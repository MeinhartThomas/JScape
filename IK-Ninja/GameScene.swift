/**
 Copyright (c) 2016 Razeware LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import SpriteKit

class GameScene: SKScene {
    
    let backgroundSound = SKAudioNode(fileNamed: "bg.mp3")
    
    var background = SKSpriteNode();
    
    //NINJA
    
    var head: SKSpriteNode!
    
    var lowerTorso: SKSpriteNode!
    var upperTorso: SKSpriteNode!
    
    var upperArmFront: SKSpriteNode!
    var lowerArmFront: SKSpriteNode!
    
    var upperArmBack: SKSpriteNode!
    var lowerArmBack: SKSpriteNode!
    
    var fistFront: SKNode!
    var fistBack: SKNode!
    
    var legLowerFront: SKSpriteNode!
    var legLowerBack: SKSpriteNode!
    var legUpperFront: SKSpriteNode!
    var legUpperBack: SKSpriteNode!
    
    let upperArmAngleDeg: CGFloat = -10
    let lowerArmAngleDeg: CGFloat = 130
    
    let targetNode = SKSpriteNode()
    


    //OBSTACLES
    var woodenBox: SKSpriteNode!
   
    
    
    //BOOLEANS
    var rightPunch = true
    var firstTouch = false
    
    var isJumping = false
    var isSliding = false
    

    //industrial or mountain
    let designPack = "mountain"
    
    
    override func sceneDidLoad() {
        self.addChild(backgroundSound)
    }

    override func update(_ currentTime: TimeInterval) {
        moveGrounds()
        moveObstacles()
        
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        createBackground()
        createMovingLayers()
        createNinja()
        startRunningAnimation()
        createBox()
        createGestureRecognizers()
    }
    
    func createGestureRecognizers(){
        let jump = UISwipeGestureRecognizer(target: self, action: #selector(jumpUp))
        jump.direction = .up
        
        let slide = UISwipeGestureRecognizer(target: self, action: #selector(slideDown))
        slide.direction = .down
        
        self.view?.addGestureRecognizer(jump)
        self.view?.addGestureRecognizer(slide)
    }
    
    func createNinja(){
        
        //TORSO
        lowerTorso = childNode(withName: "torso_lower") as! SKSpriteNode
        lowerTorso.physicsBody = SKPhysicsBody(texture: lowerTorso.texture!, size: lowerTorso.size)
        lowerTorso.physicsBody?.affectedByGravity = false
        lowerTorso.physicsBody?.isDynamic = false
        lowerTorso.physicsBody?.categoryBitMask = 0
        lowerTorso.physicsBody?.collisionBitMask = 1
        
        upperTorso = lowerTorso.childNode(withName: "torso_upper") as! SKSpriteNode
        upperTorso.physicsBody = SKPhysicsBody(texture: upperTorso.texture!, size: upperTorso.size)
        upperTorso.physicsBody?.affectedByGravity = false
        upperTorso.physicsBody?.isDynamic = false
        upperTorso.physicsBody?.categoryBitMask = 0
        upperTorso.physicsBody?.collisionBitMask = 1

        lowerTorso.position = CGPoint(x: -100, y: -75)

        
        //ARM CONSTRAINTS
        
        let rotationConstraintArm = SKReachConstraints(lowerAngleLimit: CGFloat(0), upperAngleLimit: CGFloat(160))

        
        //ARM FRONT
        upperArmFront = upperTorso.childNode(withName: "arm_upper_front") as! SKSpriteNode
        upperArmFront.physicsBody = SKPhysicsBody(texture: upperArmFront.texture!, size: upperArmFront.size)
        upperArmFront.physicsBody?.affectedByGravity = false
        upperArmFront.physicsBody?.isDynamic = false
        upperArmFront.physicsBody?.categoryBitMask = 0
        upperArmFront.physicsBody?.collisionBitMask = 1
        
        lowerArmFront = upperArmFront.childNode(withName: "arm_lower_front") as! SKSpriteNode
        lowerArmFront.physicsBody = SKPhysicsBody(texture: lowerArmFront.texture!, size: lowerArmFront.size)
        lowerArmFront.physicsBody?.affectedByGravity = false
        lowerArmFront.physicsBody?.isDynamic = false
        lowerArmFront.physicsBody?.categoryBitMask = 0
        lowerArmFront.physicsBody?.collisionBitMask = 1
        lowerArmFront.reachConstraints = rotationConstraintArm
        
        fistFront = lowerArmFront.childNode(withName: "fist_front")
        
        
        //ARM BACK
        upperArmBack = upperTorso.childNode(withName: "arm_upper_back") as! SKSpriteNode
        upperArmBack.physicsBody = SKPhysicsBody(texture: upperArmBack.texture!, size: upperArmBack.size)
        upperArmBack.physicsBody?.affectedByGravity = false
        upperArmBack.physicsBody?.isDynamic = false
        upperArmBack.physicsBody?.categoryBitMask = 0
        upperArmBack.physicsBody?.collisionBitMask = 1
        
        lowerArmBack = upperArmBack.childNode(withName: "arm_lower_back") as! SKSpriteNode
        lowerArmBack.physicsBody = SKPhysicsBody(texture: lowerArmBack.texture!, size: lowerArmBack.size)
        lowerArmBack.physicsBody?.affectedByGravity = false
        lowerArmBack.physicsBody?.isDynamic = false
        lowerArmBack.physicsBody?.categoryBitMask = 0
        lowerArmBack.physicsBody?.collisionBitMask = 1
        lowerArmBack.reachConstraints = rotationConstraintArm
        
        fistBack = lowerArmBack.childNode(withName: "fist_back")
        
        
        //HEAD
        head = upperTorso.childNode(withName: "head") as! SKSpriteNode
        head.physicsBody = SKPhysicsBody(texture: head.texture!, size: head.size)
        head.physicsBody?.affectedByGravity = false
        head.physicsBody?.isDynamic = false
        head.physicsBody?.categoryBitMask = 0
        head.physicsBody?.collisionBitMask = 1
        
        
        //LEG FRONT
        legUpperFront = lowerTorso.childNode(withName: "leg_upper_front") as! SKSpriteNode
        legUpperFront.physicsBody = SKPhysicsBody(texture: legUpperFront.texture!, size: legUpperFront.size)
        legUpperFront.physicsBody?.affectedByGravity = false
        legUpperFront.physicsBody?.isDynamic = false
        legUpperFront.physicsBody?.categoryBitMask = 0
        legUpperFront.physicsBody?.collisionBitMask =1
        
        legUpperBack = lowerTorso.childNode(withName: "leg_upper_back") as! SKSpriteNode
        legUpperBack.physicsBody = SKPhysicsBody(texture: legUpperBack.texture!, size: legUpperBack.size)
        legUpperBack.physicsBody?.affectedByGravity = false
        legUpperBack.physicsBody?.isDynamic = false
        legUpperBack.physicsBody?.categoryBitMask = 0
        legUpperBack.physicsBody?.collisionBitMask = 1
        
        
        //LEG BACK
        legLowerFront = legUpperFront.childNode(withName: "leg_lower_front") as! SKSpriteNode
        legLowerFront.physicsBody = SKPhysicsBody(texture: legLowerFront.texture!, size: legLowerFront.size)
        legLowerFront.physicsBody?.affectedByGravity = false
        legLowerFront.physicsBody?.isDynamic = false
        legLowerFront.physicsBody?.categoryBitMask = 0
        legLowerFront.physicsBody?.collisionBitMask = 1
        
        legLowerBack = legUpperBack.childNode(withName: "leg_lower_back") as! SKSpriteNode
        legLowerBack.physicsBody = SKPhysicsBody(texture: legLowerBack.texture!, size: legLowerBack.size)
        legLowerBack.physicsBody?.affectedByGravity = false
        legLowerBack.physicsBody?.isDynamic = false
        legLowerBack.physicsBody?.categoryBitMask = 0
        legLowerBack.physicsBody?.collisionBitMask = 1

    }
    
    func startRunningAnimation() {
        let animation1 = SKAction.rotate(byAngle: CGFloat(50).degreesToRadians(), duration: 0.25)
        legUpperBack.run(animation1)
        
        let animation2 = SKAction.rotate(byAngle: CGFloat(-60).degreesToRadians(), duration: 0.25)
        legLowerBack.run(animation2)
        
        let animation3 = SKAction.rotate(byAngle: CGFloat(-50).degreesToRadians(), duration: 0.25)
        legUpperFront.run(animation3)
        
        let animation4 = SKAction.rotate(byAngle: CGFloat(-15).degreesToRadians(), duration: 0.25)
        legLowerFront.run(animation4)
        
        let animation5 = SKAction.rotate(byAngle: CGFloat(40).degreesToRadians(), duration: 0.25)
        upperArmFront.run(animation5)
        
        let animation6 = SKAction.rotate(byAngle: CGFloat(-60).degreesToRadians(), duration: 0.25)
        upperArmFront.run(animation6)
        
        let aniLegUpperBack1 = SKAction.rotate(byAngle: CGFloat(-130).degreesToRadians(), duration: 0.5)
        let aniLegUpperBack2 = SKAction.rotate(byAngle: CGFloat(130).degreesToRadians(), duration: 0.5)
        legUpperBack.run(SKAction.repeatForever(SKAction.sequence([aniLegUpperBack1, aniLegUpperBack2])))
        
        let aniLegLowerBack1 = SKAction.rotate(byAngle: CGFloat(60).degreesToRadians(), duration: 0.5)
        let aniLegLowerBack2 = SKAction.rotate(byAngle: CGFloat(-60).degreesToRadians(), duration: 0.5)
        legLowerBack.run(SKAction.repeatForever(SKAction.sequence([aniLegLowerBack1, aniLegLowerBack2])))
        
        let aniLegUpperFront1 = SKAction.rotate(byAngle: CGFloat(120).degreesToRadians(), duration: 0.5)
        let aniLegUpperFront2 = SKAction.rotate(byAngle: CGFloat(-120).degreesToRadians(), duration: 0.5)
        legUpperFront.run(SKAction.repeatForever(SKAction.sequence([aniLegUpperFront1,aniLegUpperFront2])))
        
        let aniLegLowerFront1 = SKAction.rotate(byAngle: CGFloat(-60).degreesToRadians(), duration: 0.5)
        let aniLegLowerFront2 = SKAction.rotate(byAngle: CGFloat(60).degreesToRadians(), duration: 0.5)
        legLowerFront.run(SKAction.repeatForever(SKAction.sequence([aniLegLowerFront1, aniLegLowerFront2])))
        
        let aniArmUpperBack1 = SKAction.rotate(byAngle: CGFloat(-60).degreesToRadians(), duration: 0.5)
        let aniArmUpperBack2 = SKAction.rotate(byAngle: CGFloat(60).degreesToRadians(), duration: 0.5)
        upperArmBack.run(SKAction.repeatForever(SKAction.sequence([aniArmUpperBack1, aniArmUpperBack2])))
        
        
        let aniArmUpperFront1 = SKAction.rotate(byAngle: CGFloat(60).degreesToRadians(), duration: 0.5)
        let aniArmUpperFront2 = SKAction.rotate(byAngle: CGFloat(-60).degreesToRadians(), duration: 0.5)
        upperArmFront.run(SKAction.repeatForever(SKAction.sequence([aniArmUpperFront1, aniArmUpperFront2])))
        
    }
    
    func resetNinja(){
        head.run(SKAction.rotate(toAngle: CGFloat(0).degreesToRadians(), duration: 0))
        lowerTorso.run(SKAction.rotate(toAngle: CGFloat(0).degreesToRadians(), duration: 0))
        upperTorso.run(SKAction.rotate(toAngle: CGFloat(0).degreesToRadians(), duration: 0))
        
        upperArmFront.run(SKAction.rotate(toAngle: CGFloat(-10).degreesToRadians(), duration: 0))
        lowerArmFront.run(SKAction.rotate(toAngle: CGFloat(130).degreesToRadians(), duration: 0))
        
        upperArmBack.run(SKAction.rotate(toAngle: CGFloat(-10).degreesToRadians(), duration: 0))
        lowerArmBack.run(SKAction.rotate(toAngle: CGFloat(130).degreesToRadians(), duration: 0))
        
        legUpperFront.run(SKAction.rotate(toAngle: CGFloat(-14).degreesToRadians(), duration: 0))
        legUpperBack.run(SKAction.rotate(toAngle: CGFloat(22).degreesToRadians(), duration: 0))
        legLowerFront.run(SKAction.rotate(toAngle: CGFloat(-9).degreesToRadians(), duration: 0))
        legLowerBack.run(SKAction.rotate(toAngle: CGFloat(-30).degreesToRadians(), duration: 0))
    }
    
    func createBox(){
        woodenBox = SKSpriteNode(imageNamed: "wooden_box") 
        woodenBox.physicsBody = SKPhysicsBody(texture: woodenBox.texture!, size: woodenBox.size)
        woodenBox.physicsBody?.affectedByGravity = false
        woodenBox.physicsBody?.isDynamic = false
        woodenBox.physicsBody?.categoryBitMask = 1
        woodenBox.physicsBody?.collisionBitMask = 0
        woodenBox.name = ("wooden_box")
        woodenBox.zPosition = -4
        woodenBox?.position = CGPoint(x: 100, y: -146)
        woodenBox.anchorPoint = CGPoint(x: 0, y: 0)
        scene?.addChild(woodenBox)
    }
    
    func punchAt(_ location: CGPoint, upperArmNode: SKNode, lowerArmNode: SKNode, fistNode: SKNode) {
        let punch = SKAction.reach(to: location, rootNode: upperArmNode, duration: 0.1)
        let restore = SKAction.run {
            upperArmNode.run(SKAction.rotate(toAngle: self.upperArmAngleDeg.degreesToRadians(), duration: 0.1))
            lowerArmNode.run(SKAction.rotate(toAngle: self.lowerArmAngleDeg.degreesToRadians(), duration: 0.1))
        }
        fistNode.run(SKAction.sequence([punch, restore]))
    }
    
    func punchAt(_ location: CGPoint) {
        if rightPunch {
            punchAt(location, upperArmNode: upperArmFront, lowerArmNode: lowerArmFront, fistNode: fistFront)
        }
        else {
            punchAt(location, upperArmNode: upperArmBack, lowerArmNode: lowerArmBack, fistNode: fistBack)
        }
        rightPunch = !rightPunch
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
       /* if !firstTouch {
            for c in head.constraints! {
                let constraint = c
                constraint.enabled = true
            }
            firstTouch = true
        }*/
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            //lowerTorso.xScale = location.x < frame.midX ? abs(lowerTorso.xScale) * -1 : abs(lowerTorso.xScale)
            punchAt(location)
            targetNode.position = location

        }
    }
    
    func createBackground(){
        let background = SKSpriteNode(imageNamed: designPack + "0")
        background.size = self.scene!.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: 0, y:  0)
        background.zPosition = -9
        
        self.addChild(background)
    }
    
    func createMovingLayers() {
        
        for i in 0...3{
            let firstLayer = SKSpriteNode(imageNamed: designPack + "1")
            firstLayer.name = "1"
            firstLayer.size = self.scene!.size
            firstLayer.position = CGPoint(x: CGFloat(i) * self.scene!.size.width, y:  0)
            firstLayer.zPosition = -8
            
            
            let secondLayer = SKSpriteNode(imageNamed:  designPack + "2")
            secondLayer.name = "2"
            secondLayer.size = self.scene!.size
            secondLayer.position = CGPoint(x: CGFloat(i) * self.scene!.size.width, y:  0)
            secondLayer.zPosition = -7
            
            
            
            let thirdLayer = SKSpriteNode(imageNamed:  designPack + "3")
            thirdLayer.name = "3"
            thirdLayer.size = self.scene!.size
            thirdLayer.position = CGPoint(x: CGFloat(i) * self.scene!.size.width, y:  0)
            thirdLayer.zPosition = -6
            
            
            if (UIImage(named: designPack + "4") != nil){
                let forthLayer = SKSpriteNode(imageNamed:  designPack + "4")
                forthLayer.name = "4"
                forthLayer.size = self.scene!.size
                forthLayer.position = CGPoint(x: CGFloat(i) * self.scene!.size.width, y:  0)
                forthLayer.zPosition = -5
                self.addChild(forthLayer)
            }
            
            self.addChild(thirdLayer)
            self.addChild(secondLayer)
            self.addChild(firstLayer)
        }
    }
    
    func moveGrounds() {
        self.enumerateChildNodes(withName: "1", using: ({
            (node, error) in
            node.position.x -= 0.1
            
            if node.position.x < -(self.scene!.size.width){
                node.position.x += self.scene!.size.width * 3
            }
        }))
        
        self.enumerateChildNodes(withName: "2", using: ({
            (node, error) in
            node.position.x -= 0.4
            
            if node.position.x < -(self.scene!.size.width){
                node.position.x += self.scene!.size.width * 3
            }
        }))
        
        self.enumerateChildNodes(withName: "3", using: ({
            (node, error) in
            node.position.x -= 1
            
            if node.position.x < -(self.scene!.size.width){
                node.position.x += self.scene!.size.width * 3
            }
        }))
        
        self.enumerateChildNodes(withName: "4", using: ({
            (node, error) in
            node.position.x -= 1.7
            
            if node.position.x < -(self.scene!.size.width){
                node.position.x += self.scene!.size.width * 3
            }
        }))
        
    }
    
    func moveObstacles(){
        self.enumerateChildNodes(withName: "wooden_box", using: ({
            (node, error) in
            node.position.x -= 1.7
            
            //            if node.position.x < -(self.scene!.size.width){
            //                node.removeFromParent()
            //              }
        }))
    }
    
   
    
    func jumpUp() {
        if isJumping == false {
            isJumping = true
            
            removeActions()
            
            if isSliding {
                isSliding = false
                resetNinja()
            }
            
            //            performJumpingMotion()
            let upMotion = SKAction.moveBy(x: 0, y: 40, duration: 0.1)
            let highPoint = SKAction.moveBy(x: 0, y: 50, duration: 0.3)
            let highestPoint = SKAction.moveBy(x: 0, y: 0, duration: 0.5)
            let downMotion = SKAction.moveBy(x: 0, y: -90, duration: 0.5)
            let jumpingMotion = SKAction.sequence([upMotion, highPoint, highestPoint, downMotion])
            
            
            upperArmFront.run(SKAction.rotate(toAngle: CGFloat(90).degreesToRadians(), duration: 0))
            lowerArmFront.run(SKAction.rotate(toAngle: CGFloat(100).degreesToRadians(), duration: 0))
            self.lowerTorso.run(jumpingMotion) {
                self.isJumping = false
                self.resetNinja()
                self.startRunningAnimation()
            }
        }
    }
    
    func slideDown() {
        if isSliding == false && isJumping == false {
            isSliding = true
            
            removeActions()
            
            let rotation = SKAction.sequence([SKAction .rotate(toAngle: CGFloat(75).degreesToRadians(), duration: 0.5), .rotate(byAngle: 0, duration: 1)])
            let finishRotation = SKAction.rotate(toAngle: CGFloat(0).degreesToRadians(), duration: 0.5)
            
            let groundTouch = SKAction.group([.moveTo(y: CGFloat(-112.5), duration: 0.35), rotation])
            let backToPositionGroup = SKAction.group([finishRotation, .moveTo(y: CGFloat(-75), duration: 0.35)])
            let finalMove = SKAction.sequence([groundTouch, backToPositionGroup])
            
            lowerTorso.run(finalMove) {
                self.isSliding = false
                self.resetNinja()
                self.startRunningAnimation()
            }
        }
    }
    
    func performSlideMotion() {
        // Add code for body movement wheile sliding
    }
    
    func performJumpingMotion() {
        print("Performing Jumping motion")
        upperArmFront.run(SKAction.rotate(toAngle: CGFloat(90).degreesToRadians(), duration: 0))
        lowerArmFront.run(SKAction.rotate(toAngle: CGFloat(100).degreesToRadians(), duration: 0))
        
    }
    
    func removeActions() {
        legLowerBack.removeAllActions()
        legLowerFront.removeAllActions()
        legUpperBack.removeAllActions()
        legUpperFront.removeAllActions()
        
        upperArmBack.removeAllActions()
        upperArmFront.removeAllActions()
        
        if lowerTorso.hasActions() {
            lowerTorso.removeAllActions()
        }
    }
}
