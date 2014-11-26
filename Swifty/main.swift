//
//  main.swift
//  Swifty
//
//  Created by Pouya Kary on 11/14/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

var whileControl = true

while whileControl {
    
    println("Enter a code: ")
    let x = 43 , y = 7, code = readLine()
    
    if code == "exit" { whileControl = false; break }

    let result = masterEvaluator(code: code, screenWidth: x, screenHeight: y)

    println("\n\nFinal Matrix:")

    //println("Matrix for the code \'" + arendelle.code + "\':")
    for var i = 0; i < y; i++ {
        print("\n   ")
        for var j = 0; j < x; j++ {
            var color = result.screen[j,i]
            print(color)
        }
    }

    println("\n\nFinal title: '\(result.title)'\n\n")
}

// done