//
//  Extensions.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 20/06/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import Foundation

extension String {
    func repeat(n:Int) -> String {
        if n <= 0 { return "" }
        
        var result = self
        for _ in 1 ..< n { result.extend(self) }
        return result
    }
}

extension Array {
    func find(includedElement: T -> Bool) -> Int? {
        for (idx, element) in enumerate(self) {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
}