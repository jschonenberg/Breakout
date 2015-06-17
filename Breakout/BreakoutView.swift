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
        static let PaddleBottomMargin: CGFloat = 30.0
        
        static let BrickHeight: CGFloat = 25.0
        static let BrickSpacing: CGFloat = 5.0
        static let BricksTopSpacing: CGFloat = 20.0
        static let BrickSideSpacing: CGFloat = 10.0
    }

    private lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self) }()
    var behavior = BreakoutViewBehavior()
    
    var balls = [BallView]()
    var bricks =  [Int:BrickView]()
    
    lazy var paddle: PaddleView = {
        let paddle = PaddleView(frame: CGRect(origin: CGPoint(x: -1, y: -1), size: Constants.PaddleSize))
        self.addSubview(paddle)
        return paddle;
    }()
    
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
    
    func reset()
    {
        // remove all subviews excluding the paddle
        for view in self.subviews {
            if view as? PaddleView != paddle {
                view.removeFromSuperview()
            }
        }
        
        // reset behavior
        behavior.removeAllBoundaries();
        behavior.deregisterAllBalls();
        
        // reset vars
        balls = [BallView]()
        bricks = [Int:BrickView]()
        initialize()
    }

    func createBricks(arrangement: [[Int]]) {
        if arrangement.count == 0 { return }    // no rows
        if arrangement[0].count == 0 { return } // no columns
        
        let rows = arrangement.count
        
        for row in 0 ..< rows {
            let columns = arrangement[row].count
            
            for column in 0 ..< columns {
                if arrangement[row][column] == 0 { continue }
                
                let width = (self.bounds.size.width - 2 * Constants.BrickSpacing) / CGFloat(columns)
                let x = Constants.BrickSpacing + CGFloat(column) * width
                let y = Constants.BricksTopSpacing + CGFloat(row) * Constants.BrickHeight + CGFloat(row) * Constants.BrickSpacing * 2
                let hue = CGFloat(row) / CGFloat(rows)
                createBrick(width, x: x, y: y, hue: hue)
            }
        }
    }
    
    func createBrick(width: CGFloat, x: CGFloat, y: CGFloat, hue: CGFloat) {
        var frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: Constants.BrickHeight))
        frame = CGRectInset(frame, Constants.BrickSpacing, 0)
        
        let brick = BrickView(frame: frame, hue: hue)
        bricks[bricks.count] = brick
        
        addSubview(brick)
        behavior.addBoundary( UIBezierPath(roundedRect: brick.frame, cornerRadius: brick.layer.cornerRadius), named: (bricks.count - 1) )
    }
    
    func removeBrick(brickIndex: Int) {
        behavior.removeBoundary(brickIndex)
        
        if let brick = bricks[brickIndex] {
            UIView.transitionWithView(brick, duration: 0.3, options: .TransitionFlipFromBottom, animations: {
                brick.alpha = 0.5
                }, completion: { (success) -> Void in
                    UIView.animateWithDuration(1.0, animations: {
                        brick.alpha = 0.0
                        }, completion: { (success) -> Void in
                            print("REMOVING BRICK")
                            brick.removeFromSuperview()
                    })
            })
            
            bricks.removeValueForKey(brickIndex)
        }
    }
    
    func addBall() {
        let ball = BallView(frame: CGRect(origin: CGPoint(x: paddle.center.x, y: paddle.frame.minY - Constants.BallSize.height), size: Constants.BallSize))
        balls.append(ball)
        
        self.addSubview(ball)
        self.behavior.registerBall(ball)
    }
    
    func removeBall(ball: BallView){
        ball.removeFromSuperview()
        self.behavior.deregisterBall(ball)
        
        if let index = find(balls, ball) {
            balls.removeAtIndex(index)
        }
    }
    
    func translatePaddle(translation: CGPoint) {
        var newFrame = paddle.frame
        newFrame.origin.x = max( min(newFrame.origin.x + translation.x, self.bounds.maxX - Constants.PaddleSize.width), 0.0) // min = 0, max = maxX - paddle width
        
        for ball in balls {
            if CGRectContainsRect(newFrame, ball.frame) {
                return
            }
        }
        
        paddle.frame = newFrame;
        updatePaddleBoundary()
    }
    
    private func resetPaddlePosition() {
        if !CGRectContainsRect(self.bounds, paddle.frame) {
            paddle.center = CGPoint(x: self.bounds.midX, y: self.bounds.maxY - paddle.bounds.height - Constants.PaddleBottomMargin)
        } else {
            paddle.center = CGPoint(x: paddle.center.x, y: self.bounds.maxY - paddle.bounds.height - Constants.PaddleBottomMargin)
        }
        
        updatePaddleBoundary()
    }
    
    func updatePaddleBoundary() {
        behavior.addBoundary(UIBezierPath(ovalInRect: paddle.frame), named: Constants.paddleBoundaryId)
    }
}
