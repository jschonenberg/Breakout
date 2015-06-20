//
//  Settings.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 16/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import Foundation

class Settings {
    private struct Keys {
        static let ResetRequired = "Settings.ResetRequired"
        static let UpdateRequired = "Settings.UpdateRequired"
        static let Level = "Settings.Level"
        static let BallSpeedModifier = "Settings.BallSpeedModifier"
        static let BallCount = "Settings.BallCount"
        static let PaddleWidth = "Settings.PaddleWidth"
        static let Accelorometer = "Settings.Accelorometer"
    }
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // flag to indicate that a complete reset is required
    static var ResetRequired: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey(Keys.ResetRequired) ?? false }
        set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Keys.ResetRequired) }
    }
    
    // flag to indicate that settings can be reloaded without resetting the current progress
    static var UpdateRequired: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey(Keys.UpdateRequired) ?? false }
        set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Keys.UpdateRequired) }
    }
    
    /*
     *    Actual gameplay variables
     */
    
    static var level: [Array<Int>] {
        get { return (NSUserDefaults.standardUserDefaults().objectForKey(Keys.Level) as? [Array<Int>])! }
        set { NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Keys.Level) }
    }
    
    static var ballSpeedModifier: Float? {
        get { return NSUserDefaults.standardUserDefaults().floatForKey(Keys.BallSpeedModifier) }
        set { NSUserDefaults.standardUserDefaults().setFloat(newValue!, forKey: Keys.BallSpeedModifier) }
    }
    
    static var ballCount: Int?
    {
        get { return NSUserDefaults.standardUserDefaults().integerForKey(Keys.BallCount) }
        set { NSUserDefaults.standardUserDefaults().setInteger(newValue!, forKey: Keys.BallCount) }
    }
    
    static var paddleWidth: Int?
    {
        get{ return NSUserDefaults.standardUserDefaults().integerForKey(Keys.PaddleWidth)}
        set{ NSUserDefaults.standardUserDefaults().setInteger(newValue!, forKey: Keys.PaddleWidth)}
        
    }
    
    static var tilting: Bool
    {
        get{ return NSUserDefaults.standardUserDefaults().boolForKey(Keys.Accelorometer)}
        set{ NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Keys.Accelorometer)}
        
    }
}