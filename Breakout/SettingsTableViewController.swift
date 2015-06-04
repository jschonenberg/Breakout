//
//  SettingsTableViewController.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 16/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var levelSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var paddleWidthSegmentedControl: UISegmentedControl!
    @IBOutlet weak var controlByTiltingSwitch: UISwitch!
    
    @IBOutlet weak var ballCountLabel: UILabel!
    @IBOutlet weak var ballCountStepper: UIStepper!
    @IBOutlet weak var ballSpeedModifierSlider: UISlider!
    
    @IBAction func levelChanged(sender: UISegmentedControl) {
     Settings.level = Levels.levels[sender.selectedSegmentIndex]
        
        Settings.HaveChanged = true
    }
    
    @IBAction func ballCountChanged(sender: UIStepper)
    {
        Settings.ballCount = Int(ballCountStepper.value)
        ballCountLabel.text = "\(ballCountStepper.value)"
        Settings.HaveChanged = true
    }
    
    @IBAction func ballSpeedModifierChanged(sender: UISlider) {
    }
}
