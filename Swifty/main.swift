//
//  main.swift
//  Swifty
//
//  Created by Pouya Kary on 11/14/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

// the very starting point

import Foundation

println("Arendelle Swift Core Based REPL")
println("Copyright 2014 Pouya Kary <k@arendelle.org>\n")

var whileControl = true

while whileControl {
    
    print("λ ")
    let x = 42 , y = 7, code = readLine()
    
    if code == "exit" { whileControl = false; break }

    let result = masterEvaluator(code: code, screenWidth: x, screenHeight: y)

    if result.errors.count > 0 {
        
        println("\n\nCompilation Failed: \n")
        var i = 1;
        for error in result.errors {
            println("-> \(i): \(error)")
            i++
        }
        
        println("\n")

    } else {
        
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
}

// done