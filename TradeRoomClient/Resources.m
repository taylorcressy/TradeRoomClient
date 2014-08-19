//
//  Resources.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/25/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "Resources.h"
#import "ResourceConsumer.h"

@implementation Resources {
    ResourceConsumer *resourceConsumer;
    
}
@synthesize conditions, tradeOptions;

//Singleton
+ (id)getInstance
{
    static dispatch_once_t onceQueue;
    static Resources *resources = nil;
    
    dispatch_once(&onceQueue, ^{ resources = [[self alloc] init]; });
    return resources;
}


- (id) init {
    self = [super init];
    if(self) {
        self->resourceConsumer = [[ResourceConsumer alloc] init];
    }
    return self;
}

- (void) updateResources {
    [self->resourceConsumer requestConditionsListWithCompletion:^(ServiceMessage *msg) {
        if([msg responseCode] == 800)  { //GET OKAY
            self->conditions = [msg array];
        }
        else {
            NSLog(@"Failed to retrieve resource");
            return;
        }
    }];
    [self->resourceConsumer requestTradeOptionsWithCompletion:^(ServiceMessage *msg) {
        if([msg responseCode] == 800)  { //GET OKAY
            self->tradeOptions = [msg array];
        }
        else {
            NSLog(@"Failed to retrieve resource");
            return;
        }
    }];
}


@end
