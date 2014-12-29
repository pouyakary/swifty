//
//  OnePartOpenCloseParser.swift
//  Swifty
//
//  Created by Pouya Kary on 11/23/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

func onePartOpenCloseParser (#openCloseCommand:Character, inout #arendelle: Arendelle, inout #screen: codeScreen) -> String {

    // going to the right char
    ++arendelle.i
    
    // our result
    var result:String = ""
    
    // value replacing controller
    var replace:Bool = false
    
    // corrent char
    var charToRead:Character
    
    while arendelle.i < arendelle.code.utf16Count {
    
        // corrent char
        charToRead = Array(arendelle.code)[arendelle.i]
        
        switch charToRead {
        
        case openCloseCommand :
            arendelle.i++
            return result
            
        case "\\" :
            
            if arendelle.i < arendelle.code.utf16Count {
            
                arendelle.i++
                charToRead = Array(arendelle.code)[arendelle.i]
                
                switch charToRead {
                    
                case "\"" :
                    result += "\""
                    
                case "'"  :
                    result += "'"
                    
                case "\\" :
                    result += "\\"
                    
                default:
                    screen.errors.append("Bad escape sequence: '\\\(charToRead)'")
                }
            
            } else {
            
                screen.errors.append("Unfinished \(openCloseCommand)...\(openCloseCommand) grammar found")
                return "BadGrammar"
            
            }
            
        default:
            result.append(charToRead)
        
        }
        
        arendelle.i++
    
    }
    
    screen.errors.append("Unfinished \(openCloseCommand)...\(openCloseCommand) grammar found")
    return "BadGrammar"
}