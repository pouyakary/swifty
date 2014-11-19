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
    func eval (inout arendelle: Arendelle, inout screen: codeScreen, inout spaces: [String:String]) -> [String] {
    
        var spacesToRemove:[String] = []
        var command:Character
        
        func paintInDot (color: Int) {
            if ( screen.x < screen.screen.colCount() && screen.y < screen.screen.rowCount()
                && screen.x >= 0 && screen.y >= 0) {
                    screen.screen[screen.x, screen.y] = color
            }
        }
        
        for command in arendelle.code {
            
            switch command {
                
            case "[":
                var grammarParts = openCloseLexer(openCommand: "[", arendelle: &arendelle, screen: &screen)
                
                let LoopNum:Int? = grammarParts[0].toInt()
                
                for var i = 0; i < LoopNum ; i++ {
                
                    var loopCode = Arendelle()
                        loopCode.code = grammarParts[1]
                                    
                    eval(&loopCode, &screen, &spaces)
                }
                
                arendelle.i++
                
            case "p":
                paintInDot(screen.n)
                
            case "c":
                paintInDot(0)
                
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
                
            default:
                print("")
            }
            
            
        
        }
        
        return spacesToRemove

}