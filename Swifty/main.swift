//
//  main.swift
//  Swifty
//
//  Created by Pouya Kary on 11/14/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

let x = 43 , y = 7, code = "[ 10 , [ 6 , pr ] pd ] [ 20 , pr ] 'hello'"

let result = masterEvaluator(code: code, screenWidth: x, screenHeight: y)

println("Final Matrix:")

//println("Matrix for the code \'" + arendelle.code + "\':")
for var i = 0; i < y; i++ {
    print("\n   ")
    for var j = 0; j < x; j++ {
        var color = result.screen[j,i]
        print(color)
    }
}

println("\n\nFinal title: '\(result.title)'")

