//
//  main.swift
//  Swifty
//
//  Created by Pouya Kary on 11/14/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

// init of golobal variables
var spaces: [String: String] = ["@return":"0"]

var x = 60 , y = 10

var screen = codeScreen(xsize: x, ysize: y)
var arendelle = Arendelle()
    arendelle.i = 0
    arendelle.code = "[ 10 , pr ] [ 5 , pd ] [ 10 , pr ] [ 5 , pu ] [ 10 , pr ]"

    
eval(&arendelle, &screen, &spaces)



println("Matrix for the code \'" + arendelle.code + "\':")
for var i = 0; i < y; i++ {
    print("\n   ")
    for var j = 0; j < x; j++ {
        var color = screen.screen[j,i]
    
        switch color {
            
        case 0:
            print(".")
            
        default:
            print(color)
        }
    }
}
println("\n")

