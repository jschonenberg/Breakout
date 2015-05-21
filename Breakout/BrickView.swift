//
//  BrickView.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 21/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class BrickView: UIView {
    private struct Constants {
        static let cornerRadius: CGFloat = 2.0
        static let defaultBackgroundColor = UIColor.whiteColor()
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        setAppearance()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setAppearance (){
        self.layer.cornerRadius = Constants.cornerRadius
        self.backgroundColor = Constants.defaultBackgroundColor
    }
}
