//
//  Replacer.swift
//  Swifty
//
//  Created by Pouya Kary on 11/30/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

func spaceReplacer (#expressionString: String, #spaces: [String:NSNumber], inout #screen: codeScreen) -> String {

    var result = expressionString
    
    for match in result =~ "@([A-Z]|[a-z]|[0-9])+" {
        
        if spaces[match] != nil {
            
            result = result.replace(match, withString: "\(spaces[match]!)")
            
        } else {
            
            screen.errors.append("Space '\(match)' not found.")
            
        }
    }
    
    return result
}

func replacer (#expressionString: String, #spaces: [String:NSNumber], inout #screen: codeScreen) -> String {
    
    var result = expressionString
    

    //
    // SPACE REPLACER
    //
    
    result = spaceReplacer(expressionString: result, spaces: spaces, screen: &screen)
    
    
    //
    // SOURCE REPLACER
    //
    
    
    for match in result =~ "#[a-z]+" {
    
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
        
    }
    
    return result

}