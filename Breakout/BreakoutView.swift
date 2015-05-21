//
//  BreakoutView.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 21/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class BreakoutView: UIView {
    private struct Constants {
        static let BallSize = CGSize(width: 20, height: 20)
        
        static let PaddleSize = CGSize(width: 180.0, height: 15.0)
        static let PaddleBottomMargin: CGFloat = 50.0
        
        static let BrickHeight: CGFloat = 25.0
        static let BrickSpacing: CGFloat = 5.0
        static let BrickTopSpacing: CGFloat = 20.0
        static let BrickSideSpacing: CGFloat = 10.0
        static let BrickColors = [
            UIColor(red:1, green:0.28, blue:0.22, alpha:1),
            UIColor(red:0.99, green:0.42, blue:0.23, alpha:1),
            UIColor(red:1, green:0.65, blue:0.15, alpha:1),
            UIColor(red:1, green:0.79, blue:0.17, alpha:1),
            UIColor(red:0.43, green:0.93, blue:0.43, alpha:1),
            UIColor(red:0.35, green:0.78, blue:0.98, alpha:1)
        ]
        
        static let selfBoundaryId = "selfBoundary"
        static let paddleBoundaryId = "paddleBoundary"
    }

    private lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self) }()
    
    var behavior = BreakoutBehavior()
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        get { return behavior.collisionDelegate }
        set { behavior.collisionDelegate = newValue }
    }
    
    lazy var ball: BallView = {
        let lazyBall = BallView(frame: CGRect(origin: CGPoint.zeroPoint, size: Constants.BallSize))
        self.addSubview(lazyBall)
        self.behavior.addBall(lazyBall)
        return lazyBall
        }()
    
    lazy var paddle: PaddleView = {
        let paddle = PaddleView(frame: CGRect(origin: CGPoint(x: -1, y: -1), size: Constants.PaddleSize))
        self.addSubview(paddle)
        return paddle;
    }()
    
    var bricks: [BrickView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.blackColor()        
        animator.addBehavior(behavior)
        animator.updateItemUsingCurrentState(ball)
    }
    
    override func layoutSubviews() {
        behavior.addBoundary(UIBezierPath(rect: self.bounds), named: Constants.selfBoundaryId)
    }
    
    func resetPaddle() {
            paddle.center = CGPoint(x: self.bounds.midX, y: self.bounds.maxY - paddle.bounds.height - Constants.PaddleBottomMargin)

        
        behavior.addBoundary(UIBezierPath(rect: paddle.frame), named: Constants.paddleBoundaryId)
    }
    
    func translatePaddle(translation: CGPoint) {
        var origin = paddle.frame.origin
        origin.x = max( min( origin.x + translation.x, self.bounds.maxX - Constants.PaddleSize.width), 0.0)
        paddle.frame.origin = origin
        behavior.addBoundary(UIBezierPath(rect: paddle.frame), named: Constants.paddleBoundaryId)
    }
    
    func createBricks(arrangement: [[Int]]) {
        if arrangement.count == 0 { return }    // no rows
        if arrangement[0].count == 0 { return } // no columns
        
        let rows = arrangement.count
        
        for row in 0 ..< rows {
            let columns = arrangement[row].count
            
            for column in 0 ..< columns {
                
                if arrangement[row][column] != 0 {
                    let width = (self.bounds.size.width - 2 * Constants.BrickSpacing) / CGFloat(columns)
                    let x = Constants.BrickSpacing + CGFloat(column) * width
                    let y = Constants.BrickTopSpacing + CGFloat(row) * Constants.BrickHeight + CGFloat(row) * Constants.BrickSpacing * 2
                    
                    var frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: Constants.BrickHeight))
                    frame = CGRectInset(frame, Constants.BrickSpacing, 0)
                    
                    let brick = BrickView(frame: frame)
                    brick.backgroundColor = Constants.BrickColors[row % Constants.BrickColors.count]
                    bricks.append(brick)
                    behavior.addBoundary(UIBezierPath(roundedRect: brick.frame, cornerRadius: brick.layer.cornerRadius), named: (bricks.count-1))
                    addSubview(brick)
                }
                
            }
        }
    }
}
