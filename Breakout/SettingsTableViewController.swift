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
    }
    
    @IBAction func levelChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 3 {
            performSegueWithIdentifier("startLevelScanner", sender: self)
        } else {
            Settings.level = Levels.levels[sender.selectedSegmentIndex]
            Settings.ResetRequired = true
        }
    }
    
    @IBAction func ballCountChanged(sender: UIStepper)
    {
        Settings.ballCount = Int(ballCountStepper.value)
        ballCountLabel.text = "\(Int(ballCountStepper.value))"
        Settings.UpdateRequired = true
    }
    
    @IBAction func ballSpeedModifierChanged(sender: UISlider) {
    }
    
    func LevelScanComplete(level: Array<[Int]>) {
        println("LevelScanComplete")
        Settings.level = level
        Settings.ResetRequired = true
    }
    
    func LevelScanCancelled() {
        println("LevelScanCancelled")
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
