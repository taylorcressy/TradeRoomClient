//
//  FriendRequest.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/17/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendRequest : NSObject

@property (strong, nonatomic) NSString *fromId;
@property (strong, nonatomic) NSString *toId;
@property (strong, nonatomic) NSString *status;

- (void) updateFriendRequestWithDict:(NSDictionary*) dict;

@end
