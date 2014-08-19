//
//  FriendsConsumer.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/11/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "FriendsConsumer.h"

@implementation FriendsConsumer {
    
}

- (void) requestSendFriendRequestTo:(NSString *)userId
                         Completion:(void (^)(ServiceMessage *))complete {
    if(userId == nil)
    {
        NSLog(@"UserId is equal to nil in requestSendFriendRequestTo:Completion:");
        return;
    }
    NSDictionary *params = @{USER_ID_KEY: userId};
    
    [self->handler sendPostRequest:SEND_FRIEND_REQUEST
                        withParams:params
                        Completion:^(NSDictionary *responseKeysAndValues) {
                            [self respondToCaller:responseKeysAndValues Completion:complete];
                        }];
}

- (void) requestRespondToFriendRequest:(NSString *)userId
                                Status:(NSString *)status
                            Completion:(void (^)(ServiceMessage *))complete
{
    if(userId == nil)
    {
        NSLog(@"UserId is equal to nil in requestRespondToFriendRequest:Completion:");
        return;
    }
    
    NSDictionary *params = @{USER_ID_KEY: userId, FRIEND_REQUEST_STATUS: status};
    [self->handler sendPostRequest:RESPOND_TO_FRIEND_REQUEST
                        withParams:params
                        Completion:^(NSDictionary *responseKeysAndValues) {
                           [self respondToCaller:responseKeysAndValues Completion:complete];
                        }];
}

/*
 Retrieve details associated with the userId
 */
- (void) requestAccountDetailsOfUser:(NSString *)userId
                          Completion:(void (^)(ServiceMessage *))complete
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userId forKey:USER_ID_KEY];
    
    [self->handler sendGetRequest:GET_FRIEND_DETAILS
                       withParams:params
                       Completion:^(NSDictionary *responseKeysAndValues) {
                           [self respondToCaller:responseKeysAndValues Completion:complete];
                       }];
}

- (void) requestAccountDetailsOfMultipleUsers:(NSArray *)userIds Completion:(void (^)(ServiceMessage *))complete {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userIds
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{USER_ID_MULT_KEY: jsonString};
    
    [self->handler sendGetRequest:GET_ALL_USERS_WITH_IDS
                       withParams:params Completion:^(NSDictionary *responseKeysAndValues) {
                           [self respondToCaller:responseKeysAndValues Completion:complete];
                       }];
}

/*
    Retrieve all friends associated with facebook IDs
 */
- (void) requestAccountDetailsOfFacebookUsers:(NSArray *)facebookArrays
                                   Completion:(void (^)(ServiceMessage *))complete {
    if(facebookArrays == nil || facebookArrays.count == 0) {
        NSLog(@"Facebook User IDS are null/empty");
        return;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:facebookArrays
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{FACEBOOK_ID_MULT: jsonString};
    
    [self->handler sendGetRequest:GET_ALL_FACEBOOK_USERS withParams:params Completion:^(NSDictionary *responseKeysAndValues)
        {
            [self respondToCaller:responseKeysAndValues Completion:complete];
        }];
}

/*
    Retrieve all friends associated with a user
 */
- (void) requestAllFriendsWithCompletion:(void (^)(ServiceMessage *))complete {
    [self->handler sendGetRequest:GET_ALL_FRIENDS
                       withParams:nil Completion:^(NSDictionary *responseKeysAndValues) {
                           [self respondToCaller:responseKeysAndValues Completion:complete];
                       }];
}

@end
