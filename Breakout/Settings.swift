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
    }
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // flag which indicates if the settings have been changed
    var HaveChanged: Bool {
        get { return userDefaults.boolForKey(Keys.Changed) ?? false }
        set { userDefaults.setBool(newValue, forKey: Keys.Changed) }
    }
    
    var level: [Array<Int>] {
        get { return (userDefaults.objectForKey(Keys.Level) as? [Array<Int>])! }
        set { userDefaults.setObject(newValue, forKey: Keys.Level) }
    }
    
    var ballSpeedModifier: Float? {
        get { return userDefaults.floatForKey(Keys.BallSpeedModifier) }
        set { userDefaults.setFloat(newValue!, forKey: Keys.BallSpeedModifier) }
    }
}