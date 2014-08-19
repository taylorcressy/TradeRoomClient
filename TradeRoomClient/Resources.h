//
//  Resources.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/25/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resources : NSObject

@property (strong, nonatomic) NSArray *conditions;
@property (strong, nonatomic) NSArray *tradeOptions;

+(id) getInstance;

- (void) updateResources;

@end
