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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.tabBarController?.tabBar.tintColor = UIColor.blackColor()
        self.tabBarController?.tabBar.barTintColor = UIColor.whiteColor()
    }
    
    @IBAction func PaddleWidthChanged(sender: UISegmentedControl)
    {
        Settings.paddleWidth = sender.selectedSegmentIndex
        Settings.ResetRequired = true
    }
    
    @IBAction func levelChanged(sender: UISegmentedControl) {
        Settings.level = Levels.levels[sender.selectedSegmentIndex]
        Settings.ResetRequired = true
    }
    
    @IBAction func TiltingChanged(sender: UISwitch)
    {
        Settings.tilting = sender.on
        Settings.ResetRequired = true
    }
    
    @IBAction func ballCountChanged(sender: UIStepper)
    {
        Settings.ballCount = Int(ballCountStepper.value)
        ballCountLabel.text = "\(Int(ballCountStepper.value))"
        Settings.UpdateRequired = true
    }
    
    @IBAction func ballSpeedModifierChanged(sender: UISlider)
    {
        Settings.ballSpeedModifier = ballSpeedModifierSlider.value
        Settings.ResetRequired = true
    }
}
