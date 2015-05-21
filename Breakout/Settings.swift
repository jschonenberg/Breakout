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
        static let PaddleSize = "Settings.PaddleSize"
        static let BallCount = "Settings.BallCount"
        static let BallSpeed = "Settings.BallSpeed"
        static let BrickRows = "Settings.BrickRows"
        static let BrickColumns = "Settings.BrickColumns"
    }
    
    // PaddleSize in percentage of the max paddle width
    enum PaddleSize: Int {
        case Small = 33
        case Medium = 66
        case Large = 100
    }
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // flag which indicates if the settings have been changed
    var Changed: Bool {
        get { return userDefaults.objectForKey(Keys.Changed) as? Bool ?? false }
        set { userDefaults.setObject(newValue, forKey: Keys.Changed) }
    }
    
    var paddleSize: PaddleSize {
        get { return PaddleSize.Medium }
        set { userDefaults.setObject(newValue.rawValue, forKey: Keys.PaddleSize)}
    }
    
    var ballCount: Int? {
        get { return userDefaults.objectForKey(Keys.BallCount) as? Int }
        set { userDefaults.setObject(newValue, forKey: Keys.BallCount) }
    }
    
    var ballSpeedModifier: Float? {
        get { return userDefaults.objectForKey(Keys.BallSpeed) as? Float }
        set { userDefaults.setObject(newValue, forKey: Keys.BallSpeed) }
    }
    
    var brickRows: Int? {
        get { return userDefaults.objectForKey(Keys.BrickRows) as? Int }
        set { userDefaults.setObject(newValue, forKey: Keys.BrickRows) }
    }
    
    var brickColumns: Int? {
        get { return userDefaults.objectForKey(Keys.BrickColumns) as? Int }
        set { userDefaults.setObject(newValue, forKey: Keys.BrickColumns) }
    }
}