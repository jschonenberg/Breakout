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
        
        ballSpeedModifierSlider.value = Settings.ballSpeedModifier
        controlByTiltingSwitch.on = Settings.controlWithTilt
        ballCountStepper.value = Double(Settings.maxBalls)
        ballCountLabel.text = "\(Int(ballCountStepper.value))"
        
        levelSegmentedControl.selectedSegmentIndex = Levels.levels.find { $0 == Settings.level } ?? (levelSegmentedControl.numberOfSegments - 1)
        
        switch(Settings.paddleWidth){
        case PaddleWidths.Small: paddleWidthSegmentedControl.selectedSegmentIndex = 0
        case PaddleWidths.Medium: paddleWidthSegmentedControl.selectedSegmentIndex = 1
        case PaddleWidths.Large: paddleWidthSegmentedControl.selectedSegmentIndex = 2
        default: paddleWidthSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    @IBAction func PaddleWidthChanged(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0: Settings.paddleWidth = PaddleWidths.Small
        case 1: Settings.paddleWidth = PaddleWidths.Medium
        case 2: Settings.paddleWidth = PaddleWidths.Large
        default: Settings.paddleWidth = PaddleWidths.Medium
        }
    }
    
    @IBAction func levelChanged(sender: UISegmentedControl) {
        Settings.level = Levels.levels[sender.selectedSegmentIndex]
        Settings.ResetRequired = true
    }
    
    @IBAction func TiltingChanged(sender: UISwitch)
    {
        Settings.controlWithTilt = sender.on
    }
    
    @IBAction func ballCountChanged(sender: UIStepper)
    {
        Settings.maxBalls = Int(ballCountStepper.value)
        ballCountLabel.text = "\(Int(ballCountStepper.value))"
    }
    
    @IBAction func ballSpeedModifierChanged(sender: UISlider)
    {
        Settings.ballSpeedModifier = ballSpeedModifierSlider.value
    }
}

private struct PaddleWidths {
    static let Small = 20
    static let Medium = 33
    static let Large = 50
}
