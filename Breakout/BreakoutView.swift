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
        static let PaddleSize = CGSize(width: 180.0, height: 10.0)
        static let PaddleBottomMargin: CGFloat = 150.0
    }
    
    var paddleY: CGFloat {
        get { return self.bounds.maxY - Constants.PaddleBottomMargin - Constants.PaddleSize.height }
    }
    
    lazy var paddle: PaddleView = {
        let paddle = PaddleView(frame: CGRect(origin: CGPoint(x: self.center.x - Constants.PaddleSize.width/2, y: self.paddleY), size: Constants.PaddleSize))
        self.addSubview(paddle)
        return paddle;
    }()
    
    lazy var ball: BallView = {
        let ball = BallView(frame: CGRect(origin: CGPoint.zeroPoint, size: CGSize(width: 20, height: 20)))
        self.addSubview(ball)
        return ball
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.blackColor()
    }
    
    func placePaddle(translation: CGPoint) {
        var origin = paddle.frame.origin
        origin.x = max( min( origin.x + translation.x, self.bounds.maxX - Constants.PaddleSize.width), 0.0)
        paddle.frame.origin = origin
    }
}
