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
    
    private var maxBalls = Settings.ballCount!
    private var usedBalls = 0
    private var livesLeft = 3
    @IBOutlet weak var amountOfBallsLeft: UILabel!
    @IBOutlet weak var amountOfLivesLeftLabel: UILabel!
    
    let motionManager = CMMotionManager()
    
    @IBOutlet weak var breakoutView: BreakoutView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakoutView.behavior.breakoutCollisionDelegate = self
        breakoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "launchBall:"))
        
        setBallsLeftLabel()
        
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
            ResetGame()
            Settings.ResetRequired = false
        }
            
        if Settings.UpdateRequired {
            maxBalls = Settings.ballCount!
            setBallsLeftLabel()
            Settings.UpdateRequired = false
        }
        
        if(!Settings.UpdateRequired && !Settings.ResetRequired)
        {
            breakoutView.createBricks(Levels.levelOne)
        }
    }
    
    func ResetGame()
    {
        breakoutView.reset()
        breakoutView.createBricks(Settings.level)
        usedBalls = 0
        livesLeft = 3
        setBallsLeftLabel()
        setAmountOfLivesLeftLabel()
    }
    
    func setBallsLeftLabel()
    {
        amountOfBallsLeft.text! = ""
        for(var i = 0; i < (maxBalls - usedBalls); ++i)
        {
            amountOfBallsLeft.text! += "⦁";
        }
    }
    
    func setAmountOfLivesLeftLabel()
    {
        amountOfLivesLeftLabel.text! = ""
        if(livesLeft == 0)
        {
            ShowAlertMessage("GameOver", messagestring: "You have no more lives left!")
            ResetGame()
        }
        else
        {
            for(var i = 0; i < livesLeft; ++i)
            {
                amountOfLivesLeftLabel.text! += "♥︎"
            }
        }
    }
    
    func ShowAlertMessage(titlestring: String, messagestring: String)
    {
        var alert = UIAlertController(title: titlestring, message: messagestring, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
            if usedBalls < maxBalls {
                usedBalls++;
                setBallsLeftLabel()
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
            ShowAlertMessage("Congratulations", messagestring: "You beat the game!")
            ResetGame()
        }
    }
    
    func ballLeftPlayingField(behavior: UICollisionBehavior, ball: BallView)
    {
        livesLeft = livesLeft - 1
        setAmountOfLivesLeftLabel()
        if(usedBalls == maxBalls)
        {
            ShowAlertMessage("GameOver", messagestring: "You have no more balls left!")
            ResetGame()
        }
        else
        {
            breakoutView.removeBall(ball)
        }
    }
}