//
//  FunctionEvaluator.swift
//  Swifty
//
//  Created by Pouya Kary on 12/29/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

func funcEval (#grammarParts: [String], inout #screen: codeScreen, inout #spaces: [String:NSNumber]) -> NSNumber {
    
    let numberOfErrorsInStart = screen.errors.count
    
    func funcHeaderReader (inout #code: Arendelle) -> [String] {
        
        var result:[String] = []
        
        let header = code.code =~ "<(.|\n)*>"
        
        if header.items.count > 0 {
        
            if code.code.hasPrefix(header[0]) {
                
                return openCloseLexer(openCommand: "<", arendelle: &code, screen: &screen)
                
            } else {
                screen.errors.append("Function started with something other than function header")
                return ["BadGrammar"]
            }
            
        } else {
            screen.errors.append("No function header fount")
            return ["BadGrammar"]
        }
        
    }

    if grammarParts[0] =~ "[a-zA-Z0-9\\.]+" {
        
        let funcURL = arendellePathToNSURL(arendellePath: grammarParts[0], kind: "arendelle" , screen: &screen)
        
        if checkIfURLExists (funcURL) {
   
            var funcCode = Arendelle(code: preprocessor (codeToBeSpaceFixed: String(contentsOfURL: funcURL, encoding: NSUTF8StringEncoding, error: nil)!, screen: &screen))

            if funcCode.code != "" {
            
                var funcSpaces: [String: NSNumber] = ["@return":0]

                let headerParts = funcHeaderReader(code: &funcCode )
                
                //
                // FUNCTION SPACE'S EVAL
                //
                
                let matchInGerammarParts = grammarParts[1] =~ "( |\n|\t|)*"
                var numberOfGrammarParts = grammarParts.count; if matchInGerammarParts[0] == grammarParts[1] { numberOfGrammarParts-- }
                let matchInHeaderParts = headerParts[0] =~ "( |\n|\t|)*"
                var numberOfHeaderParts = headerParts.count; if matchInHeaderParts[0] == headerParts[0] { numberOfHeaderParts-- }
                
                
                if numberOfHeaderParts == numberOfGrammarParts - 1 && numberOfHeaderParts > 0 {

                    for var counter = 1; counter < grammarParts.count; counter++  {
                        
                        let spaceName = "@\(headerParts[counter-1])"

                        var spaceValue = mathEval(stringExpression: grammarParts[counter], screen: &screen, spaces: &spaces)

                        if spaceValue.itsNotACondition == true && spaceValue.doesItHaveErros == false {
                            
                            funcSpaces[spaceName] = spaceValue.result
                            
                        } else {
                            if spaceValue.doesItHaveErros == true {
                                screen.errors.append("Header value for '\(spaceName)' of function: !\(grammarParts[0])() is broken")
                            } else {
                                screen.errors.append("Conditional value fount for '\(spaceName)' of function: !\(grammarParts[0])()")
                            }
                        }
                    }
                    
                //
                // ERROR FOR FUNCTION SPACE NUMBERS
                //
                
                } else {
                    switch (numberOfHeaderParts) {
                    case 0:
                        screen.errors.append("Function: !\(grammarParts[0])() takes no space")
                    case 1:
                        screen.errors.append("Function: !\(grammarParts[0])() takes one space")
                    default:
                        screen.errors.append("Function: !\(grammarParts[0])() takes \(headerParts.count) spaces")
                    }
                }
                
                
                //
                // FUNCTION EVAL
                //
                
                if numberOfErrorsInStart == screen.errors.count {
                
                    let toBeRemoved = eval (&funcCode, &screen, &funcSpaces)
                    evalSpaceRemover(spaces: &funcSpaces, spacesToBeRemoved: toBeRemoved)
                    return funcSpaces["@return"]!
                    
                } else {
                
                    return 0
                
                }
                
                //
                // DONE
                //
                
                
            } else {
                screen.errors.append("Could not load function '\(grammarParts[0])'")
                return 0
            }
            
        } else {
            screen.errors.append("No function with name '\(grammarParts[0])' found")
            return 0
        }
    
    } else {
        screen.errors.append("Bad function name: '\(grammarParts[0])' found")
        return 0
    }
}