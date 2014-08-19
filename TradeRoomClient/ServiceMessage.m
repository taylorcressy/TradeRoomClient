//
//  ServiceMessage.m
//  TradeRoomClient
//
//  Template for encapsulating POST Responses for Application Use
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "ServiceMessage.h"

@implementation ServiceMessage {
    
}

@synthesize responseCode, localizedMessage, dict, rawData;

-(id) init {
    self = [super init];
    
    if(self) {
        return self;
    }
    
    return nil;
}

-(id) initWithCode:(NSInteger) code Message:(NSString*) message Data:(NSDictionary*) d {
    self = [super init];
    
    if(self) {
        self->responseCode = code;
        self->localizedMessage = [NSString stringWithString:message];
        self->dict = [NSDictionary dictionaryWithDictionary:d];
        return self;
    }
    
    return nil;
}

/*
    work arround for returning arrays instead of dictionaries. This is not type safe!!! GET requests will usually come back
    in the form of NSArray, so self->dict will actually point to an NSArray. This should not be the recommended practice!
 */
-(NSArray*) array {
    return (NSArray*) self->dict;
}


@end
