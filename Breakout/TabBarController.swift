//
//  TabBarController.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 17/06/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }

}
