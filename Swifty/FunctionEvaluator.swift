//
//  FunctionEvaluator.swift
//  Swifty
//
//  Created by Pouya Kary on 12/29/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation



func funcEval (#funcParts: FuncParts, inout #screen: codeScreen, inout #spaces: [String:[NSNumber]]) -> [NSNumber] {
    
    
    if funcParts.name == "BadGrammar" { return [0] }
    
    let numberOfErrorsInStart = screen.errors.count
    
    func funcHeaderReader (inout #code: Arendelle) -> [String] {
        
        let header = code.code =~ "<(.|\n)*>"
        
        if header.items.count > 0 {
        
            if code.code.hasPrefix(header[0]) {
                
                return openCloseLexer(openCommand: "<", arendelle: &code, screen: &screen)
                
            } else {
                screen.errors.append("Function started with something other than function header")
                return ["BadGrammar"]
            }
            
        } else {
            return [""]
        }
        
    }

    if funcParts.name =~ "[a-zA-Z0-9\\.]+" {
        
        let funcURL = arendellePathToNSURL(arendellePath: funcParts.name, kind: "arendelle" , screen: &screen)
        
        if checkIfURLExists (funcURL) {
   
            var funcCode = Arendelle(code: preprocessor (codeToBeSpaceFixed: String(contentsOfURL: funcURL, encoding: NSUTF8StringEncoding, error: nil)!, screen: &screen))

            if funcCode.code != "" {
            
                var funcSpaces: [String: [NSNumber]] = ["@return":[0]]
                let headerParts = funcHeaderReader(code: &funcCode )
                
                //
                // FUNCTION SPACE'S EVAL
                //
                
                
                var numberOfHeaderParts = headerParts.count; if headerParts[0] == "" { numberOfHeaderParts--}
                var numberOfFunctionParts = funcParts.inputs.count; if funcParts.inputs[0] == "" { numberOfFunctionParts--}
                
                if numberOfHeaderParts == numberOfFunctionParts {
                    
                    for var counter = 0; counter < numberOfFunctionParts; counter++  {
                        
                        let regexMatchForPartTwo = funcParts.inputs[counter] =~ "((\\$|\\@)[0-9a-zA-Z\\.]+)|(![a-zA-Z0-9\\.]+(\\((?:\\(.*\\)|[^\\(\\)])*\\)))"
                        
                        let spaceName = "@\(headerParts[counter])"
                        
                        
                        //----- Space overwrite -----------------------------------------------------------------------------------------
                        
                        if regexMatchForPartTwo.items.count == 1 && regexMatchForPartTwo.items[0] == funcParts.inputs[counter] {
                         
                            funcSpaces[spaceName] = spaceOverwriterWithID(funcParts.inputs[counter], &spaces, &screen)
                            
                        //----- Only first space ----------------------------------------------------------------------------------------
                            
                        } else {
                            
                            var spaceValue = mathEval(stringExpression: funcParts.inputs[counter], screen: &screen, spaces: &spaces)
                            
                            if spaceValue.itsNotACondition == true && spaceValue.doesItHaveErros == false {
                                
                                funcSpaces[spaceName] = [spaceValue.result]
                                
                            } else {
                                if spaceValue.doesItHaveErros == true {
                                    screen.errors.append("Header value for '\(spaceName)' of function: !\(funcParts.name)() is broken")
                                } else {
                                    screen.errors.append("Conditional value fount for '\(spaceName)' of function: !\(funcParts.name)()")
                                }
                            }
                        }
                        
                        //---------------------------------------------------------------------------------------------------------------
                    }
                    
                //
                // ERROR FOR FUNCTION SPACE NUMBERS
                //
                
                    
                } else {
                    switch (numberOfHeaderParts) {
                    case 0:
                        screen.errors.append("Function: !\(funcParts.name)() takes no space")
                    case 1:
                        screen.errors.append("Function: !\(funcParts.name)() takes one space")
                    default:
                        screen.errors.append("Function: !\(funcParts.name)() takes \(headerParts.count) spaces")
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
                    return [0]
                }
                
                //
                // DONE
                //
                
                
            } else {
                screen.errors.append("Could not load function '\(funcParts.name)'")
                return [0]
            }
            
        } else {
            screen.errors.append("No function with name '\(funcParts.name)' found")
            return [0]
        }
    
    } else {
        screen.errors.append("Bad function name: '\(funcParts.name)' found")
        return [0]
    }
}