//
//  OpenCloseLexer.swift
//  Swifty
//
//  Created by Pouya Kary on 11/17/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

import Foundation

func openCloseLexer ( #openCommand: Character,
                  inout #arendelle: Arendelle,
                     inout #screen: codeScreen) -> [String] {
    
                        
    var command:Character
    ++arendelle.i
                        
    var arg:String = ""
    var args:[String] = []
    var whileControl = true
    let openCommand:Character = "["
    var openCloseDictionary:[Character:Character] = [ "{":"}", "(":")", "[":"]", "<":">" ]
    let closeCommand = openCloseDictionary[openCommand]
                        
                        
    while arendelle.i < arendelle.code.utf16Count && whileControl {
                            
        command = Array(arendelle.code)[arendelle.i]
                            
        switch command {
                                
        case "," :
            args.append(arg)
            arg=""
            
        case " " :
            break
            
        case "[", "(", "<", "{" :
                                
            let innerOpenCommand = command
            let innerCloseCommand = openCloseDictionary[innerOpenCommand]
            let newCode = openCloseLexer(openCommand: innerOpenCommand, arendelle: &arendelle, screen: &screen)
            var result:String = ""
                                
            switch newCode.count {
                                    
            case 1:
                result = newCode[0]
                                    
            case 2:
                result = newCode[0] + "," + newCode[1]
                                    
            case 3:
                result = newCode[0] + "," + newCode[1] + "," + newCode[2]
                                    
            default:
                return["BadGrammar"]
                                    
            }
                                
            arg += String(innerOpenCommand) + result + String(innerCloseCommand!)
            --arendelle.i
                                
        case "]" :
            args.append(arg)
            whileControl = false
                                
        default:
            arg.append(command)
                                
        }
        arendelle.i++
                            
    }
                        
return args

}