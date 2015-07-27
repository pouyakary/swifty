//
//  OnePartOpenCloseParser.swift
//  Swifty
//
//  Created by Pouya Kary on 11/23/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation


/* ────────────────────────────────────────────────────────────────────────────────────────────────────────────── *
 * :::::::::::::::::::::::::::::::::::::::::: S W I F T Y   L E X E R S ::::::::::::::::::::::::::::::::::::::::: *
 * ────────────────────────────────────────────────────────────────────────────────────────────────────────────── */

func onePartOpenCloseParser ( #openCloseCommand: Character , inout #spaces: [ String : [ NSNumber ]] , inout #arendelle: Arendelle , inout #screen: codeScreen , #preprocessorState: Bool ) -> String {
    
    //
    // ─── VARS ───────────────────────────────────────────────────────────────────────────────────────────
    //
    
        // • • • • •
    
        ++arendelle.i // going to the right char
    
        // • • • • •
    
        var result: String = "" // our result
    
        // • • • • •
    
        var replace: Bool = false // value replacing controller
    
        // • • • • •
    
        var charToRead: Character // corrent char
    
    
    
    //
    // ─── BODY ───────────────────────────────────────────────────────────────────────────────────────────
    //

        while arendelle.whileCondtion() {
            
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
                // • • • • •
            
                charToRead = arendelle.readAtI() // corrent char
            
                // • • • • •
        
                switch charToRead {
        
                    case openCloseCommand :
                        
                        arendelle.i++
            
                        return result
                    
            
                    case "|" : //= charToRead
                        
                        // • • • • •
                        
                        var replacerParts = openCloseLexer(
                            
                            
                            openCommand: "|"        ,
                            
                              arendelle: &arendelle ,
                            
                                 screen: &screen
                            
                            
                        ) //end of var replacerParts = openCloseLexer
                        
                        
                        // • • • • •
                        
                        var replacerOnePart = ""
                        
                        // • • • • •
                        
                        for part in replacerParts {
                            
                            
                            replacerOnePart += part
                            
                        
                        } //end of for part in replacerParts
                        
                        // • • • • •
            
                        if preprocessorState == true {
                            
                            // • • • • •
                            
                            result += "|\( replacerOnePart )|"
                            
                            // • • • • •
                
                            if arendelle.i >= arendelle.codeSize( ) {
                                
                                
                                report( "Unfinished string interpolation | ... | found" , &screen )
                                
                                
                            } //of if arendelle.i >= arendelle.codeSize()
                            
                
                        } else { //of if preprocessorState == true
                            
                            // • • • • •
                            
                            if replacerOnePart != "" {
                    
                                result += mathEval(
                                    
                                    stringExpression: replacerOnePart   ,
                                    
                                              screen: &screen           ,
                                    
                                              spaces: &spaces
                                    
                                ).result.stringValue
                                
                            // • • • • •
                    
                            } else { //of if replacerOnePart != ""
                                
                                
                                // • • • • •
                                
                                var errtext = ""
                                
                                // • • • • •
                    
                                if result.utf16Count <= 10 {
                                    
                                    errtext = result
                                    
                                } //end of if result.utf16Count <= 10
                                
                                // • • • • •
                    
                                screen.errors.append( "Empty string interpolation found: \"\( result )| ... |" )
                                
                                
                            } //end of if replacerOnePart != ""
                            
                            
                        } //end of if preprocessorState == true
                        
                        
                        // • • • • •
                        
                        --arendelle.i
                    
                
            
                    case "\\" : //= charToRead
                        
                        // • • • • •
            
                        if arendelle.whileCondtion( ) {
                            
                            // • • • • •
            
                            arendelle.i++
                            
                            charToRead = arendelle.readAtI( )
                            
                            // • • • • •
                
                            switch charToRead {
                    
                                case "n" : //= charToRead
                                    
                                    result += "\n"
                    
                                
                                case "t" : //= charToRead
                                    
                                    result += "   " // 1 tab in Arendelle == 3 white spaces;
                    
                                
                                case "\"" : //= charToRead
                                    
                                    result += "\""
                                
                    
                                case "'" : //= charToRead
                                    
                                    result += "'"
                                
                    
                                case "\\" : //= charToRead
                                    
                                    result += "\\"
                                
                    
                                case "|" : //= charToRead
                                    
                                    result += "|"
                                
                    
                                default : //= charToRead
                                    
                                    report( "Bad escape sequence: '\\\( charToRead )'", &screen )
                                
                                
                                } //end of charToRead
            
                            
                        } else { //= arendelle.whileCondtion( )
            
                            
                            report( "Unfinished \( openCloseCommand )...\( openCloseCommand ) grammar found" , &screen )
                            
                            return "BadGrammar"
                            
            
                        } //end of if arendelle.whileCondtion( )
                    
            
                    default: //= charToRead
                        
                        
                        result.append( charToRead )
                    
        
                } //end of switch charToRead
            
                // • • • • •
            
                arendelle.i++
            
            
                // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
            }
    
    // ────────────────────────────────────────────────────────────────────────────────────────────────────


        report( "Unfinished \( openCloseCommand )...\( openCloseCommand ) grammar found" , &screen )
    
        return "BadGrammar"
    
    
    // ────────────────────────────────────────────────────────────────────────────────────────────────────

    
} //end of func onePartOpenCloseParser



