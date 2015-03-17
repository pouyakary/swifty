//
//  commandLinetools.m
//  Swifty
//
//  Created by Pouya Kary on 11/26/14.
//  Copyright (c) 2014 Arendelle Language. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdlib.h>
//#include <editline/readline.h>

/* ----------------------------------------- *
 * :::::::::: P I   C O N S O L E :::::::::: *
 * ----------------------------------------- */

NSString* PiConsoleReadLine() {

    
    NSMutableData *data = [NSMutableData data];

    do {
        char c = getchar();
        if ([[NSCharacterSet newlineCharacterSet] characterIsMember:(unichar)c]) { break; }
        [data appendBytes:&c length:sizeof(char)];
        
    } while (true);
     
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

void PiConsoleClean   () { system("clear"); }
void PiConsoleReset   () { printf("\033[0m"); }
void PiConsoleBold    () { printf("\033[1m"); }
void PiConsoleRed     () { printf("\x1B[31m"); }
void PiConsoleGreen   () { printf("\x1B[32m"); }
void PiConsoleYellow  () { printf("\x1B[33m"); }
void PiConsoleBlue    () { printf("\x1B[34m"); }
void PiConsoleMagenta () { printf("\x1B[35m"); }
void PiConsoleCayan   () { printf("\x1B[36m"); }
void PiConsoleWhite   () { printf("\x1B[37m"); }




