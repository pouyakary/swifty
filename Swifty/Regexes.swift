//
//  Regexes.swift
//  Swifty
//
//  Created by Pouya Kary on 4/7/15.
//  Copyright (c) 2015 Arendelle Language. All rights reserved.
//

import Foundation

let SPACE_NAME_REGEX = "[a-zA-Z0-9\\._]"
let SPACE_AND_STORED_SPACE_REGEX = "(([a-zA-Z0-9_]+)|(\\$[a-zA-Z0-9_\\.]+)) *(\\[.*\\])?"