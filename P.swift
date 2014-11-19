//
//  P.swift
//  P FRAMEWORK: A SET OF TOOLS SWIFT NEEDS
//
//  Created by Pouya Kary on 11/17/14.
//  Copyright (c) 2014 Pouya Kary and other contribiuters. All rights reserved.
//

import Foundation


// The following code is from the public domain code for the
// post blog of the Trolieb LLC : 
// http://blog.trolieb.com/trouble-multidimensional-arrays-swift/


/// 2D Matrix-Like Array for Swift
class P2DArray {
    var cols:Int, rows:Int
    var matrix:[Int]
    
    /// Array init
    init(cols:Int, rows:Int) {
        self.cols = cols
        self.rows = rows
        matrix = Array(count:cols*rows, repeatedValue:0)
    }
    
    subscript(col:Int, row:Int) -> Int {
        get {
            return matrix[cols * row + col]
        }
        set {
            matrix[cols*row+col] = newValue
        }
    }
    
    /// Returns the number the array columns
    func colCount() -> Int {
        return self.cols
    }
    
    /// Returns the number the array rows
    func rowCount() -> Int {
        return self.rows
    }
}



extension Character
{
    func toString () -> String {
    
        var text:String = ""
        text.append(self)
        return text
    
    }
}

extension String
{
    func characterAtIndex(index:Int) -> unichar
    {
        return self.utf16[index]
    }
    
    // Allows us to use String[index] notation
    subscript(index:Int) -> unichar
        {
            return characterAtIndex(index)
    }
}
