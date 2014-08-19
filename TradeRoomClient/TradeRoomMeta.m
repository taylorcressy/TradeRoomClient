//
//  TradeRoomMeta.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "TradeRoomMeta.h"

@implementation TradeRoomMeta {
    
}

- (id) init {
    self = [super init];
    if(self) {
        return self;
    }
    return nil;
}

- (void) updateTradeRoomMetaWithDict:(NSDictionary *)dict {    
    self->_itemCount = [[dict objectForKey:NUMBER_OF_ITEMS] integerValue];
    self->_maxItemCount = [[dict objectForKey:MAX_NUMBER_OF_ITEMS] integerValue];
    self->_maxItemImageCount = [[dict objectForKey:MAX_NUMBER_OF_IMAGES] integerValue];
    self->_numberOfSuccessfulTrades = [[dict objectForKey:NUMBER_OF_SUCCESSFUL_TRADES_KEY] integerValue];
    
    self->_itemIds = [dict objectForKey:ITEM_ARRAY_IDS];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"\n\t\tItem Count: %d;\n\t\tMax Item Count: %d;\n\t\tMax Item Image Count: %d;\n\t\tNumber Of Successful Trade: %d;\n\t\tItem IDs: %@", self->_itemCount, self->_maxItemCount, self->_itemCount, self->_numberOfSuccessfulTrades, [self->_itemIds description]];
}

@end
