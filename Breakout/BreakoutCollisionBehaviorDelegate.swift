//
//  BreakoutCollisionBehaviorDelegate.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 23/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import Foundation
import UIKit

protocol BreakoutCollisionBehaviorDelegate: UICollisionBehaviorDelegate {
    func ballLeftPlayingField(ball: BallView)
}