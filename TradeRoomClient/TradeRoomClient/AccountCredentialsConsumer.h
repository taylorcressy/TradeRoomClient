//
//  AccountCredentialsConsumer.h
//  TradeRoomClient
//
//  Exposes the Trade Room Server API for the Account Credentials Service
//
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Consumer.h"

@interface AccountCredentialsConsumer : Consumer {
    
}

-(void) requestRegistration:(NSString*) username
                      Email:(NSString*) email
                  FirstName:(NSString*) firstName
                   LastName:(NSString*) lastName
                   Password:(NSString*) password
                 Completion:(void (^)(ServiceMessage*)) complete;

-(void) requestLoginWithUsername:(NSString*) username
                        Password:(NSString*) password
                      Completion:(void (^)(ServiceMessage*)) complete;

-(void) requestUpdateEmailAddress:(NSString*) email
                       Completion:(void (^)(ServiceMessage*)) complete;

-(void) requestUpdateAccountPassword:(NSString*) password
                   FirstName:(NSString*) firstName
                    LastName:(NSString*) lastName
                         dob:(NSString*) dob
                  Completion:(void (^)(ServiceMessage*)) complete;

-(void) requestAccountDetailsCompletion:(void (^)(ServiceMessage*)) complete;

@end
