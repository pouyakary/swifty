//
//  MathEvaluator.swift
//  Swifty
//
//  Created by Pouya Kary on 11/28/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

func mathEval (#stringExpression: String, inout #screen: codeScreen) -> String {
    
    var mathExpression = sourceReplacer(screen: &screen, expression: stringExpression)
    
    println("source replacer worked and returned : '\(mathExpression)'")
    
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

    
    // returns the result:
    
    if itsNotCondition {
        return "\(result)"
    } else {
        if result == 0 { return "f" } else { return "t" }
    }
}