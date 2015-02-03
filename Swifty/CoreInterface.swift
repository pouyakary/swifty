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
    
        if regTest.items[1] == result {
        
            return result.toFloat()
        
        } else {
            screen.errors.append("Unacceptable user input")
            return 0;
        }
        
    } else {
        screen.errors.append("Unacceptable user input")
        return 0
    }
}