//
//  LoopEvaluator.swift
//  Swifty
//
//  Created by Pouya Kary on 11/27/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation
import Darwin

/// evaluates a loop grammar
func loopEval (#grammarParts:[String], inout #screen: codeScreen, inout #spaces: [String:NSNumber], inout #arendelle: Arendelle) -> Void {
    
    if grammarParts.count == 2 {

        
        var loopExperssion = mathResult(number: 0, itIsNotCondition: true)
        
        let ifCheckingReg = grammarParts[0] =~ "[0-9]*"
        
        if ifCheckingReg.items.count == 1 && ifCheckingReg.items[0] == grammarParts [0] {
            loopExperssion.result = grammarParts[0].toInt()
            loopExperssion.itsNotACondition = true
        } else {

            loopExperssion  =  mathEval(stringExpression: grammarParts[0], screen: &screen, spaces: &spaces)
        }
            
        if loopExperssion.itsNotACondition == true && loopExperssion.doesItHaveErros == false {
        
            let LoopNum = floor(Double(loopExperssion.result))
            
            // using this line we only get erros of a loop for one time!
            let numberOfErrorsBeforeTheLoopGetsStarted = screen.errors.count
            
            for var i:Double = 0; i < LoopNum && screen.errors.count == numberOfErrorsBeforeTheLoopGetsStarted ; i++ {
                
                var loopCode = Arendelle(code: grammarParts[1])
                
                eval(&loopCode, &screen, &spaces)
            }
        
        } else {
            
            if loopExperssion.doesItHaveErros == false {
                
                let condition = grammarParts[0]
            
                while ( mathEval(stringExpression: condition, screen: &screen, spaces: &spaces).result == 1) {
            
                    var conditionalLoopsCode = Arendelle(code: grammarParts[1])
                    eval(&conditionalLoopsCode, &screen, &spaces)
            
                }
                
            } else {
            
                screen.errors.append("Bad expression: '\(grammarParts[0])'")
            
            }
        }
    
        // this fixes many problems!
        --arendelle.i
    }
}



