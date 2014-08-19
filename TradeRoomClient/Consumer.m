//
//  Consumer.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/18/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "Consumer.h"

@implementation Consumer {
    
}

-(id) init {
    self = [super init];
    
    if(self) {
        self->handler = [HttpHandler getInstance];
        return self;
    }
    return nil;
}

-(void) respondToCaller:(NSDictionary*) responseKeysAndValues Completion:(void (^)(ServiceMessage*)) complete{
    if(responseKeysAndValues != nil) {
        ServiceMessage *message = [[ServiceMessage alloc] init];
        
        [message setResponseCode:[[responseKeysAndValues valueForKey:SRV_CODE_KEY] intValue]];
        [message setLocalizedMessage:[responseKeysAndValues valueForKey:SRV_MSG_KEY]];
        
        if([responseKeysAndValues valueForKey:SRV_DATA_KEY] != nil)
            [message setDict:[responseKeysAndValues valueForKey:SRV_DATA_KEY]];
        
        if(complete != nil)
            complete(message);
    }
    else if(complete != nil)
        complete(nil);
}


@end
