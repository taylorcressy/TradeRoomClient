//
//  TradeRoomItem.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeRoomItem : NSObject {
    
}

+ (TradeRoomItem*) dictionyToItem:(NSDictionary*) dictionary;

@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSArray *imageIds;
@property (nonatomic) NSInteger count;
@property (strong, nonatomic) NSString *condition;
@property (strong, nonatomic) NSString *dateAdded;
@property (strong, nonatomic) NSString *ownerId;

@end
