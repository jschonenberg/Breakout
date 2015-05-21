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
        Settings().ballCount = Int(sender.value)
    }
    
    @IBAction func ballSpeedChanged(sender: UISlider) {
        Settings().ballSpeedModifier = sender.value
    }
    
    @IBAction func brickRowsChanged(sender: UIStepper) {
        let rows = Int(sender.value)
        Settings().brickRows = rows
        brickRowsLabel.text = "\(rows)"
    }
    
    @IBAction func brickColumnsChanged(sender: UIStepper) {
        let columns = Int(sender.value)
        Settings().brickColumns = columns
        brickColumnsLabel.text = "\(columns))"
    }
}
