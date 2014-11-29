//
//  MathEvaluator.swift
//  Swifty
//
//  Created by Pouya Kary on 11/28/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

struct mathResult {
    
    var result : NSNumber = 0
    var itsNotACondition : Bool = true
    
    init (number:NSNumber, isItCondition:Bool) {
        
        self.result = number
        self.itsNotACondition = isItCondition
        
    }
    
}

func mathEval (#stringExpression: String, inout #screen: codeScreen) -> mathResult {
    
    if stringExpression.toInt() != nil { return mathResult(number: Double(stringExpression.toInt()!), isItCondition: true) }
    
    var mathExpression = sourceReplacer(screen: &screen, expression: stringExpression)
   
    // checks to see if it's a condition we're running
    var itsNotCondition = true
    for var i=0; i < mathExpression.utf16Count && itsNotCondition; i++ {
        let char:Character = mathExpression[i]
        if char == ">" || char == "<" || char == "=" { itsNotCondition = false }
    }

    // evaluates the expression
    var eval = DDMathEvaluator()
    var errors:NSError?
    var tokenizer = DDMathStringTokenizer(string: mathExpression, operatorSet:nil, error: &errors)
    var parser:DDParser = DDParser(tokenizer: tokenizer, error: &errors)
    var experssion:DDExpression! = parser.parsedExpressionWithError(&errors)
    var rewritten:DDExpression = DDExpressionRewriter.defaultRewriter().expressionByRewritingExpression(experssion, withEvaluator: eval)
    let result = eval.evaluateExpression(experssion, withSubstitutions: nil, error: &errors)
    
    // returning point
    return mathResult (number: result, isItCondition: itsNotCondition)
}



