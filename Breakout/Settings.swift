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
        static let Changed = "Settings.Changed"
        static let Level = "Settings.Level"
        static let BallSpeedModifier = "Settings.BallSpeedModifier"
        static let BallCount = "Settings.BallCount"
    }
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // flag which indicates if the settings have been changed
    static var HaveChanged: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey(Keys.Changed) ?? false }
        set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Keys.Changed) }
    }
    
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
}