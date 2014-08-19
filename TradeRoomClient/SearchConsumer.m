//
//  SearchConsumer.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "SearchConsumer.h"

@implementation SearchConsumer {
    
}


- (void) searchForUser:(NSString*) query
            Completion:(void (^)(ServiceMessage *))complete {

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:SEARCH_QUERY_KEY];

    [self->handler sendPostRequest:SEARCH_FOR_USER
                        withParams:params
                        Completion:^(NSDictionary *responseKeysAndValues) {
                            [self respondToCaller:responseKeysAndValues Completion:complete];
                        }];
}



- (void) searchForItem:(NSString*) query
            Completion:(void (^)(ServiceMessage *))complete {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:SEARCH_QUERY_KEY];
    
    [self->handler sendPostRequest:SEARCH_FOR_ITEM
                        withParams:params
                        Completion:^(NSDictionary *responseKeysAndValues) {
                            [self respondToCaller:responseKeysAndValues Completion:complete];
                        }];

}

@end
