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
        static let ballLaunchSpeed = CGFloat(0.25)
        static let minBallLaunchAngle = 210
        static let maxBallLaunchAngle = 330
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
        
        if Settings.HaveChanged
        {
            breakoutView.RemoveAllBricks()
            breakoutView.createBricks(Settings.level)
            Settings.HaveChanged = false
        }
        else
        {
            breakoutView.createBricks(Levels.levelOne)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func launchBall(gesture: UITapGestureRecognizer){
        if gesture.state == .Ended {
            if breakoutView.balls.count < Constants.maxBalls {
                breakoutView.addBall()
            }
            
            breakoutView.behavior.launchBall(breakoutView.balls.last!, magnitude: Constants.ballLaunchSpeed, minAngle: Constants.minBallLaunchAngle, maxAngle: Constants.maxBallLaunchAngle)
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
        breakoutView.description
        
    }
    
    func ballLeftPlayingField(behavior: UICollisionBehavior, ball: BallView) {
        breakoutView.removeBall(ball)
    }
}