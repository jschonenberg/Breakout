//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 21/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

protocol BreakoutCollisionBehaviorDelegate: UICollisionBehaviorDelegate {
    func ballHitBrick(behavior: UICollisionBehavior, ball: BallView, brickIndex: Int)
    func ballLeftPlayingField(behavior: UICollisionBehavior, ball: BallView)
}

class BreakoutViewBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    
    var breakoutCollisionDelegate: BreakoutCollisionBehaviorDelegate?
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let lazyCollisionBehavior = UICollisionBehavior()
        lazyCollisionBehavior.collisionDelegate = self
        
        lazyCollisionBehavior.action = {
            for ball in self.balls {
                if !CGRectIntersectsRect(self.dynamicAnimator!.referenceView!.bounds, ball.frame) {
                    self.breakoutCollisionDelegate?.ballLeftPlayingField(lazyCollisionBehavior, ball: ball)
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
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier boundaryId: NSCopying, atPoint p: CGPoint) {
        if let brickIndex = boundaryId as? Int {
            if let ball = item as? BallView {
                self.breakoutCollisionDelegate?.ballHitBrick(behavior, ball: ball, brickIndex: brickIndex)
            }
        }
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