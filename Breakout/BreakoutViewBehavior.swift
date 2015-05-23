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
    
    private lazy var collisionBehavior: UICollisionBehavior = {
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
    
    private var balls: [BallView] {
        get { return collisionBehavior.items.filter{$0 is BallView}.map{$0 as! BallView} }
    }
    
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
    
    func launchBall(ball: UIView, magnitude: CGFloat, minAngle: Int = 0, maxAngle: Int = 360) {
        let pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        pushBehavior.magnitude = magnitude

        let randomAngle = minAngle + Int( arc4random_uniform( UInt32(maxAngle - minAngle + 1) ) )
        let randomAngleRad = Double(randomAngle) * M_PI / 180.0
        pushBehavior.angle = CGFloat(randomAngleRad)
        
        pushBehavior.action = { [weak pushBehavior] in
            if !pushBehavior!.active { self.removeChildBehavior(pushBehavior!) }
        }
        
        addChildBehavior(pushBehavior)
    }
}