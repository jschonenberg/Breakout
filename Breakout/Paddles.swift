//
//  Paddles.swift
//  Breakout
//
//  Created by Mad Max on 20/06/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class Paddles
{
     private let PaddleSizeBig = CGSize(width: 180.0, height: 15.0)
     private let PaddleSizeSmall = CGSize(width:70.0, height: 5.0)
     private let PaddleSizeMedium = CGSize(width:110.0, height: 10.0)
     static let PaddleSize = Paddles().GetPaddleSize()
    
    private func GetPaddleSize() -> CGSize
    {
        if(Settings.paddleWidth == nil)
        {
            Settings.paddleWidth = 1
            return PaddleSizeMedium
        }
        
        switch(Settings.paddleWidth!)
        {
        case(0):
            return PaddleSizeSmall
            break
            
        case(1):
            return PaddleSizeMedium
            break
            
        case(2):
            return PaddleSizeBig
            break
            
        default:
            return PaddleSizeMedium
            break
        }
    }
}
