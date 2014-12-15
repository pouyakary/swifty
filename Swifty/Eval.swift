//
//  Eval.swift
//  Swifty
//
//  Created by Pouya Kary on 11/14/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

    /// Kernel of Arendelle which evaluates the given code
    /// :param Arendelle a given Arendelle instance
    /// :param
    func eval (inout arendelle: Arendelle, inout screen: codeScreen, inout spaces: [String:NSNumber]) -> [String] {
                var spacesToRemove:[String] = []
        var command:Character
        
        func paintInDot (color: Int) {
            if screen.x < screen.screen.colCount() && screen.y < screen.screen.rowCount()
                && screen.x >= 0 && screen.y >= 0 {
                    screen.screen[screen.x, screen.y] = color
            }
        }
        
        while arendelle.i < arendelle.code.utf16Count {
            
            command = Array(arendelle.code.lowercaseString)[arendelle.i]
            
            switch command {
                
            // grammars
                
            case "(" :
                var grammarParts = openCloseLexer(openCommand: "(", arendelle: &arendelle, screen: &screen)
                spaceEval(grammarParts: grammarParts, screen: &screen, spaces: &spaces, arendelle: &arendelle)
                
            case "[" :
                var grammarParts = openCloseLexer(openCommand: "[", arendelle: &arendelle, screen: &screen)
                loopEval(grammarParts: grammarParts, screen: &screen, spaces: &spaces, arendelle: &arendelle)
                
            case "{" :
                var grammarParts = openCloseLexer(openCommand: "{", arendelle: &arendelle, screen: &screen)
               conditionEval(grammarParts: grammarParts, screen: &screen, spaces: &spaces, arendelle: &arendelle)
                
            case "'" :
                screen.title = spaceReplacer(expressionString: onePartOpenCloseParser(openCloseCommand: "'", arendelle: &arendelle, screen: &screen), spaces: spaces, screen: &screen)
                --arendelle.i
                
            // commands
                
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
                
            case ",":
                screen.errors.append("Using gramamr divider ',' out of grammars")
                
            case "<", ">":
                screen.errors.append("Using function grammar in the middel of the app")
                
            case "]", "}", ")" :
                screen.errors.append("Grammar closer: '\(command)' is used for an undifined grammar")
                
            default:
                screen.errors.append("Unknown command: '\(command)'")
            }
            
            arendelle.i++
        
        }
    
        return spacesToRemove

}