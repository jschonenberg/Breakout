//
//  ViewController.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 16/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UICollisionBehaviorDelegate {
    private let level1 = [[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1]]
    
    private struct Constants {
        static let gamefieldBoundaryId = "gamefieldBoundary"
        static let paddleBoundaryId = "paddleBoundary"
    }
    
    @IBOutlet weak var breakoutView: BreakoutView!
    
    private var behavior = BreakoutBehavior()
    private lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self.breakoutView) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        animator.addBehavior(behavior)
        behavior.collisionDelegate = self
        behavior.addBall(breakoutView.ball)
        
        breakoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "launchBall:"))
        breakoutView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panPaddle:"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        var rect = breakoutView.bounds
        rect.size.height *= 2   // the ball has to be able to leave to screen
        behavior.addBoundary(UIBezierPath(rect: rect), named: Constants.gamefieldBoundaryId)
        
        breakoutView.createBricks(level1);
        for index in 0 ..< breakoutView.bricks.count {
            let brick = breakoutView.bricks[index]
            behavior.addBoundary(UIBezierPath(roundedRect: brick.frame, cornerRadius: brick.layer.cornerRadius), named: index)
        }
        
        breakoutView.resetPaddle()
        updatePaddleBarrier()
        
        animator.updateItemUsingCurrentState(breakoutView.ball)
    }
    
    func updatePaddleBarrier() {
        behavior.addBoundary(UIBezierPath(rect: breakoutView.paddle.frame), named: Constants.paddleBoundaryId)
    }
    
    func launchBall(gesture: UITapGestureRecognizer){
        if gesture.state == .Ended {
            behavior.launchBall(breakoutView.ball)
        }
    }
    
    func panPaddle(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            breakoutView.movePaddle(gesture.translationInView(breakoutView))
            updatePaddleBarrier()
            gesture.setTranslation(CGPointZero, inView: breakoutView)
        default: break
        }
    }
    
    /* collisiondelegate implementation */
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        if let index = identifier as? Int {
            behavior.removeBoundaryWithIdentifier(index)
            
            if let brick = breakoutView?.bricks[index] {
                brick.removeFromSuperview()
            }
        }
    }
}