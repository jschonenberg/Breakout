//
//  ViewController.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 16/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, BreakoutCollisionBehaviorDelegate {
    private struct Constants {
        static let gamefieldBoundaryId = "gamefieldBoundary"
        static let paddleBoundaryId = "paddleBoundary"
        static let maxBalls = 3
    }
    
    @IBOutlet weak var breakoutView: BreakoutView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        breakoutView.behavior.breakoutCollisionDelegate = self
        breakoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "launchBall:"))
        breakoutView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panPaddle:"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        breakoutView.createBricks(Levels.levelThree)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func launchBall(gesture: UITapGestureRecognizer){
        if gesture.state == .Ended {
            if breakoutView.balls.count < Constants.maxBalls {
                breakoutView.addBall()
            }
            
            breakoutView.behavior.launchBall(breakoutView.balls.last!, magnitude: 0.25, minAngle: 210, maxAngle: 330)
        }
    }
    
    func panPaddle(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            breakoutView.translatePaddle(gesture.translationInView(breakoutView))
            gesture.setTranslation(CGPointZero, inView: breakoutView)
        default: break
        }
    }
    
    func ballHitBrick(behavior: UICollisionBehavior, ball: BallView, brickIndex: Int) {
        breakoutView.removeBrick(brickIndex)
        
        if breakoutView.bricks.count == 0 {
            println("NO MORE BRICKS")
        }
    }
    
    func ballLeftPlayingField(behavior: UICollisionBehavior, ball: BallView) {
        breakoutView.removeBall(ball)
    }
}