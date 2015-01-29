//
//  FunctionLexer.swift
//  Swifty
//
//  Created by Pouya Kary on 12/28/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

func functionSpaceLexer (inout #arendelle: Arendelle, inout #screen: codeScreen, #partTwoChar: Character) -> [String] {

    var result:[String] = []
    
    var whileControl = true
    var charToRead:Character
    var part = ""
    
    arendelle.i++
    
    while whileControl && arendelle.i < arendelle.code.utf16Count {
    
        charToRead = Array(arendelle.code)[arendelle.i]
        
        if charToRead == partTwoChar {
            
            if part =~ "[a-zA-Z0-9\\.]+" {
        
                result.append(part)
                whileControl = false;
                
            } else {
                screen.errors.append("Bad function name found: \(part)")
                return ["BadGrammar"]
            }
            
        } else {
        
            part.append(charToRead)
            arendelle.i++
            
            if arendelle.i == arendelle.code.utf16Count {
                screen.errors.append("Function name without parenthesis found")
                return ["BadGrammar"]
            }
        }
    }
    
    if arendelle.i < arendelle.code.utf16Count - 1 {
    
        let numberOfErrorBefore = screen.errors.count
        let specialParts = openCloseLexer(openCommand: partTwoChar, arendelle: &arendelle, screen: &screen)
        
        if screen.errors.count == numberOfErrorBefore {
        
            result += specialParts
            return result
            
        } else {
            screen.errors.append("Broken function parenthesis found")
            return ["BadGrammar"]
        }
    } 
    
    return result
}