//
//  FunctionLexer.swift
//  Swifty
//
//  Created by Pouya Kary on 12/28/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation


/* ────────────────────────────────────────────────────────────────────────────────────────────────────────────── *
 * :::::::::::::::::::::::::::::::::::::::::: S W I F T Y   L E X E R S ::::::::::::::::::::::::::::::::::::::::: *
 * ────────────────────────────────────────────────────────────────────────────────────────────────────────────── */

struct FuncParts {
    
    // • • • • •
    
    var name: String
    
    var inputs: [ String ]
    
    var index: String
    
    // • • • • •
    
    init ( ) {
        
        self.name = "BadGrammar"
        
        self.inputs = [ ]
        
        self.index = "0"
        
    } //end of init ()
    
} //end of struct FuncParts


func functionLexer ( inout #arendelle: Arendelle , inout #screen: codeScreen ) -> FuncParts {
    
    
    //
    // ─── FUNCTION VARS ──────────────────────────────────────────────────────────────────────────────────
    //

        var name: String
    
        var inputs: [ String ]
    
        var input: String
    
        var result = FuncParts( )
    
        var whileControl = true
    
        var charToRead: Character
    
        var part = ""
    
        arendelle.i++
    
    
    //
    // ─── PART ONE ───────────────────────────────────────────────────────────────────────────────────────
    //

        // ┌───┤
        // │ N ⎪ Reading the functions
        // │ O ⎪ Part 1
        // │ T ⎪
        // │ E ⎪    ! FUNC (120, 23, 34) [12]
        // └───┤    --^^^^------------------------> 'FUNC' : String
        //     ⎪
        //     ⎪ Function Name
        //     ⎪

    
        while whileControl && arendelle.whileCondtion( ) {
            
            // • • • • •
    
            charToRead = arendelle.readAtI( )
            
            // • • • • •
        
            if charToRead == "(" {
                
                // • • • • •
            
                if part =~ "[a-zA-Z0-9\\.]+" {
        
                    result.name = part
                    
                    whileControl = false
                    
                // • • • • •
                
                } else { //of if part =~ "[a-zA-Z0-9\\.]+"
                    
                    report( "Bad function name found: \( part )" , &screen )
                    
                    return result
                    
                } //end of if part =~ "[a-zA-Z0-9\\.]+"
                
            // • • • • •
            
            } else { //of if charToRead == "("
                
                // • • • • •
        
                part.append( charToRead )
                
                arendelle.i++
                
                // • • • • •
            
                if arendelle.i == arendelle.code.utf16Count {
                    
                    report( "Function name without parenthesis found" , &screen )
                    
                    return result
                    
                } //end of if arendelle.i == arendelle.code.utf16Count
                
                
            } //end of if charToRead == "("
            
            
        } //end of while whileControl && arendelle.whileCondtion( )
    
    
    
    //
    // ─── PART TWO ───────────────────────────────────────────────────────────────────────────────────────
    //
    
        // ┌───┤
        // │ N ⎪ Reading the functions
        // │ O ⎪ Part 2
        // │ T ⎪
        // │ E ⎪    ! FUNC (120, 23, 34) [12]
        // └───┤    --------^^^--^^--^^-----------> [120, 23, 34] : Array -> NSNumber
        //     ⎪
        //     ⎪ Function Args
        //     ⎪

    
        if arendelle.i < arendelle.codeSize() - 1 {
            
            // • • • • •
    
            let numberOfErrorBefore = screen.errors.count
            
            let inputParts = openCloseLexer(
                
                openCommand: "("        ,
                
                  arendelle: &arendelle ,
                
                     screen: &screen
            
            ) //end of let inputParts
            
            // • • • • •
        
            if screen.errors.count == numberOfErrorBefore {
        
                result.inputs = inputParts
            
            } else { //of if screen.errors.count == numberOfErrorBefore
                
                report( "Broken function parenthesis found" , &screen )
                
                return result
                
            } //end of if screen.errors.count == numberOfErrorBefore
            
            
        } //end of if arendelle.i < arendelle.codeSize() - 1
    
    
    
    //
    // ─── PART THREE ─────────────────────────────────────────────────────────────────────────────────────
    //

        // ┌───┤
        // │ N ⎪ Reading the functions
        // │ O ⎪ Part 3
        // │ T ⎪
        // │ E ⎪    ! FUNC (120, 23, 34) [12]
        // └───┤    ----------------------^^------> 12 : Int
        //     ⎪
        //     ⎪ Function Result Index
        //     ⎪
    
    
        if arendelle.whileCondtion() {
            
            // • • • • •
    
            charToRead = arendelle.readAtI( )
            
            // • • • • •
        
            if charToRead == "[" {
                
                // • • • • •
            
                let numberOfErrorBefore = screen.errors.count
                
                let indexParts = openCloseLexer(
                    
                    openCommand: "["        ,
                    
                    arendelle: &arendelle   ,
                    
                    screen: &screen
                
                ) //end of let indexParts
                
                // • • • • •
            
                if screen.errors.count == numberOfErrorBefore && indexParts.count == 1 {
                
                    result.index = indexParts[ 0 ]
                    
                    return result
                
                } else { //of if screen.errors.count == numberOfErrorBefore && indexParts.count == 1
                    
                    if indexParts.count != 1 {
                        
                        report( "Function index with more or less than one part found." , &screen )
                        
                        return result
                        
                    } else { //of if indexParts.count != 1
                        
                        report( "Broken function parenthesis found" , &screen )
                        
                        return result
                        
                    } //end of if indexParts.count != 1
                    
                } //end of if screen.errors.count == numberOfErrorBefore && indexParts.count == 1
                
            } //end of if charToRead == "["
            
        } //end of if arendelle.whileCondtion()
    
    
    // ────────────────────────────────────────────────────────────────────────────────────────────────────

    
        return result
    
    
    // ────────────────────────────────────────────────────────────────────────────────────────────────────
    
} //end of func functionLexer



