//
//  Settings.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 16/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import Foundation

class Settings {
    private struct Defaults {
        static let Level = Levels.levelOne
        static let BallSpeedModifier = Float(0.5)
        static let MaxBalls = 3
        static let PaddleWidth = PaddleWidthPercentage.Medium
        static let ControlWithTilt = false
    }
    
    private struct Keys {
        static let ResetRequired = "Settings.ResetRequired"
        
        static let Level = "Settings.Level"
        static let BallSpeedModifier = "Settings.BallSpeedModifier"
        static let MaxBalls = "Settings.BallCount"
        static let PaddleWidth = "Settings.PaddleWidth"
        static let ControlWithTilt = "Settings.ControlWithTilt"
    }
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // flag to indicate that a complete reset is required
    static var ResetRequired: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey(Keys.ResetRequired) ?? false }
        set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Keys.ResetRequired) }
    }
    
    // gameplay settings
    
    static var level: [Array<Int>] {
        get { return (NSUserDefaults.standardUserDefaults().objectForKey(Keys.Level) as? [Array<Int>]) ?? Defaults.Level}
        set { NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Keys.Level) }
    }
    
    static var ballSpeedModifier: Float {
        get { return NSUserDefaults.standardUserDefaults().floatForKey(Keys.BallSpeedModifier) ?? Defaults.BallSpeedModifier }
        set { NSUserDefaults.standardUserDefaults().setFloat(newValue, forKey: Keys.BallSpeedModifier) }
    }
    
    static var maxBalls: Int
    {
        get { return NSUserDefaults.standardUserDefaults().integerForKey(Keys.MaxBalls) ?? Defaults.MaxBalls }
        set { NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: Keys.MaxBalls) }
    }
    
    static var paddleWidth: Int
    {
        get{ return NSUserDefaults.standardUserDefaults().integerForKey(Keys.PaddleWidth) ?? Defaults.PaddleWidth}
        set{ NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: Keys.PaddleWidth)}
        
    }
    
    static var controlWithTilt: Bool
    {
        get{ return NSUserDefaults.standardUserDefaults().boolForKey(Keys.ControlWithTilt) ?? Defaults.ControlWithTilt}
        set{ NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Keys.ControlWithTilt)}
    }
}

struct PaddleWidthPercentage {
    static let Small = 20
    static let Medium = 35
    static let Large = 50
}