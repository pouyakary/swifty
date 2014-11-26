//
//  codeScreen.swift
//  Swifty
//
//  Created by Pouya Kary on 11/14/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

struct codeScreen {
    
    // Screen
    var screen = P2DArray(cols: 10, rows: 10)
    
    init (xsize:Int, ysize: Int) {
        
        self.screen = P2DArray(cols: xsize, rows: ysize)
        
    }
    
    // title
    var title:String = ""
    
    // Ordinations
    var x = 0
    var y = 0
    var z = 0
    
    // ...
    var n = 1
    var whileSign = true
    
    // code controling
    var line = 1
    var line2 = 0
    var mainPath = ""
    var funcName = "main"
    
}
