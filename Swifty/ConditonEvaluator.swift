//
//  ConditonEvaluator.swift
//  Swifty
//
//  Created by Pouya Kary on 11/29/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

func conditionEval (#grammarParts:[String], inout #screen: codeScreen, inout #spaces: [String:NSNumber], inout #arendelle: Arendelle) -> Void {

    if grammarParts.count == 2 {
    
        let condtionResult =  mathEval(stringExpression: grammarParts[0], screen: &screen, spaces: &spaces)
        
        if ( condtionResult.result != 0 || condtionResult.itsNotACondition == true ) && condtionResult.doesItHaveErros == true {
        
            var conditonCode = Arendelle(code: grammarParts[1])
            eval(&conditonCode, &screen, &spaces)
        
        }
        
    } else if grammarParts.count == 3 {
        
        let condtionResult =  mathEval(stringExpression: grammarParts[0], screen: &screen, spaces: &spaces)
        
        if (condtionResult.result != 0 || condtionResult.itsNotACondition == true )  && condtionResult.doesItHaveErros == true {
            
            var conditonCode = Arendelle(code: grammarParts[1])
            eval(&conditonCode, &screen, &spaces)
            
        } else {
        
            if condtionResult.doesItHaveErros == true {
                var conditonCode = Arendelle(code: grammarParts[2])
                eval(&conditonCode, &screen, &spaces)
            } else {
            
                screen.errors.append("Bad loop expression: '\(grammarParts[0])'")
                
            }
        }
    
    
    } else {
        
        screen.errors.append("Loop grammar with \(grammarParts.count) part\(PIEndS(number: grammarParts.count)) found")
    
    }
    
    arendelle.i--
}