//
//  User.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "User.h"

#import "AccountCredentialsConsumer.h"
#import "TradeItemConsumer.h"
#import "FriendRequest.h"

@implementation User {
    AccountCredentialsConsumer *acctConsumer;
    TradeItemConsumer *itemConsumer;
    
    BOOL updatingModel; //For queing updates
    BOOL updatingUser;
    BOOL updatingItems;
}

+ (id) getInstance {
    static User *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[self alloc] init];
    });
    return user;
}


+ (User*) dictionaryToUser:(NSDictionary *)dict
{
    User *user = [[User alloc] init];
    user.userId = [dict objectForKey:OBJECT_ID];
    user.username = [dict objectForKey:USERNAME_KEY];
    user.email = [dict objectForKey:EMAIL_KEY];
    user.dateJoined = [dict objectForKey:DATE_USER_JOINED_KEY];
    user.lastLogin = [dict objectForKey:DATE_LAST_LOGIN_KEY];
    if([dict objectForKey:FACEBOOK_ID] != nil && [dict valueForKey:FACEBOOK_ID] != [NSNull null])
        user.facebookId = [dict objectForKey:FACEBOOK_ID];
    if([dict objectForKey:DICT_TRADE_ROOM_META] != nil && [dict valueForKey:DICT_TRADE_ROOM_META] != [NSNull null])
        [user.tradeRoomMeta updateTradeRoomMetaWithDict:[dict valueForKey:DICT_TRADE_ROOM_META]];
    [user.friendRequests removeAllObjects];
    if([dict objectForKey:ARR_FRIEND_REQUESTS] != nil && [dict valueForKey:ARR_FRIEND_REQUESTS] != [NSNull null]) {
        NSArray *friendRequests = [dict objectForKey:ARR_FRIEND_REQUESTS];
        for(NSDictionary *dict in friendRequests) {
            FriendRequest *request = [[FriendRequest alloc] init];
            [request updateFriendRequestWithDict:dict];
            [user.friendRequests addObject:request];
        }
    }
    return user;
}


- (id) init {
    self = [super init];
    
    if(self) {
        self->acctConsumer = [[AccountCredentialsConsumer alloc] init];
        self->itemConsumer = [[TradeItemConsumer alloc] init];
        self->_accountPreferences = [[AccountPreferences alloc] init];
        self->_tradeRoomMeta = [[TradeRoomMeta alloc] init];
        self->_tradeRoomItems = [[NSMutableArray alloc] init];
        self->_friendRequests = [[NSMutableArray alloc] init];
        self->updatingModel = NO;
        self->updatingUser = NO;
        self->updatingItems = NO;
        return self;
    }
    return nil;
}

/*
    Function to handle recalling the update function when there have been simultaneous calls to it
 */
- (void) queuedUpdate:(NSTimer*) timer {
    NSDictionary *dict = [timer userInfo];
    [self updateTotalModelWithCompletion:[dict objectForKey:@"completed"]];
}

//This is a necessary clearing cached data in between login/logout
//So the work around is to clear these values out ever reload
- (void) clearCriticalMembers {
    self->_username = nil;
    self->_facebookId = nil;
    self->_userId = nil;
}

- (void) updateTotalModelWithCompletion:(void (^)(void))completed {
    if(!updatingModel) {
        updatingModel = YES;
        updatingItems = YES;
        updatingUser = YES;
        [self clearCriticalMembers];
        
        [self updateItemsWithConsumerCompletion:^{
            updatingItems = NO;
            if(!updatingItems && !updatingUser) {
                updatingModel = NO;
                completed();
                return;
            }
        }];
        [self updateModelWithConsumerCompletion:^{
            updatingUser = NO;
            if(!updatingItems && !updatingUser) {
                updatingModel = NO;
                completed();
                return;
            }
        }];
    }
    else {
         void (^handlerCopy)(void) = [completed copy];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:handlerCopy forKey:@"completed"];
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(queuedUpdate:)
                                       userInfo:dict
                                        repeats:NO];
    }
}

