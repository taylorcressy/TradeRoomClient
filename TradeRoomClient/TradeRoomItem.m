//
//  TradeRoomItem.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "TradeRoomItem.h"

@implementation TradeRoomItem
{
    
}
+ (TradeRoomItem*) dictionyToItem:(NSDictionary *)itemDict
{
    TradeRoomItem* item = [[TradeRoomItem alloc] init];
    item.itemId = [itemDict objectForKey:OBJECT_ID];
    item.name = [itemDict objectForKey:ITEM_NAME_KEY];
    item.itemDescription = [itemDict objectForKey:ITEM_DESCRIPTION_KEY];
    item.tags = [itemDict objectForKey:ITEM_TAGS_KEY];
    
    if(![[itemDict objectForKey:ITEM_IMAGE_ARRAY_KEY] isEqual:[NSNull null]])
        item.imageIds = [itemDict objectForKey:ITEM_IMAGE_ARRAY_KEY];
    else
        item.imageIds = [[NSArray alloc] init];
    
    item.count = [[itemDict objectForKey:ITEM_COUNT_KEY] integerValue];
    item.condition = [itemDict objectForKey:ITEM_CONDITION_KEY];
    item.dateAdded = [itemDict objectForKey:ITEM_DATE_ADDED_KEY];
    item.ownerId = [itemDict objectForKey:ITEM_OWNER_ID];
    return item;
}

- (BOOL) isEqual:(id)object {
    if([object class] == [self class]) {
        TradeRoomItem *item = object;
        if([self.itemId isEqualToString:item.itemId])
            return true;
    }
    return false;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"Name: %@, Condition: %@, Count: %d", self->_name, self->_condition, self->_count];
}

@end
