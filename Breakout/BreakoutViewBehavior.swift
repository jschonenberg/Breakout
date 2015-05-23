//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 21/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class BreakoutViewBehavior: UIDynamicBehavior {
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        get { return collisionBehavior.collisionDelegate }
        set { collisionBehavior.collisionDelegate = newValue }
    }
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let lazyCollisionBehavior = UICollisionBehavior()
        
        lazyCollisionBehavior.action = {
            if let delegate = lazyCollisionBehavior.collisionDelegate as? BreakoutCollisionBehaviorDelegate {
                for ball in self.balls {
                    if !CGRectIntersectsRect(self.dynamicAnimator!.referenceView!.bounds, ball.frame) {
                        delegate.ballLeftPlayingField(ball)
                    }
                }
            }
        }
        
        return lazyCollisionBehavior
    }()
    
    private lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazyBallBehavior = UIDynamicItemBehavior()
        lazyBallBehavior.allowsRotation = false
        lazyBallBehavior.elasticity = 1.0
        lazyBallBehavior.friction = 0.0
        lazyBallBehavior.resistance = 0.0
        return lazyBallBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(ballBehavior)
    }
    
    func addBoundary(path: UIBezierPath, named identifier: NSCopying) {
        removeBoundary(identifier)
        collisionBehavior.addBoundaryWithIdentifier(identifier, forPath: path)
    }
    
    func removeBoundary (identifier: NSCopying) {
        collisionBehavior.removeBoundaryWithIdentifier(identifier)
    }
    
    var balls: [BallView] {
        get { return collisionBehavior.items.filter{$0 is BallView}.map{$0 as! BallView} }
    }
    
    func addBall(ball: BallView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        collisionBehavior.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func removeBall(ball: BallView) {
        ballBehavior.removeItem(ball)
        collisionBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func launchBall(ball: UIView, magnitude: CGFloat) {
        let pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        pushBehavior.magnitude = magnitude
        pushBehavior.angle = CGFloat(Double(arc4random()) * M_PI * 2 / Double(UINT32_MAX))
        
        pushBehavior.action = { [weak pushBehavior] in
            if !pushBehavior!.active { self.removeChildBehavior(pushBehavior!) }
        }
        
        addChildBehavior(pushBehavior)
    }
}
