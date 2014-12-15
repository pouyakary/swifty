//
//  SpaceEvaluator.swift
//  Swifty
//
//  Created by Pouya Kary on 12/15/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

func spaceEval (#grammarParts:[String], inout #screen: codeScreen, inout #spaces: [String:NSNumber], inout #arendelle: Arendelle) -> Void {

    func spaceRegexNameError (#text: String) {
        screen.errors.append("Unaccepted space name : '\(grammarParts[0])'")
    }
    
    let regexMathes = grammarParts[0] =~  "([A-Z]|[a-z]|[0-9])+"
    
    if grammarParts.count == 1 {
    
        //
        // UNTITLED INPUT
        //
        
        if regexMathes.items.count == 1 && regexMathes.items[0] == grammarParts[0] {
        
            let spaceValue = spaceInput(text: "Sign space '@\(grammarParts[0])' with a number:")
            spaces["@\(grammarParts[0])"] = spaceValue
        
        } else {
            spaceRegexNameError(text: grammarParts[0])
        }
        
        //
        // END OF UNTITLED INPUT
        //
        
    } else if grammarParts.count == 2 {

        if regexMathes.items.count == 1 && regexMathes.items[0] == grammarParts[0] {
            
            //
            // INPUT
            //
            
            if grammarParts[1].hasPrefix("\"") && grammarParts[1].hasSuffix("\"") {
                
                var spaceInputArendelleFortmat = Arendelle(code: grammarParts[1])
                let spaceInputText = onePartOpenCloseParser(openCloseCommand: "\"", arendelle: &spaceInputArendelleFortmat, screen: &screen)
                var spaceValue = spaceInput(text: spaceInputText)
                
                spaces["@\(grammarParts[0])"] = spaceValue
                
            //
            // STANDARD INIT OF SPACE
            //
                
            } else {
                
                let spaceValue = mathEval(stringExpression: grammarParts[1], screen: &screen, spaces: &spaces)
                
                if spaceValue.doesItHaveErros == false {
                    
                    if spaceValue.itsNotACondition == true {
                        
                        //
                        // INIT OF SPACE WITH 2 PARTS
                        //
                        
                            spaces["@\(grammarParts[0])"] = spaceValue.result
                        
                        //
                        // END OF SPACE WITH 2 PARTS
                        //
                        
                    } else {
                        screen.errors.append("Unaccepted using of conditions in space value: '\(grammarParts[1])'")
                    }
                    
                } else {
                    screen.errors.append("Bad expression: '\(grammarParts[1])'")
                }
            }
        
        } else {
            spaceRegexNameError(text: grammarParts[0])
        }
    
    } else {
        screen.errors.append("Space grammar found with more than 2 parts.")
    }
    
    --arendelle.i

}