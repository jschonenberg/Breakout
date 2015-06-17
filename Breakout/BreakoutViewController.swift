//
//  ViewController.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 16/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit
import CoreMotion

class BreakoutViewController: UIViewController, BreakoutCollisionBehaviorDelegate {
    private struct Constants {
        static let gamefieldBoundaryId = "gamefieldBoundary"
        static let paddleBoundaryId = "paddleBoundary"
        static let ballLaunchSpeed = CGFloat(0.25)
        static let ballPushSpeed = CGFloat(0.05)
        static let minBallLaunchAngle = 210
        static let maxBallLaunchAngle = 330
    }
    
    private var maxBalls = 1
    
    let motionManager = CMMotionManager()
    
    @IBOutlet weak var breakoutView: BreakoutView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakoutView.behavior.breakoutCollisionDelegate = self
        breakoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "launchBall:"))
        
        // add pan event
        breakoutView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panPaddle:"))
        
        // add accelerometer event
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: accelerometerUpdateHandler)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.barTintColor = UIColor.blackColor()
        
        if Settings.ResetRequired {
            breakoutView.reset()
            breakoutView.createBricks(Settings.level)
            Settings.ResetRequired = false
        }
            
        if Settings.UpdateRequired {
            maxBalls = Settings.ballCount!
            Settings.UpdateRequired = false
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true;
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        for ball in breakoutView.balls {
            breakoutView.behavior.launchBall(ball, magnitude: Constants.ballPushSpeed)
        }
    }
    
    func launchBall(gesture: UITapGestureRecognizer){
        if gesture.state == .Ended {
            if breakoutView.balls.count < maxBalls {
                breakoutView.addBall()
                breakoutView.behavior.launchBall(breakoutView.balls.last!, magnitude: Constants.ballLaunchSpeed, minAngle: Constants.minBallLaunchAngle, maxAngle: Constants.maxBallLaunchAngle)
            } else {
                // give all the balls a light push
                for ball in breakoutView.balls {
                    breakoutView.behavior.launchBall(ball, magnitude: Constants.ballPushSpeed)
                }
            }
        }
    }
    
    func pushBalls(){
        for ball in breakoutView.balls {
            breakoutView.behavior.launchBall(ball, magnitude: Constants.ballPushSpeed)
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
    
    func accelerometerUpdateHandler(data: CMAccelerometerData!, error: NSError!) -> Void {
        self.breakoutView.translatePaddle( CGPoint(x: 25.0 * data.acceleration.x, y: 0.0) )
    }
    
    func ballHitBrick(behavior: UICollisionBehavior, ball: BallView, brickIndex: Int) {
        breakoutView.removeBrick(brickIndex)
        
        if breakoutView.bricks.count == 0
        {
            breakoutView.reset()
            breakoutView.createBricks(Levels.levelThree)
            var alert = UIAlertController(title: "Alert", message: "The game is finished!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func ballLeftPlayingField(behavior: UICollisionBehavior, ball: BallView) {
        breakoutView.removeBall(ball)
    }
}