//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 21/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    
    private let gravity = UIGravityBehavior()
    
    private lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazyBallBehavior = UIDynamicItemBehavior()
        lazyBallBehavior.allowsRotation = false
        lazyBallBehavior.elasticity = 1.0
        lazyBallBehavior.friction = 0.0
        lazyBallBehavior.resistance = 0.0
        return lazyBallBehavior
    }()
    
    private lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        
        lazilyCreatedCollider.action = {
            for ball in self.balls {
                if !CGRectIntersectsRect(self.dynamicAnimator!.referenceView!.bounds, ball.frame) {
                    self.removeBall(ball)
                }
            }
        }
        
        return lazilyCreatedCollider
    }()
    
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        get { return collider.collisionDelegate }
        set { collider.collisionDelegate = newValue }
    }
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
    }
    
    func addBoundary(path: UIBezierPath, named identifier: NSCopying) {
        removeBoundary(identifier)
        collider.addBoundaryWithIdentifier(identifier, forPath: path)
    }
    
    func removeBoundary (identifier: NSCopying) { collider.removeBoundaryWithIdentifier(identifier) }
    
    var balls: [UIView] {
        get { return collider.items.filter{$0 is UIView}.map{$0 as! UIView} }
    }
    
    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func removeBall(ball: UIView) {
        ballBehavior.removeItem(ball)
        collider.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func pushBall(ball: UIView) {
        let push = UIPushBehavior(items: [ball], mode: .Instantaneous)
        push.magnitude = 0.25
        
        push.angle = CGFloat(Double(arc4random()) * M_PI * 2 / Double(UINT32_MAX))
        
        push.action = { [weak push] in
            if !push!.active { self.removeChildBehavior(push!) }
        }
        
        addChildBehavior(push)
    }
    
    func addBrick(brick: UIView) { gravity.addItem(brick) }
    func removeBrick(brick: UIView) { gravity.removeItem(brick) }
}
