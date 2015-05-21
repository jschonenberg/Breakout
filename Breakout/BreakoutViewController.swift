//
//  ViewController.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 16/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UICollisionBehaviorDelegate {
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
        
        behavior.collisionDelegate = self
        animator.addBehavior(behavior)
        
        behavior.addBall(breakoutView.ball)
        
        breakoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pushBall:"))
        breakoutView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panPaddle:"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        var rect = breakoutView.bounds
        rect.size.height *= 2
        behavior.addBoundary(UIBezierPath(rect: rect), named: Constants.gamefieldBoundaryId)
        
        resetPaddle()
        animator.updateItemUsingCurrentState(breakoutView.ball)
    }
    
    
    private func resetPaddle() {
        if !CGRectContainsRect(breakoutView.bounds, breakoutView.paddle.frame) {
            breakoutView.paddle.center = CGPoint(x: breakoutView.bounds.midX, y: breakoutView.bounds.maxY - breakoutView.paddle.bounds.height - 80)
        } else {
            breakoutView.paddle.center = CGPoint(x: breakoutView.paddle.center.x, y: breakoutView.bounds.maxY - breakoutView.paddle.bounds.height - 80)
        }
        updatePaddleBarrier()
    }
    
    func pushBall(gesture: UITapGestureRecognizer){
        if gesture.state == .Ended {
            behavior.pushBall(breakoutView.ball)
        }
    }
    
    func updatePaddleBarrier() {
        behavior.addBoundary(UIBezierPath(rect: breakoutView.paddle.frame), named: Constants.paddleBoundaryId)
    }
    
    func panPaddle(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            breakoutView.placePaddle(gesture.translationInView(breakoutView))
            updatePaddleBarrier()
            gesture.setTranslation(CGPointZero, inView: breakoutView)
        default: break
        }
    }
}