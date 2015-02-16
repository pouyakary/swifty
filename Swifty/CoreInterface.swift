//
//  CoreInterface.swift
//  Swifty
//
//  Created by Pouya Kary on 12/15/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

func spaceInput (#text: String, inout #screen: codeScreen) -> NSNumber {
    print("\n  \(text) ")

    let result = readLine()
    
    let regTest = result =~ "[0-9\\.]+"
    
    if result != "." && regTest.items.count == 1 {
        
        if regTest.items[0] == result {
        
            return NSNumber(float: result.toFloat()) 
        
        } else {
            report("Unacceptable user input", &screen)
            return 0
        }
        
    } else {
        report("Unacceptable user input", &screen)
        return 0
    }
}