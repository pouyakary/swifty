//
//  main.swift
//  Swifty
//
//  Created by Pouya Kary on 11/14/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

// the very starting point

import Foundation

//
// REPL INPUT
//

func replInput () -> String {

    var whileControlForREPLInput = true
    var result = ""
    var specialCharactersNumbers = [ "(":0 , "[":0, "{":0 , ")":0 , "]":0, "}":0 ]
    
    
    print("\nλ ")
    
    while whileControlForREPLInput {
    
        let tempInput = readLine()
        result += tempInput
        
        for specialChar in specialCharactersNumbers {
        
            let number = (result =~ "\\\(specialChar.0)").items.count
            let name = specialChar.0
            specialCharactersNumbers[name] = number
        
        }

        
        if specialCharactersNumbers["("] == specialCharactersNumbers[")"] && specialCharactersNumbers ["["] == specialCharactersNumbers ["]"] && specialCharactersNumbers["{"] == specialCharactersNumbers["}"]  {
            
            whileControlForREPLInput = false
            
        } else {
            print("→ ")
        }
    }
    return result
}


//
// PRINT MATRIX
//

func printMatrix (#result: codeScreen) {

    clean()
    println("\nFinal Matrix in size of #i=\(x) and #j=\(y) (finished at #x:\(result.x) #y:\(result.y)) :")
    
    //println("Matrix for the code \'" + arendelle.code + "\':")
    for var i = 0; i < y; i++ {
        print("\n   ")
        for var j = 0; j < x; j++ {
            var color = result.screen[j,i]
            
            if color != 0 {
                print("\(color) ")
            } else {
                print("  ")
            }
        }
    }
    
    println("\n\nFinal title: '\(result.title)'\n\n")
}


//
// PRINT ERROR
//

func printError (#result: codeScreen) {

    var i = 1;
    
    println("\n  ⎪ ✖︎ Compilation Failed Because Of \(result.errors.count) Known Error\(PIEndS(number: result.errors.count)):")
    for error in result.errors {
        println("  ⎪ → \(error.lowercaseString)")
        i++
    }
}


//
// PRINT SPACES:
//

func printSpaces (#spaces: [String:[NSNumber]]) {
    if spaces.count > 0 {
        for space in spaces {
            println("• \(space.0) → \(space.1)")
        }
    } else {
        println("\n  ⎪ ✖︎ No space found")
    }
}


//
// REPL
//

let x = 30, y = 10
var masterScreen = codeScreen(xsize: x, ysize: y)
var whileControl = true
var masterSpaces: [String:[NSNumber]] = ["arendelle":[0]]
masterSpaces.removeAll(keepCapacity: false)

println("\nSwifty : Arendelle's Apple Core REPL")
println("Copyright 2014-2015 Pouya Kary <k@arendelle.org>\n")

while true {
    
    var code = replInput()
    
    if code == "clean" {
    
        clean()
        
        masterSpaces.removeAll(keepCapacity: false)
        masterScreen = codeScreen(xsize: x, ysize: y)
        
    } else if code == "pwd" {
        
        println("\n--> \(masterScreen.mainPath)")
    
    } else if code == "cls" {
        
        clean()
    
    } else if code == "exit" {
     
        clean(); break
    
    } else if code == "print" {
    
        printMatrix(result: masterScreen)
        
    } else if code == "title" {
        
        println("\n--> '\(masterScreen.title)'")
    
    } else if code == "dump" {
        
        printSpaces(spaces: masterSpaces)
        
    } else if code == "help" {
        
        println()
        println("  ⎪ Swifty - Arendelle Apple Core's REPL\n  ⎪")
        println("  ⎪ λ [code]   : Evalautes the [code]")
        println("  ⎪ λ = [expr] : Evaluates the [expr]")
        println("  ⎪ λ dump     : Prints the spaces")
        println("  ⎪ λ pwd      : codeScreen.mainPath")
        println("  ⎪ λ cls      : Terminal clean")
        println("  ⎪ λ print    : Prints the codeScreen")
        println("  ⎪ λ title    : Shows the codeScreen.title")
        println("  ⎪ λ help     : Shows this help")
    
    } else if code.hasPrefix("= ") {
        
        var tempScreen = codeScreen(xsize: x, ysize: y)
        code = preprocessor(codeToBeSpaceFixed: code, screen: &tempScreen)
        
        var expr = code.stringByReplacingOccurrencesOfString("=", withString: "", options: NSStringCompareOptions.allZeros, range: nil)
        
        var tempResult = mathEval(stringExpression: expr, screen: &tempScreen, spaces: &masterSpaces).result
        
        if ( tempScreen.errors.count > 0 ) {
        
            printError(result: tempScreen)
        
        } else {
            
            println("\n--> \(tempResult)")
        
        }
    
    } else {
    
        var tempScreen = masterScreen
        var tempArendelle = Arendelle(code: preprocessor(codeToBeSpaceFixed: code, screen: &tempScreen))
        var tempSpaces = masterSpaces
        eval(&tempArendelle, &tempScreen, &tempSpaces)
        
        if tempScreen.errors.count > 0 {
        
            printError(result: tempScreen)
        
        } else {
        
            masterSpaces = tempSpaces
            masterScreen = tempScreen
        
        }
    }
}

// done