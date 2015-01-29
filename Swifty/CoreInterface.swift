//
//  CoreInterface.swift
//  Swifty
//
//  Created by Pouya Kary on 12/15/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

func spaceInput (#text: String) -> NSNumber {
    print("\n  \(text) ")
    let result =  readLine().toFloat()
    
    return result
}