//
//  ViewController.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 16/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UICollisionBehaviorDelegate {
    private let boxPathName = "boxpath"
    
    @IBOutlet weak var breakoutView: BreakoutView!
    
    private var breakoutBehavior = BreakoutBehavior()
    private lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self.breakoutView) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        animator.addBehavior(breakoutBehavior)
        breakoutBehavior.collisionDelegate = self
        breakoutBehavior.addBall(breakoutView.ball)
        
        breakoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pushBall:"))
        breakoutView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panPaddle:"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        var rect = breakoutView.bounds
        rect.size.height *= 2
        breakoutBehavior.addBarrier(UIBezierPath(rect: rect), named: boxPathName)
        
        resetPaddle()
        animator.updateItemUsingCurrentState(breakoutView.ball)
    }
    
    
    private func resetPaddle() {
        if !CGRectContainsRect(breakoutView.bounds, breakoutView.paddle.frame) {
            breakoutView.paddle.center = CGPoint(x: breakoutView.bounds.midX, y: breakoutView.bounds.maxY - breakoutView.paddle.bounds.height - 80)
        } else {
            breakoutView.paddle.center = CGPoint(x: breakoutView.paddle.center.x, y: breakoutView.bounds.maxY - breakoutView.paddle.bounds.height - 80)
        }
        breakoutBehavior.addBarrier(UIBezierPath(rect: breakoutView.paddle.frame), named: "TEST")
    }
    
    func pushBall(gesture: UITapGestureRecognizer){
        if gesture.state == .Ended {
            breakoutBehavior.pushBall(breakoutView.ball)
        }
    }
    
    func panPaddle(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            breakoutView.placePaddle(gesture.translationInView(breakoutView))
            gesture.setTranslation(CGPointZero, inView: breakoutView)
        default: break
        }
    }
}