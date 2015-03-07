//
//  main.swift
//  Swifty
//
//  Created by Pouya Kary on 11/14/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//


//
//  THIS VERSION OF SWIFTY SUPPORTS ARENDELLE 
//  UP TO ARENDELLE SPECIFICATION 2XII
//


// the very starting point

import Foundation



/* ------------------------------- *
 * ::::: R E P L   I N P U T ::::: *
 * ------------------------------- */

func replInput () -> String {

    var whileControlForREPLInput = true
    var result = ""
    var specialCharactersNumbers = [ "/\\*":0, "(":0 , "[":0, "{":0 , "*\\/":0, ")":0 , "]":0, "}":0 ]
    
    
    print("\nλ ")
    
    while whileControlForREPLInput {
    
        let tempInput = readLine()
        result += tempInput
        
        for specialChar in specialCharactersNumbers {
        
            let number = (result =~ "\\\(specialChar.0)").items.count
            let name = specialChar.0
            specialCharactersNumbers[name] = number
        
        }
        
        if specialCharactersNumbers["("] == specialCharactersNumbers[")"] &&
           specialCharactersNumbers ["["] == specialCharactersNumbers ["]"] &&
           specialCharactersNumbers["{"] == specialCharactersNumbers["}"] &&
           specialCharactersNumbers["/\\*"] == specialCharactersNumbers["*\\/"] {
            
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

    var i = 1; fails++
    
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
            println("\n  • \(space.0) → \(space.1)")
        }
    } else {
        println("\n   ⎪ ✖︎ No space found")
    }
}



func compilerBroken () {
    
    println("\n  Execution of compiler failed due to an unknown runtime problem...")

}


/* ------------------- *
 * ::::: R E P L ::::: *
 * ------------------- */

let x = 30, y = 10; var prompts = 0, fails = 0, blueprints = 1, directs = 0, directFails = 0, prints = 0, dumps = 0
var masterScreen = codeScreen(xsize: x, ysize: y)
var whileControl = true
var masterSpaces: [String:[NSNumber]] = ["arendelle":[0]]
masterSpaces.removeAll(keepCapacity: false)

println("\nSwifty : Apple Core REPL for Arendelle")
println("Edition 1, Build 61 - Supporting up to Specification 2XII")
println("Copyright 2014-2015 Pouya Kary <k@arendelle.org>")

while true {
    
    var code = replInput();
    prompts++
    
    if code == "clean" {
    
        ++blueprints
        
        clean()
        
        masterSpaces.removeAll(keepCapacity: false)
        masterScreen = codeScreen(xsize: x, ysize: y)
        
    } else if code == "pwd" {
        
        println("\n--> \(masterScreen.mainPath)")
    
    } else if code == "cls" {
        
        clean()
    
    } else if code == "exit" {
    
        prompts--
        
        println("\n  ⎪ ♨︎ Season Information\n  ⎪ → prompts: \(prompts - fails) successful of \(prompts)\n  ⎪ → blueprints: total of \(blueprints)\n  ⎪ → direct mathEval access: \(directs - directFails) successful of \(directs)\n  ⎪ → matrix prints: \(prints)\n  ⎪ → dumps: \(dumps)\n\n  Goodbye!\n\n")
        break
    
    } else if code == "print" {
    
        prints++
        printMatrix(result: masterScreen)
        
    } else if code == "title" {
        
        prints++
        println("\n  \(masterScreen.title)")
    
    } else if code == "dump" {
        
        dumps++
        printSpaces(spaces: masterSpaces)
        
    } else if code == "help" {
        
        println("")
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
        
        directs++
        
        var tempScreen = codeScreen(xsize: x, ysize: y)

        var expr =  preprocessor(codeToBeSpaceFixed: code, screen: &tempScreen).removeFromStart("=");
            
        var tempResult = mathEval(stringExpression: expr, screen: &tempScreen, spaces: &masterSpaces)
            
        if ( tempScreen.errors.count > 0 ) {
                
            directFails++
                
            printError(result: tempScreen)
                
        } else {
                
            if tempResult.itsNotACondition {
                
                println("\n--> \(tempResult.result)")
                    
            } else {
                    
                if tempResult.result == 1 {
                    
                    println("\n--> Right")
                    
                } else {
                    
                    println("\n--> Wrong")
                        
                }
            }
        }
    
    } else {

        var tempScreen = masterScreen
        var tempArendelle = Arendelle(code: preprocessor(codeToBeSpaceFixed: code, screen: &tempScreen))
        var tempSpaces = masterSpaces
            
        eval(&tempArendelle, &tempScreen, &tempSpaces);
            
        if tempScreen.errors.count > 0 {
                
            printError(result: tempScreen)
                
        } else {
                
            masterSpaces = tempSpaces
            masterScreen = tempScreen
                
        }

    }
}

// done