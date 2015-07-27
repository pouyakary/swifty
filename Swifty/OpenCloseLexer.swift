//
//  OpenCloseLexer.swift
//  Swifty
//
//  Created by Pouya Kary on 11/17/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation


/* ────────────────────────────────────────────────────────────────────────────────────────────────────────────── *
 * :::::::::::::::::::::::::::::::::::::::::: S W I F T Y   L E X E R S ::::::::::::::::::::::::::::::::::::::::: *
 * ────────────────────────────────────────────────────────────────────────────────────────────────────────────── */

func openCloseLexer ( #openCommand: Character , inout #arendelle: Arendelle , inout #screen: codeScreen ) -> [ String ] {
    
    //
    // ─── FUNCTION VARS ──────────────────────────────────────────────────────────────────────────────────
    //

        // • • • • •
    
        ++arendelle.i
    
        // • • • • •
                        
        var command: Character
                        
        var arg: String = ""
    
        var args: [ String ] = [ ]
    
        var whileControl = true
    
        // • • • • •
    
        var openCloseDictionary: [ Character : Character ] = [
        
            "{" : "}" ,
        
            "(" : ")" ,
        
            "[" : "]" ,
            
            "<" : ">" ,
        
            "|" : "|"
            
        ] //end of var openCloseDictionary: [ Character : Character ] = [
    
        // • • • • •
    
        let closeCommand = openCloseDictionary[ openCommand ]!
    
    
    //
    // ─── MAIN LOOP ──────────────────────────────────────────────────────────────────────────────────────
    //
    
    
        while arendelle.whileCondtion( ) && whileControl {
            
            // • • • • •
        
            command = arendelle.readAtI( )
            
            // • • • • •
                            
            switch command {
                
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                
                
                case "," : //= command
            
                    args.append(arg)
            
                    arg=""
            
                
                
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
                
                case "'", "\"" : //= command
                    
                    // • • • • •
                
                    var spaces : [ String : [ NSNumber ] ] = [ "return" : [ 0 ] ]
                    
                    // • • • • •
                    
                    let argPart = onePartOpenCloseParser(
                        
                         openCloseCommand: command      ,
                        
                                   spaces: &spaces      ,
                        
                                arendelle: &arendelle   ,
                        
                                   screen: &screen      ,
                        
                        preprocessorState: true
                    
                    ) //end of let argPart = onePartOpenCloseParser
                    
                    // • • • • •
            
                    arg += "\(command)\(argPart)\(command)"
                    
                    // • • • • •
            
                    --arendelle.i
            
                
                
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                
                
                case "[", "(", "{" : //= command
                    
                    // • • • • •
                    
                    let innerOpenCommand = command
            
                    let innerCloseCommand = openCloseDictionary[ innerOpenCommand ]
                    
                    var result : String = ""
                    
                    // • • • • •
            
                    let newCode = openCloseLexer(
                        
                        openCommand: innerOpenCommand   ,
                        
                          arendelle: &arendelle         ,
                        
                             screen: &screen
                    
                    ) //end of let newCode = openCloseLexer
                    
                    // • • • • •
                    
                    switch newCode.count {
                                    
                        case 1: //= newCode.count
                    
                            result = newCode[ 0 ]
                        
                                    
                        case 2: //= newCode.count
                    
                            result = newCode[ 0 ] + "," + newCode[ 1 ]
                        
                                    
                        case 3: //= newCode.count
                    
                            result = newCode[ 0 ] + "," + newCode[ 1 ] + "," + newCode[ 2 ]
                        
                                    
                        default: //= newCode.count
                    
                            report( "Grammar with more than 3 parts" , &screen )
                
                            return[ "BadGrammar" ]
                        
                                    
                    } //end of switch newCode.count {
                    
                    // • • • • •
                    
                    arg += String( innerOpenCommand ) + result + String( innerCloseCommand! )
                    
                    // • • • • •
            
                    --arendelle.i
            
            
                
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                
                
                case closeCommand : //= command
            
                    args.append( arg )
            
                    whileControl = false
                
                
                
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            
                                
                default : //= command
            
                    arg.append( command )
                
                
                } //end of switch command
            
            
            
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
            
            ++arendelle.i
            
            
        } //end of while arendelle.whileCondtion( ) && whileControl
    
    
    //
    // ─── FINAL ──────────────────────────────────────────────────────────────────────────────────────────
    //
    
        // • • • • •
    
        if args.count == 0 {
            
            args.append( "BadGrammar" )
    
        } //end of if args.count == 0
    
        // • • • • •
                        
        if whileControl == true {
            
            report ( "Unfinished grammar found" , &screen )
    
        } //end of if whileControl == true
    
        // • • • • •
    
        return args
    
    
    // ────────────────────────────────────────────────────────────────────────────────────────────────────
    
}