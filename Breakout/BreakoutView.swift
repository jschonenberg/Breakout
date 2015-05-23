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
        static let selfBoundaryId = "selfBoundary"
        static let paddleBoundaryId = "paddleBoundary"
        
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
    }

    private lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self) }()
    var behavior = BreakoutViewBehavior()
    
    lazy var paddle: PaddleView = {
        let paddle = PaddleView(frame: CGRect(origin: CGPoint(x: -1, y: -1), size: Constants.PaddleSize))
        self.addSubview(paddle)
        return paddle;
    }()
    
    var balls: [BallView] = []
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
    }
    
    override func layoutSubviews() {
        var playingFieldBounds = self.bounds
        playingFieldBounds.size.height *= 2.0
        behavior.addBoundary(UIBezierPath(rect: playingFieldBounds), named: Constants.selfBoundaryId)
        
        resetPaddlePosition()
        
        for ball in balls {
            animator.updateItemUsingCurrentState(ball)
        }
    }

    func createBricks(arrangement: [[Int]]) {
        if arrangement.count == 0 { return }    // no rows
        if arrangement[0].count == 0 { return } // no columns
        
        let rows = arrangement.count
        
        for row in 0 ..< rows {
            let columns = arrangement[row].count
            
            for column in 0 ..< columns {
                if arrangement[row][column] == 0 { return }
                
                let width = (self.bounds.size.width - 2 * Constants.BrickSpacing) / CGFloat(columns)
                let x = Constants.BrickSpacing + CGFloat(column) * width
                let y = Constants.BrickTopSpacing + CGFloat(row) * Constants.BrickHeight + CGFloat(row) * Constants.BrickSpacing * 2
                let color = Constants.BrickColors[row % Constants.BrickColors.count]
                createBrick(width, x: x, y: y, color: color)
            }
        }
    }
    
    func createBrick(width: CGFloat, x: CGFloat, y: CGFloat, color: UIColor) {
        var frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: Constants.BrickHeight))
        frame = CGRectInset(frame, Constants.BrickSpacing, 0)
        
        let brick = BrickView(frame: frame)
        brick.backgroundColor = color
        addSubview(brick)
        
        bricks.append(brick)
        behavior.addBoundary(UIBezierPath(roundedRect: brick.frame, cornerRadius: brick.layer.cornerRadius), named: (bricks.count-1))
    }
    
    func addBall() {
        let ball = BallView(frame: CGRect(origin: CGPoint(x: paddle.center.x, y: paddle.center.y - 2*Constants.PaddleSize.height), size: Constants.BallSize))
        self.addSubview(ball)
        self.behavior.addBall(ball)
        balls.append(ball)
    }
    
    func removeBall(ball: BallView){
        self.behavior.removeBall(ball)
        ball.removeFromSuperview()
        
        if let index = find(balls, ball) {
            balls.removeAtIndex(index)
        }
    }
    
    func translatePaddle(translation: CGPoint) {
        var origin = paddle.frame.origin
        origin.x = max( min( origin.x + translation.x, self.bounds.maxX - Constants.PaddleSize.width), 0.0) // min = 0, max = maxX - paddle width
        paddle.frame.origin = origin
        updatePaddleBoundary()
    }
    
    private func resetPaddlePosition() {
        if !CGRectContainsRect(self.bounds, paddle.frame) {
            paddle.center = CGPoint(x: self.bounds.midX, y: self.bounds.maxY - paddle.bounds.height)
        } else {
            paddle.center = CGPoint(x: paddle.center.x, y: self.bounds.maxY - paddle.bounds.height)
        }
        
        updatePaddleBoundary()
    }
    
    func updatePaddleBoundary() {
        behavior.addBoundary(UIBezierPath(ovalInRect: paddle.frame), named: Constants.paddleBoundaryId)
    }
}
