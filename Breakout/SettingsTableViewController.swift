//
//  SettingsTableViewController.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 16/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var paddleWidthSegmentedControl: UISegmentedControl!

    @IBOutlet weak var ballCountLabel: UILabel!
    @IBOutlet weak var ballCountStepper: UIStepper!
    @IBOutlet weak var ballSpeedSlider: UISlider!
    
    @IBOutlet weak var brickRowsLabel: UILabel!
    @IBOutlet weak var brickRowsStepper: UIStepper!
    @IBOutlet weak var brickColumnsLabel: UILabel!
    @IBOutlet weak var brickColumnsStepper: UIStepper!
    
    
    @IBAction func paddleWidthChanged(sender: UISegmentedControl) {
    }
    
    @IBAction func ballCountChanged(sender: UIStepper) {
    }
    
    @IBAction func ballSpeedChanged(sender: UISlider) {
    }
    
    @IBAction func brickRowsChanged(sender: UIStepper) {
        brickRowsLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func brickColumnsChanged(sender: UIStepper) {
        brickColumnsLabel.text = "\(Int(sender.value))"
    }
}
