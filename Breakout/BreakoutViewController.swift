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
    private struct Const {
        static let gameOverTitle = "Game over!"
        static let congratulationsTitle = "Congratulations!"
        
        static let gamefieldBoundaryId = "gamefieldBoundary"
        static let paddleBoundaryId = "paddleBoundary"
        
        static let minBallLaunchAngle = 210
        static let maxBallLaunchAngle = 330
        static let minLaunchSpeed = CGFloat(0.2)
        static let maxLaunchSpeed = CGFloat(0.8)
        static let pushSpeed = CGFloat(0.05)
        
        static let maxPaddleSpeed = 25.0
    }
    
    private var launchSpeedModifier = Settings.ballSpeedModifier
    
    private var maxBalls: Int = Settings.ballCount {
        didSet { amountOfBallsLeft?.text = "⦁".repeat(maxBalls - usedBalls) }
    }
    
    private var usedBalls = 0 {
        didSet { amountOfBallsLeft?.text = "⦁".repeat(maxBalls - usedBalls) }
    }
    
    private var livesLeft = 3 {
        willSet {
            amountOfLivesLeftLabel.text = "♥︎".repeat(newValue)
            
            if newValue == 0 {
                showGameEndedAlert(false, message: "You have no more lives left!")
                ResetGame()
            }
        }
    }
    
    @IBOutlet weak var breakoutView: BreakoutView!
    @IBOutlet weak var amountOfBallsLeft: UILabel!
    @IBOutlet weak var amountOfLivesLeftLabel: UILabel!
   
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakoutView.behavior.breakoutCollisionDelegate = self
        breakoutView.addGestureRecognizer( UITapGestureRecognizer(target: self, action: "launchBall:") )
        breakoutView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panPaddle:"))
        motionManager.accelerometerUpdateInterval = 0.01
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setAppearance()
        loadSettings()
    }
    
    var firstTimeLoading = true
    
    func loadSettings() {
        // check if we need to reset the game
        if Settings.ResetRequired || firstTimeLoading {
            ResetGame()
            Settings.ResetRequired = false
            firstTimeLoading = false
        }
        
        // load the other settings on-the-go
        if Settings.controlWithTilt {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: accelerometerUpdate)
        } else {
            motionManager.stopAccelerometerUpdates()
        }
        
        self.maxBalls = Settings.ballCount
        self.launchSpeedModifier = Settings.ballSpeedModifier
        breakoutView.setPaddleWidth(Settings.paddleWidth)
    }
    
    func ResetGame()
    {
        breakoutView.reset()
        breakoutView.createBricks(Settings.level)
        usedBalls = 0
        livesLeft = 3
    }
    
    func showGameEndedAlert(playerWon: Bool, message: String) {
        let title = playerWon ? Const.congratulationsTitle : Const.gameOverTitle
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func canBecomeFirstResponder() -> Bool {
        return true;
    }
    
    // on device shake
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        pushBalls()
    }
    
    func launchBall(gesture: UITapGestureRecognizer){
        if gesture.state == .Ended {
            if usedBalls < maxBalls {
                usedBalls++;
                breakoutView.addBall()
                
                var launchSpeed = Const.minLaunchSpeed + (Const.maxLaunchSpeed - Const.minLaunchSpeed) * CGFloat(launchSpeedModifier)
                breakoutView.behavior.launchBall(breakoutView.balls.last!, magnitude: launchSpeed, minAngle: Const.minBallLaunchAngle, maxAngle: Const.maxBallLaunchAngle)
            } else {
                pushBalls()
            }
        }
    }
    
    func pushBalls(){
        for ball in breakoutView.balls {
            breakoutView.behavior.launchBall(ball, magnitude: Const.pushSpeed)
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
    
    func accelerometerUpdate(data: CMAccelerometerData!, error: NSError!) -> Void {
        self.breakoutView.translatePaddle( CGPoint(x: Const.maxPaddleSpeed * data.acceleration.x, y: 0.0) )
    }
    
    func ballHitBrick(behavior: UICollisionBehavior, ball: BallView, brickIndex: Int) {
        breakoutView.removeBrick(brickIndex)
        
        if breakoutView.bricks.count == 0 {
            showGameEndedAlert(true, message: "You beat the game!")
            ResetGame()
        }
    }
    
    func ballLeftPlayingField(behavior: UICollisionBehavior, ball: BallView)
    {
        livesLeft--
        
        if(usedBalls == maxBalls) {
            showGameEndedAlert(false, message: "You are out of balls!")
            ResetGame()
        }

        breakoutView.removeBall(ball)
    }
    
    private func setAppearance() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.barTintColor = UIColor.blackColor()
    }
}