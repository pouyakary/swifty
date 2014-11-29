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
func loopEval (#grammarParts:[String], inout #screen: codeScreen, inout #spaces: [String:String], inout #arendelle: Arendelle) -> Void {

    if grammarParts.count == 2 {
        
        var loopExperssion =  mathEval(stringExpression: grammarParts[0], screen: &screen)
            
        if loopExperssion.itsNotACondition == true {
        
            let LoopNum = floor(Double(loopExperssion.result))
            
            // using this line we only get erros of a loop for one time!
            let numberOfErrorsBeforeTheLoopGetsStarted = screen.errors.count
            
            for var i:Double = 0; i < LoopNum && screen.errors.count == numberOfErrorsBeforeTheLoopGetsStarted ; i++ {
                
                var loopCode = Arendelle(code: grammarParts[1])
                
                eval(&loopCode, &screen, &spaces)
            }
        
        } else {
            
            let condition = grammarParts[0]
            
            while ( mathEval(stringExpression: condition, screen: &screen).result == 1) {
            
                var conditionalLoopsCode = Arendelle(code: grammarParts[1])
                eval(&conditionalLoopsCode, &screen, &spaces)
            
            }
        
        }
    
        // this fixes many problems!
        --arendelle.i
    }
}