-(void) updateModelWithDict:(NSDictionary *)dict {
    self->_userId = [dict objectForKey:OBJECT_ID];
    self->_username = [dict objectForKey:USERNAME_KEY];
    self->_email = [dict objectForKey:EMAIL_KEY];
    self->_dateJoined = [dict objectForKey:DATE_USER_JOINED_KEY];
    self->_lastLogin = [dict objectForKey:DATE_LAST_LOGIN_KEY];
    
    if([dict objectForKey:FACEBOOK_ID] != nil && [dict valueForKey:FACEBOOK_ID] != [NSNull null])
        self->_facebookId = [dict objectForKey:FACEBOOK_ID];
    [self->_tradeRoomMeta updateTradeRoomMetaWithDict:[dict valueForKey:DICT_TRADE_ROOM_META]];
    if([dict valueForKey:DICT_ACCOUNT_PREF] != nil && [dict valueForKey:DICT_ACCOUNT_PREF] != [NSNull null])
        [self->_accountPreferences updateAccountPreferencesWithDict:[dict valueForKey:DICT_ACCOUNT_PREF]];
    
    [self.friendRequests removeAllObjects];
    if([dict objectForKey:ARR_FRIEND_REQUESTS] != nil && [dict valueForKey:ARR_FRIEND_REQUESTS] != [NSNull null]) {
        NSArray *friendRequests = [dict objectForKey:ARR_FRIEND_REQUESTS];
        for(NSDictionary *dict in friendRequests) {
            FriendRequest *request = [[FriendRequest alloc] init];
            [request updateFriendRequestWithDict:dict];
            [self.friendRequests addObject:request];
        }
    }
}

/*
    HTTP front end to updateModelWithDict
 */
-(void) updateModelWithConsumerCompletion:(void (^)(void))completed {
    __block User *safeSelf = self;
    
    [self->acctConsumer requestAccountDetailsCompletion:^(ServiceMessage *complete) {
        if([complete responseCode] == 800) {  //GET Successful
            [safeSelf updateModelWithDict:[complete dict]];
            if(completed != nil)
                completed();
            return;
        }
        else {
            NSLog(@"Failed To Update Model");
            completed();
        }
    }];
}

- (void) updateItemsWithArray:(NSArray *)arr {
    [self->_tradeRoomItems removeAllObjects];
    
    TradeRoomItem *item = nil;
    for(NSDictionary *itemDict in arr) {
        item = [TradeRoomItem dictionyToItem:itemDict];
        [self->_tradeRoomItems addObject:item];
    }
}

- (void) updateItemsWithConsumerCompletion:(void (^)(void))completed {
    __block User *safeSelf = self;

    [self->itemConsumer requestRetrieveItemsFromList:self.tradeRoomMeta.itemIds Completion:^(ServiceMessage *message) {
        if(message == nil) {
            completed();
            return;
        }
        if([message responseCode] == 240) { //Success
            [safeSelf updateItemsWithArray:[message array]];
            
            if(completed != nil)
                completed();
        }
        else {  //Error
            NSLog(@"ERROR in updateItemWithConsumers: %@", [message localizedMessage]);
            completed();
        }
    }];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"\n\tID: %@; \n\tUsername: %@; \n\tEmail: %@; \n\tDate Joined: %@; \n\tLast Login: %@;  \n\n\t Facebook Id: %@; \n\n\tAccount Preferences: %@; \n\n\tTrade Room Meta: %@;\n\n\tFriend Requests: %@;",
            self->_userId,
            self->_username,
            self->_email,
            self->_dateJoined,
            self->_lastLogin,
            _facebookId,
            [self->_accountPreferences description],
            [self->_tradeRoomMeta description],
            [self->_friendRequests description]];
}



@end
