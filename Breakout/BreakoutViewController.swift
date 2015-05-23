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
        
        breakoutView.collisionDelegate = self        
        breakoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "launchBall:"))
        breakoutView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panPaddle:"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        breakoutView.createBricks(Levels.levelThree)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let level = Settings().level {
            breakoutView.createBricks(Settings().level!);
        }
    }
    
    func launchBall(gesture: UITapGestureRecognizer){
        if gesture.state == .Ended {
            if breakoutView.balls.count < Constants.maxBalls {
                breakoutView.addBall()
            }
            
            breakoutView.behavior.launchBall(breakoutView.balls.last!, magnitude: 0.25)
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
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier boundaryId: NSCopying, atPoint p: CGPoint) {
        if let brickIndex = boundaryId as? Int {
            behavior.removeBoundaryWithIdentifier(brickIndex)
            
            if let brick = breakoutView?.bricks[brickIndex] {
                brick.removeFromSuperview()
            }
        }
    }
    
    func ballLeftPlayingField(ball: BallView) {
        breakoutView.removeBall(ball)
    }
}