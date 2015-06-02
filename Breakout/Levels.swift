//
//  Levels.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 22/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import Foundation

public class Levels {

static let levels = [levelOne, levelTwo, levelThree]
    
static let levelOne =      [[1,0,1,0,1,0,1],
                            [0,1,0,1,0,1,0],
                            [1,0,1,0,1,0,1],
                            [0,1,0,1,0,1,0],
                            [1,0,1,0,1,0,1],
                            [0,1,0,1,0,1,0],
                            [1,0,1,0,1,0,1]]

static let levelTwo =      [[1,1,1,1,1,1,1],
                            [1,1,1,1],
                            [1,1,1],
                            [1,1,1,1],
                            [1,1,1,1,1,1,1]]

static let levelThree =    [[1,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1]]

}