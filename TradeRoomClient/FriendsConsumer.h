//
//  FriendsConsumer.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/11/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "Consumer.h"

@interface FriendsConsumer : Consumer {
    
}

- (void) requestSendFriendRequestTo:(NSString*) userId
             Completion:(void (^)(ServiceMessage*)) complete;

- (void) requestRespondToFriendRequest:(NSString*) userId
                                Status:(NSString*) status
                            Completion:(void (^)(ServiceMessage*)) complete;

- (void) requestAccountDetailsOfUser:(NSString*) userId
                          Completion:(void (^)(ServiceMessage*)) complete;

- (void) requestAccountDetailsOfMultipleUsers:(NSArray*) userIds
                                   Completion:(void (^)(ServiceMessage*)) complete;

- (void) requestAccountDetailsOfFacebookUsers:(NSArray*) facebookArrays
                                   Completion:(void (^)(ServiceMessage*)) complete;

- (void) requestAllFriendsWithCompletion:(void (^)(ServiceMessage*)) complete;

@end
