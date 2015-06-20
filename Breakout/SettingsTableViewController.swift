//
//  SettingsTableViewController.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 16/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, LevelScannerDelegate {

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
        if sender.selectedSegmentIndex == 3 {
            performSegueWithIdentifier("startLevelScanner", sender: self)
            return
        }
        
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
    
    func LevelScanComplete(level: Array<[Int]>) {
        Settings.level = level
        Settings.ResetRequired = true
    }
    
    func LevelScanCancelled() {
        // level scan cancelled, select level 1 as default
        levelSegmentedControl.selectedSegmentIndex = 0
        levelChanged(levelSegmentedControl)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startLevelScanner" {
            if let nvc = segue.destinationViewController as? UINavigationController {
                if let lsvc = nvc.topViewController as? LevelScannerViewController {
                    lsvc.delegate = self
                }
            }
        }
    }
}

private struct PaddleWidths {
    static let Small = 20
    static let Medium = 33
    static let Large = 50
}
