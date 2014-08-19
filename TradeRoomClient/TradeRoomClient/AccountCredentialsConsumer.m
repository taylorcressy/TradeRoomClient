//
//  AccountCredentialsConsumer.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "AccountCredentialsConsumer.h"
#import "ServerKeys.h"

@implementation AccountCredentialsConsumer {
    void (^completionBlock)(ServiceMessage*);
}

-(id) init {
    self = [super init];
    
    if(self) {
        return self;
    }
    return nil;
}

/*
    Attempt to Register with the server
 
    Async
 */
-(void) requestRegistration:(NSString *)username
                      Email:(NSString *)email
                  FirstName:(NSString *)firstName
                   LastName:(NSString *)lastName
                   Password:(NSString *)password
                 Completion:(void (^)(ServiceMessage *))complete {
    if(username == nil || password == nil || firstName == nil || lastName == nil || password == nil) {
        NSLog(@"Received null values for requestRegistration");
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:USERNAME_KEY];
    [params setObject:password forKey:PASSWORD_KEY];
    [params setObject:[firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:FIRST_NAME_KEY];
    [params setObject:[lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:LAST_NAME_KEY];
    [params setObject:[email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:EMAIL_KEY];
    
    
    [self->handler sendPostRequest:REGISTER_REQUEST withParams:params Completion:^(NSDictionary *responseKeysAndValues) {
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];
}


/*
    Attemp to Login to the Server

    Async
 */
-(void) requestLoginWithUsername:(NSString*) username
                        Password:(NSString*) password
                      Completion:(void (^)(ServiceMessage*)) complete {
    if(username == nil || password == nil) {
        NSLog(@"Received null values in requestLoginWithUsername");
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:USERNAME_KEY];
    [params setObject:password forKey:PASSWORD_KEY];
    
    
    [self->handler sendPostRequest:LOGIN_REQUEST withParams:params Completion:^(NSDictionary *responseKeysAndValues) {
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];
}


/*
    Request update of email address
 
    Async
 */
-(void) requestUpdateEmailAddress:(NSString *)email
                       Completion:(void (^)(ServiceMessage *))complete
{
    if(email == nil) {
        NSLog(@"received null value for requestUPdateEmailAddress");
        return;
    }
    
    NSDictionary *params = @{EMAIL_KEY: email};
    
    [self->handler sendPostRequest:UPDATE_EMAIL_REQUEST withParams:params Completion:^(NSDictionary *responseKeysAndValues) {
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];
}

/*
    Request update of account Details
 
    Async
 */
-(void) requestUpdateAccountPassword:(NSString*) password
                   FirstName:(NSString*) firstName
                    LastName:(NSString*) lastName
                         dob:(NSString*) dob
                  Completion:(void (^)(ServiceMessage*)) complete {
    
    if(password == nil && firstName == nil && lastName == nil && dob == nil ) {
        NSLog(@"All values are nil, denying request to send to server");
        return;
    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if(password != nil) {
        [params setObject:password forKey:PASSWORD_KEY];
    }
    if(firstName != nil)
        [params setObject:firstName forKey:FIRST_NAME_KEY];
    if(lastName != nil)
        [params setObject:lastName forKey:LAST_NAME_KEY];
    if(dob != nil)
        [params setObject:dob forKey:BIRTH_DAY_KEY];
    
    NSLog(@"%@", [params description]);
    
    [self->handler sendPostRequest:UPDATE_ACCOUNT_REQUEST withParams:params Completion:^(NSDictionary *responseKeysAndValues) {
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];
}

/*
    Retrieve the latest model of the user data.
 */
-(void) requestAccountDetailsCompletion:(void (^)(ServiceMessage*)) complete {
    [self->handler sendGetRequest:GET_USER_DETAILS withParams:nil Completion:^(NSDictionary *responseKeysAndValues){
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];
}

@end
