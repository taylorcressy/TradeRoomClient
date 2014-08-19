//
//  TradeRoomMeta.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeRoomMeta : NSObject {
    
}

@property (strong, nonatomic) NSMutableArray *itemIds;
@property (nonatomic) NSInteger maxItemImageCount;
@property (nonatomic) NSInteger maxItemCount;
@property (nonatomic) NSInteger itemCount;
@property (nonatomic) NSInteger numberOfSuccessfulTrades;

- (void) updateTradeRoomMetaWithDict:(NSDictionary*) dict;

@end
