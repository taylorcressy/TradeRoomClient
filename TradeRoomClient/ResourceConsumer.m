//
//  ResourceConsumer.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/22/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "ResourceConsumer.h"

@implementation ResourceConsumer {
    
}

-(void) requestConditionsListWithCompletion:(void (^)(ServiceMessage *))complete {
    [self->handler sendGetRequest:CONDITIONS_LIST_REQUEST withParams:nil Completion:^(NSDictionary *responseKeysAndValues) {
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];
}

-(void) requestTradeOptionsWithCompletion:(void (^)(ServiceMessage *))complete {
    [self->handler sendGetRequest:TRADE_OPTIONS_LIST_REQUEST withParams:nil
                       Completion:^(NSDictionary *responseKeysAndValues) {
                           [self respondToCaller:responseKeysAndValues Completion:complete];
                       }];
}

@end
