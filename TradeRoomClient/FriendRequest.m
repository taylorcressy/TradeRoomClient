//
//  FriendRequest.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/17/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "FriendRequest.h"

@implementation FriendRequest

- (id) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void) updateFriendRequestWithDict:(NSDictionary *)dict {
    self->_fromId = [dict objectForKey:FRIEND_REQUEST_FROM];
    self->_toId = [dict objectForKey:FRIEND_REQUEST_TO];
    self->_status = [dict objectForKey:FRIEND_REQUEST_STATUS];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"FROM: %@; TO:%@; Status:%@;", _fromId, _toId, _status];
}

@end
