//
//  masterEval.swift
//  Swifty
//
//  Created by Pouya Kary on 11/25/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

func masterEvaluator (#code: String, #screenWidth: Int, #screenHeight: Int) -> codeScreen {
    
    //
    // Initing the first spaces
    //
    
    var spaces: [String: String] = ["@return":"0"]
    var screen = codeScreen(xsize: screenWidth, ysize: screenHeight)
    
    
    /// Space remover tool: removes spaces and comments from
    /// the code for performance
    func preprocessor (#codeToBeSpaceFixed: String) -> String {
    
        var theCode = Arendelle ()
        theCode.code = codeToBeSpaceFixed
        var result : String = ""
        
        while theCode.i < theCode.code.utf16Count {
        
            var currentChar:Character = Array(theCode.code)[theCode.i]
            
            switch currentChar {
                
            case "'" :
                result += "'" + onePartOpenCloseParser(openCloseCommand: "'", arendelle: &theCode, screen: &screen) + "'"
                --theCode.i
                
            case "/" :
                ++theCode.i
                currentChar = Array(theCode.code)[theCode.i]
                
                //
                // SLASH SLASH COMMENT REMOVER
                //
                
                if currentChar == "/" {
                
                    theCode.i++
                    var whileControl = true
                    
                    while theCode.i < theCode.code.utf16Count && whileControl {
                    
                        currentChar = Array(theCode.code)[theCode.i]
                        
                        if currentChar == "\n" {
                            
                            whileControl = false
                        
                        } else {
                        
                            theCode.i++
                        
                        }
                
                    }
                    
                    
                //
                // SLASH START ... STAR SLASH REMOVER
                //
                    
                } else if currentChar == "*" {
                
                    theCode.i++
                    var whileControl = true
                    
                    while theCode.i < theCode.code.utf16Count && whileControl {
                    
                        currentChar = Array(theCode.code)[theCode.i]
                        
                        if currentChar == "*" {
                        
                            theCode.i++
                            
                            if theCode.i < theCode.code.utf16Count {
                            
                                currentChar = Array(theCode.code)[theCode.i]
                                
                                if currentChar == "/" {
                                
                                    whileControl = false
                                
                                } else {
                                
                                    theCode.i++
                                    currentChar = Array(theCode.code)[theCode.i]
                                
                                }
                            }
                        }
                        
                        theCode.i++
                    }
                    
                    if whileControl == true { screen.errors.append("Unfinished /* ... */ comment") }
                
                //
                // ARE WE WRONG
                //
                
                } else {
                
                    result += "/"
                    result.append(currentChar)
                    
                }
                
                theCode.i--
                
            case " ", "\n", "\t" :
                break

            default:
                result.append(currentChar)
            
            }
            
            theCode.i++
        }

        return result
    }

    //
    // Rest of initilization
    //
    
    var arendelle = Arendelle()
    arendelle.i = 0
    arendelle.code = preprocessor(codeToBeSpaceFixed: code)
    
    
    //
    // EVALUATION
    //

    eval(&arendelle, &screen, &spaces)
    
    
    // done
    return screen
}