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
    
    PiConsoleBlue(); PiConsoleBold(); print("\nλ "); PiConsoleWhite()
    
    while whileControlForREPLInput {
        
        let tempInput = PiConsoleReadLine();
        
        colorReset()
        
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
            PiConsoleBlue(); PiConsoleBold(); print("→ "); PiConsoleWhite()
        }
    }
    return result
}


//
// Color reset
//

func colorReset () {

    PiConsoleReset()
    PiConsoleWhite()

}

//
// PRINT MATRIX
//

func printMatrix (#result: codeScreen) {
    
    print("\n    ┌ "); for var lineI1 = 0; lineI1 < x; lineI1++ { print("  ") }; print("┐")
    
    for var i = 0; i < y; i++ {
        
        if floor(Double(y)/2) == Double(i) {
        
            print("\n--> │ ")
            
        } else {
        
            print("\n    │ ")
        
        }

        for var j = 0; j < x; j++ {
            var color = result.screen[j,i]
            
            switch ( color ) {
            
            case 1:
                PiConsoleGreen()
                
            case 2:
                PiConsoleCayan()
                
            case 3:
                PiConsoleMagenta()
                
            case 4:
                PiConsoleRed()
                
            default:
                
                PiConsoleBlue()
            
            }
            
            print("\(color) ")
            
            colorReset()
        }
        print("⎪")
    }
    
    print("\n    └ "); for var lineI1 = 0; lineI1 < x; lineI1++ { print("  ") }; println("┘")

    colorReset()
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
    
    colorReset()
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

var x = 34, y = 21; var prompts = 0, fails = 0, blueprints = 1, directs = 0, directFails = 0, prints = 0, dumps = 0
var masterScreen = codeScreen(xsize: x, ysize: y)
var whileControl = true
var masterSpaces: [String:[NSNumber]] = ["arendelle":[0]]
masterSpaces.removeAll(keepCapacity: false)

PiConsoleBold();

println("\n  ____          _  __ _               ")
println(" / ___|_      _(_)/ _| |_ _   _       ")
println(" \\___ \\ \\ /\\ / / | |_| __| | | |  ")
println("  ___) \\ V  V /| |  _| |_| |_| |     ")
println(" |____/ \\_/\\_/ |_|_|  \\__|\\__, |  ")
println("                          |___/       ")

colorReset()

println("\nSwifty : Apple Core REPL for Arendelle")
println("Edition 1, Build 72 - Supporting up to Specification 2XII")
println("Copyright 2014-2015 Pouya Kary <k@arendelle.org>")

func screenResize () {

    ++blueprints
    
    masterSpaces.removeAll(keepCapacity: false)
    masterScreen = codeScreen(xsize: x, ysize: y)

}

while true {
    
    var code = replInput();
    prompts++
    
    if code == "clean" {
        
        PiConsoleClean()
        
        screenResize()
        
    } else if code == "reset" {
        
        screenResize()
        
    } else if code == "resize" {
        
        print("  x= "); x = PiConsoleReadLine().toInt();
        print("  y= "); y = PiConsoleReadLine().toInt();
        
        screenResize()
    
    } else if code == "pwd" {
        
        titleWriteLine(masterScreen.mainPath)
    
    } else if code == "cls" {
        
        PiConsoleClean()
    
    } else if code == "exit" {
    
        prompts--
        
        println("\n  ⎪ ♨︎ Season Information\n  ⎪ → prompts: \(prompts - fails) successful of \(prompts)\n  ⎪ → blueprints: total of \(blueprints)\n  ⎪ → direct mathEval access: \(directs - directFails) successful of \(directs)\n  ⎪ → matrix prints: \(prints)\n  ⎪ → dumps: \(dumps)\n\n  Goodbye!\n\n")
        
        PiConsoleReset()
        break
        
    } else if code == "matrix" {
    
        prints++
        printMatrix(result: masterScreen)
        
    } else if code == "title" {
        
        prints++
        titleWriteLine(masterScreen.title)
    
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
        println("  ⎪ λ clean    : Reset + CLS")
        println("  ⎪ λ reset    : Resets the screen into a new blueprint")
        println("  ⎪ λ resize   : Resizes the ")
        println("  ⎪ λ matrix   : Prints the matrix")
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
                
                titleWriteLine("\(tempResult.result)")
                    
            } else {
                    
                if tempResult.result == 1 {
                    
                    titleWriteLine("Right")
                    
                } else {
                    
                    print("\n--> "); PiConsoleRed(); PiConsoleBold(); println("Wrong"); colorReset()
                        
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