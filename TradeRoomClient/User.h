//
//  User.h
//  TradeRoomClient
//
//  High level singleton model that should be shared throughout the application.
//  All updates should be reflected onto this model. Reading from this model should be considered
//  up to date.
//
//  Created by Taylor James Cressy on 6/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TradeRoomMeta.h"
#import "AccountPreferences.h"
#import "TradeRoomItem.h"

@interface User : NSObject {
    
}

+(id) getInstance;

+(User*) dictionaryToUser:(NSDictionary*) userDict;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *dateJoined;
@property (strong, nonatomic) NSString *lastLogin;
@property (strong, nonatomic) NSString *facebookId;

@property (strong, nonatomic) AccountPreferences *accountPreferences;
@property (strong, nonatomic) TradeRoomMeta *tradeRoomMeta;

@property (strong, nonatomic) NSMutableArray *tradeRoomItems;
@property (strong, nonatomic) NSMutableArray *friendRequests;   //Friends can be determined by checking if the status is "ACCEPTED"

- (void) updateTotalModelWithCompletion:(void (^)(void))completed;  //Recommended use

- (void) updateModelWithDict:(NSDictionary*) dict;
- (void) updateModelWithConsumerCompletion:(void (^)(void))completed;

- (void) updateItemsWithArray:(NSArray*) arr;
- (void) updateItemsWithConsumerCompletion:(void (^)(void))completed;

@end
