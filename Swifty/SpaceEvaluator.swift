//
//  SpaceEvaluator.swift
//  Swifty
//
//  Created by Pouya Kary on 12/15/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

/// Reads a NSNumber from an Arendelle Stored Space
func storedSpaceLoader (#spaceName: String, inout #screen: codeScreen) -> NSNumber {

    let spaceURL = arendellePathToNSURL(arendellePath: spaceName.replace("$", withString: ""), kind: "space", screen: &screen)

    let spaceValue = String(contentsOfURL: spaceURL, encoding: NSUTF8StringEncoding, error: nil)?.replace("\n", withString: "")
    
    if spaceValue != nil {
        
        return Int(NSInteger(NSString(string: spaceValue!).integerValue))
        
    } else {
        screen.errors.append("No stored space as '\(spaceName)' found")
        return 0
    }
}


/// Checks if a stored space exists
func checkIfStoredSpaceExists (#spaceName: String, inout #screen: codeScreen) -> Bool {

    let spaceURL = arendellePathToNSURL(arendellePath: spaceName.replace("$", withString: ""), kind: "space", screen: &screen)
    return checkIfURLExists(spaceURL)
}


/// Evaluates a space grammar
func spaceEval (#grammarParts: [String], inout #screen: codeScreen, inout #spaces: [String:NSNumber], inout #arendelle: Arendelle) -> String {
    
    var spaceResult = "";
    
    func spaceRegexNameError (#text: String) {
        screen.errors.append("Unaccepted space name : '\(grammarParts[0])'")
    }
    
    func saveNumberToStoredSpace (#number: NSNumber, toSpace space: String) {
        
        let spaceURL = arendellePathToNSURL(arendellePath: space, kind: "space", screen: &screen)
        
        let er = "\(number)".replace("\n", withString: "").writeToURL(spaceURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        
        if !er {
            screen.errors.append("Storing space '\(space)' failed")
        }
    }
    
    let regexMathes = grammarParts[0] =~ "([a-zA-Z0-9]+)|(\\$[a-zA-Z0-9\\.]+)"
    
    if grammarParts.count == 1 {
    
        //
        // UNTITLED INPUT
        //
        
        if regexMathes.items.count == 1 && regexMathes.items[0] == grammarParts[0] {
            
            // stored space
            
            if grammarParts[0].hasPrefix("$") {
            
                let spaceValue = spaceInput(text: "Sign space '\(grammarParts[0])' with a number:")
 
                saveNumberToStoredSpace(number: spaceValue, toSpace: grammarParts[0].replace("$", withString: ""))
            
            // simple space
                
            } else {
            
                let spaceValue = spaceInput(text: "Sign space '@\(grammarParts[0])' with a number:")
                spaces["@\(grammarParts[0])"] = spaceValue
                
            }
        
        } else {
            spaceRegexNameError(text: grammarParts[0])
        }
        
        //
        // END OF UNTITLED INPUT
        //
        
    } else if grammarParts.count == 2 {

        if regexMathes.items.count == 1 && regexMathes.items[0] == grammarParts[0] {
            
            
            //
            // INPUT
            //
            
            if grammarParts[1].hasPrefix("\"") && grammarParts[1].hasSuffix("\"") {
                
                var spaceInputArendelleFortmat = Arendelle(code: grammarParts[1])
                let spaceInputText = onePartOpenCloseParser(openCloseCommand: "\"", arendelle: &spaceInputArendelleFortmat, screen: &screen)
                var spaceValue = spaceInput(text: spaceInputText)
                
                // if it's stored space
                
                if grammarParts[0].hasPrefix("$") {
                    
                    saveNumberToStoredSpace(number: spaceValue, toSpace: grammarParts[0].replace("$", withString: ""))
                
                // simple space
                    
                } else {
                    
                    if spaces["@\(grammarParts[0])"] == nil {
                        spaceResult = "@\(grammarParts[0])"
                    }
                
                    spaces["@\(grammarParts[0])"] = spaceValue
                    
                }
                
                
            //
            // SHORTCUTS
            //
                
            } else if grammarParts[1].hasPrefix("+") || grammarParts[1].hasPrefix("-") || grammarParts[1].hasPrefix("/") || grammarParts[1].hasPrefix("*")    {
                
                
                //
                // SIMPLE SPACE
                //
                
                if spaces["@\(grammarParts[0])"] != nil && !grammarParts[0].hasPrefix("$") {
                    
                    let result = mathEval(stringExpression: "@\(grammarParts[0]) \(grammarParts[1])", screen: &screen, spaces: &spaces)

                    if result.doesItHaveErros == false && result.itsNotACondition == true {
                    
                        spaces["@\(grammarParts[0])"] = result.result
                    
                    } else {
                        if result.itsNotACondition == false {
                            screen.errors.append("Unaccepted using of conditions in space value: '\(grammarParts[1])'")
                        } else {
                            screen.errors.append("Bad expression: '\(grammarParts[1])'")
                        }
                    }
                   
                    
                //
                // STORED SPACE
                //
                    
                } else if grammarParts[0].hasPrefix("$") {
                    
                    if checkIfStoredSpaceExists(spaceName: grammarParts[0], screen: &screen) {
                    
                        let result = mathEval(stringExpression: "\(grammarParts[0]) \(grammarParts[1])", screen: &screen, spaces: &spaces)
           
                        if !result.doesItHaveErros && result.itsNotACondition {
 
                            saveNumberToStoredSpace(number: result.result, toSpace: grammarParts[0].replace("$", withString: ""))
                        
                        } else {
                            
                            if result.itsNotACondition == false {
                                screen.errors.append("Unaccepted using of conditions in space value: '\(grammarParts[1])'")
                            } else {
                                screen.errors.append("Bad expression: '\(grammarParts[1])'")
                            }
                        }
                    
                    } else {
                        screen.errors.append("No stored space as '@\(grammarParts[0])' found")
                    }
                
                } else {
                    screen.errors.append("No space as '@\(grammarParts[0])' found")
                }
            
                
            } else if grammarParts[1] == "done" {
                
                if grammarParts[0].hasPrefix("$") {
                
                    if checkIfStoredSpaceExists(spaceName: grammarParts[0], screen: &screen) {
                    
                        let spaceURL = arendellePathToNSURL(arendellePath: grammarParts[0].replace("$", withString: ""), kind: "space", screen: &screen)
                        
                        removeFileWithURL(spaceURL)
                        
                    } else {
                        screen.errors.append("No stored space as \(grammarParts[0]) found to be deleted")
                    }
                
                } else {
                
                    if spaces[grammarParts[0]] != nil {
                        
                        spaces.removeValueForKey("@\(grammarParts[0])")
                        
                    } else {
                        screen.errors.append("No space as @\(grammarParts[0]) found to be deleted")
                    }
                }
            
            
            //
            // STANDARD INIT OF SPACE
            //
                
            } else {
                
                let spaceValue = mathEval(stringExpression: grammarParts[1], screen: &screen, spaces: &spaces)
                
                if spaceValue.doesItHaveErros == false {
                    
                    if spaceValue.itsNotACondition == true {
                        
                        
                        //
                        // INIT OF SPACE WITH 2 PARTS
                        //
                        
                            // if it's stored space
                        
                            if grammarParts[0].hasPrefix("$") {
                            
                                saveNumberToStoredSpace(number: spaceValue.result, toSpace: grammarParts[0].replace("$", withString: ""))
                            
                            // simple space
                                
                            } else {
                                
                                spaces["@\(grammarParts[0])"] = spaceValue.result
                                spaceResult = "@\(grammarParts[0])"
                                
                            }
                        
                        //
                        // END OF SPACE WITH 2 PARTS
                        //
                        
                        
                    } else {
                        screen.errors.append("Unaccepted using of conditions in space value: '\(grammarParts[1])'")
                    }
                    
                } else {
                    screen.errors.append("Bad expression: '\(grammarParts[1])'")
                }
            }
        
        } else {
            spaceRegexNameError(text: grammarParts[0])
        }
    
    } else {
        screen.errors.append("Space grammar found with more than 2 parts")
    }
    
    --arendelle.i
    return spaceResult
}

// done

