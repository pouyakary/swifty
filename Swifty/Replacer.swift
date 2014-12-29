//
//  Replacer.swift
//  Swifty
//
//  Created by Pouya Kary on 11/30/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

/// The mini replacer used for the strings
func spaceReplacer (#expressionString: String, #spaces: [String:NSNumber], inout #screen: codeScreen) -> String {

    var result = expressionString
    
    for match in result =~ "@[a-zA-Z0-9]+" {
        
        if spaces[match] != nil {
            result = result.replace(match, withString: "\(spaces[match]!)")
        } else {
            screen.errors.append("Space '\(match)' not found")
        }
    }
    
    return result
}


/// Arendelle Replacer that replaces Spaces / Stored Spaces / Sources / Functions
func replacer (#expressionString: String, inout #spaces: [String:NSNumber], inout #screen: codeScreen) -> String {

    var result = expressionString
    
    for match in result =~ "((#|@)[a-zA-Z0-9]+)|(\\$[a-zA-Z0-9\\.]+)|(\\![a-zA-Z0-9\\.]+ *\\(.*\\))" {

        
        //
        // SOURCE REPLACER
        //
        
        if match.hasPrefix("#") {
        
            switch match {
                
            case "#i" , "#width" :
                result = result.replace(match, withString: "\(screen.screen.colCount())")
                
            case "#j" , "#height" :
                result = result.replace(match, withString: "\(screen.screen.rowCount())")
                
            case "#x" :
                result = result.replace("#x", withString: "\(screen.x)")
                
            case "#y" :
                result = result.replace("#y", withString: "\(screen.y)")
                
            case "#n" :
                result = result.replace("#n", withString: "\(screen.n)")
                
            case "#pi" :
                result = result.replace("#pi", withString: "3.141592653589")
                
            case "#rnd" :
                result = result.replace("#rnd", withString: arendelleRandom())
                
            default:
                screen.errors.append("No source as '\(match)' exists")
            }
        
            
        //
        // SPACE REPLACER
        //
            
        } else if match.hasPrefix("@") {
        
            if spaces[match] != nil {
                
                result = result.replace(match, withString: "\(spaces[match]!)")
                
            } else {
                screen.errors.append("Space '\(match)' not found")
            }
            
            
        //
        // STORED SPACE REPLACER
        //
        
        } else if match.hasPrefix("$") {
            
            result = result.replace(match, withString: "\(storedSpaceLoader(spaceName: match, screen: &screen))")
        
        
        
        //
        // FUNCTIONS
        //
        
        } else if match.hasPrefix("!") {
            
            var funcArendelle = Arendelle(code: match)
            let grammarParts = funcLexer(arendelle: &funcArendelle, screen: &screen)
            result = result.replace(match, withString: "\(funcEval(grammarParts: grammarParts, screen: &screen, spaces: &spaces))")
    
        }
    }

    return result
}
