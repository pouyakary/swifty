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
        
        if specialCharactersNumbers["("] == specialCharactersNumbers[")"] && specialCharactersNumbers ["["] == specialCharactersNumbers ["]"] && specialCharactersNumbers["{"] == specialCharactersNumbers["}"] {
            
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

func printMatrix (#result: codeScreen) -> Void {

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

func printError (#result: codeScreen) -> Void {

    var i = 1;
    for error in result.errors {
        println("-> \(i): \(error)")
        i++
    }
}


//
// PRINT SPACES:
//

func printSpaces (#spaces: [String:NSNumber]) {
    if spaces.count > 0 {
        for space in spaces {
            println("=> \(space.0) -> \(space.1)")
        }
    } else {
        println("=> no space found")
    }
}




//
// REPL
//

let x = 30, y = 10
var masterScreen = codeScreen(xsize: x, ysize: y)
var whileControl = true
var masterSpaces: [String: NSNumber] = ["kary":10]
masterSpaces.removeAll(keepCapacity: false)

println("Arendelle Swift Core Based REPL")
println("Copyright 2014 Pouya Kary <k@arendelle.org>\n")

while true {
    
    var code = replInput()
    
    if code == "clean" {
    
        clean()
        
        masterSpaces.removeAll(keepCapacity: false)
        masterScreen = codeScreen(xsize: x, ysize: y)
        
    } else if code == "cls" {
        
        clean()
    
    } else if code == "exit" {
     
        clean(); break
    
    } else if code == "print" {
    
        printMatrix(result: masterScreen)
        
    } else if code == "spaces" {
        
        printSpaces(spaces: masterSpaces)
        
    } else if code.hasPrefix("=") {
        
        println("  \(replacer(expressionString: code, spaces: masterSpaces, screen: &masterScreen))")
    
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


//
// DONE
//
