//
//  ClientPropertiesAndMessages.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "ClientPropertiesAndMessages.h"

@implementation ClientPropertiesAndMessages {
    
}

@synthesize serverCodesAndMessages;

/*
 Singleton and Constructor
 */
+(id) getInstance {
    static ClientPropertiesAndMessages *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

-(id) init {
    self = [super init];
    
    if(self) {
        [self populateServerCodesAndMessage];
        return self;
    }
    return nil;
}

/*
    Populate Server Codes and Messages Dictionary
 */
-(void) populateServerCodesAndMessage {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"servererrors" ofType:@"csv"];
    NSError *error;
    
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if(error) {
        NSLog(@"Error Reading From servererror.csv: %@", [error localizedDescription]);
        return;
    }
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    NSArray *contentsByLine = [fileContents componentsSeparatedByString:@"\n"];
    
    NSArray *separatedBuff;
    for(NSString *line in contentsByLine) {
        separatedBuff = [line componentsSeparatedByString:@","];
        [tempDict setObject:[[separatedBuff objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                     forKey:[[separatedBuff objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    
    self->serverCodesAndMessages = [NSDictionary dictionaryWithDictionary:tempDict];
}

@end
