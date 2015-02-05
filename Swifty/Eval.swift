//
//  Eval.swift
//  Swifty
//
//  Created by Pouya Kary on 11/14/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation


    /// removes spaces defined eval
    func evalSpaceRemover (inout #spaces: [String:[NSNumber]], #spacesToBeRemoved: [String]) {
        for space in spacesToBeRemoved {
            if spaces[space] != nil && space != "@return" {
                spaces.removeValueForKey(space)
            }
        }
    }

    /// Kernel of Arendelle which evaluates any given Arendelle Blueprint
    func eval (inout arendelle: Arendelle, inout screen: codeScreen, inout spaces: [String:[NSNumber]]) -> [String] {
                    
        var spacesToRemove:[String] = []
        
        var command:Character
        
        /// Paints a dot in the matrix
        func paintInDot (color: Int) {
            if screen.x < screen.screen.colCount() && screen.y < screen.screen.rowCount()
                && screen.x >= 0 && screen.y >= 0 {
                    screen.screen[screen.x, screen.y] = color
            }
        }
        
        var arryToRead = Array(arendelle.code.lowercaseString)
        
        while arendelle.i < arendelle.code.utf16Count {
            
            command = arryToRead[arendelle.i]
            
            switch command {
                
            //
            // GRAMMARS
            //
                
            case "(" :
                let grammarParts = openCloseLexer(openCommand: "(", arendelle: &arendelle, screen: &screen)
                let spaceToBeRemoved = spaceEval(grammarParts: grammarParts, screen: &screen, spaces: &spaces, arendelle: &arendelle)
                if spaceToBeRemoved != "" { spacesToRemove.append(spaceToBeRemoved) } 
                
            case "[" :
                let grammarParts = openCloseLexer(openCommand: "[", arendelle: &arendelle, screen: &screen)
                loopEval(grammarParts: grammarParts, screen: &screen, spaces: &spaces, arendelle: &arendelle)
                
            case "{" :
                let grammarParts = openCloseLexer(openCommand: "{", arendelle: &arendelle, screen: &screen)
               conditionEval(grammarParts: grammarParts, screen: &screen, spaces: &spaces, arendelle: &arendelle)
                
            case "'" :
                screen.title = onePartOpenCloseParser(openCloseCommand: "'", spaces: &spaces, arendelle: &arendelle, screen: &screen, preprocessorState: false)
                --arendelle.i
                
                
            //
            // FUNCTION
            //
                
            case "!" :
                let functionParts = functionLexer(arendelle: &arendelle, screen: &screen)
                funcEval(funcParts: functionParts, screen: &screen, spaces: &spaces)
                
            
                
            //
            // COMMANDS
            //
                
            case "p":
                paintInDot(screen.n)
                
            case "c":
                paintInDot(0)
                
            case "i":
                screen.x = 0
                screen.y = 0
                
            case "n":
                if screen.n == 4 { screen.n = 1 } else { screen.n++ }
                
            case "r":
                screen.x++
                
            case "l":
                screen.x--
                
            case "u":
                screen.y--
                
            case "d":
                screen.y++
                
            case "w":
                NSThread.sleepForTimeInterval(0.1)
                
            case "s":
                screen.errors.append("Stop-Clean command is no longer supported by Arendelle compilers")
                
            case ",":
                screen.errors.append("Using gramamr divider ',' out of grammars")
                
            case "<", ">":
                screen.errors.append("Using function header in middle of blueprint")
                
            case "]", "}", ")" :
                screen.errors.append("Grammar closer: '\(command)' is used for an undifined grammar")
                
            case ";":
                screen.errors.append("Semicolons found in command-zone")
                
            case "@":
                screen.errors.append("Space sign found in command-zone")
                
            case "#":
                screen.errors.append("Source sign found in command-zone")
                
            case "$":
                screen.errors.append("Stored space sign found in command-zone")
                
            case "*", "/", "^", "-", "+", "%" :
                screen.errors.append("Arithmetic operator '\(command)' found in command-zone")
                
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                screen.errors.append("Number '\(command)' found in command-zone")
                
            default:
                screen.errors.append("Unknown command: \(command)")
            }
            
            arendelle.i++
        
        }
    
        return spacesToRemove
}
