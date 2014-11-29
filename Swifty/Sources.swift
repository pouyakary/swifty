//
//  Sources.swift
//  Swifty
//
//  Created by Pouya Kary on 11/28/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

/// replaces the sources wiht their values
func sourceReplacer (inout #screen: codeScreen, #expression: String) -> String {
    
   return expression.replace("#rnd"   , withString: arendelleRandom())
                    .replace("#i"     , withString: "\(screen.screen.colCount())")
                    .replace("#j"     , withString: "\(screen.screen.rowCount())")
                    .replace("#width" , withString: "\(screen.screen.colCount())")
                    .replace("#height", withString: "\(screen.screen.rowCount())")
                    .replace("#x"     , withString: "\(screen.x)")
                    .replace("#y"     , withString: "\(screen.y)")
                    .replace("#n"     , withString: "\(screen.n)")
                    .replace("#pi"    , withString: "3.141592653589")
}


/// creates a arendelle standard random number
func arendelleRandom () -> String {

    var r:String = ""
    switch arc4random_uniform(5) {
    
    case 2:
        return "0.0\(arc4random_uniform(10000))"
        
    case 3:
        return "0.00\(arc4random_uniform(10000))"
        
    default:
        return "0.\(arc4random_uniform(10000))"
    
    }
}

// done