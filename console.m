//
//  commandLinetools.m
//  Swifty
//
//  Created by Pouya Kary on 11/26/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdlib.h>

NSString* readLine() {
    
    NSMutableData *data = [NSMutableData data];
    
    do {
        char c = getchar();
        if ([[NSCharacterSet newlineCharacterSet] characterIsMember:(unichar)c]) { break; }
        [data appendBytes:&c length:sizeof(char)];
        
    } while (true);
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

void clean () { system("clear"); }
