//
//  SearchConsumer.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "Consumer.h"

@interface SearchConsumer : Consumer {
    
}

/*
    Search for a user %LIKE% the given query
 */
- (void) searchForUser:(NSString*) query
            Completion:(void (^)(ServiceMessage *))complete;


/*
    Search for an item with a textindexed insearch.
    Weights the search criteria with the following importance:
        1: Title
        2: Tags
        3: Description
 */
- (void) searchForItem:(NSString*) query
            Completion:(void (^)(ServiceMessage *))complete;

@end
