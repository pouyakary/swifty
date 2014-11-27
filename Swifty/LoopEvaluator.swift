//
//  LoopEvaluator.swift
//  Swifty
//
//  Created by Pouya Kary on 11/27/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

/// evaluates a loop grammar
func loopEval (#grammarParts:[String], inout #screen: codeScreen, inout #spaces: [String:String], inout #arendelle: Arendelle) -> Void {

    if grammarParts.count == 2 {
        
        let LoopNum:Int? = grammarParts[0].toInt()
        
        // using this line we only get erros of a loop for one time!
        let numberOfErrorsBeforeTheLoopGetsStarted = screen.errors.count
        
        for var i = 0; i < LoopNum && screen.errors.count == numberOfErrorsBeforeTheLoopGetsStarted; i++ {
            
            var loopCode = Arendelle()
            loopCode.code = grammarParts[1]
            
            eval(&loopCode, &screen, &spaces)
        }
        
        // this fixes many problems!
        --arendelle.i
    }
}


