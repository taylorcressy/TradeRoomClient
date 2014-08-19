//
//  FBHandler.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/10/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "FBHandler.h"
#import "AccountCredentialsConsumer.h"


@implementation FBHandler {
    AccountCredentialsConsumer *consumer;
}

+ (id) sharedInstance {
    static FBHandler *fbHandle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fbHandle = [[self alloc] init];
    });
    return fbHandle;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        consumer = [[AccountCredentialsConsumer alloc] init];
    }
    return self;
}


/*
    The state of the facebook session has changed. This should be called elsewhere anytime it does change
 */
- (void) sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error {
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        // Show the user the logged-in UI
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error) {
            if(error) {
                //There was an error
                NSLog(@"There was an error requestForMe");
                return;
            }
            else {
                NSString *firstName = [result objectForKey:@"first_name"];
                NSString *lastName = [result objectForKey:@"last_name"];
                NSString *email = [result objectForKey:@"email"];
                NSString *authToken = [[session accessTokenData] accessToken];
                NSString *fbId = [result objectForKey:@"id"];
                NSString *username = [email componentsSeparatedByString:@"@"][0];
                
                
                [consumer requestSignInWithFacebook:fbId
                                          AuthToken:authToken
                                          FirstName:firstName
                                           LastName:lastName
                                              Email:email
                                           Username:username
                                         Completion:^(ServiceMessage *msg) {
                                             if([msg responseCode] == 510) {
                                                 [_delegate userLoggedIn:[msg dict]];
                                             }
                                         }];
            }
        }];
        
        /*
            As of Facebook OpenGraph v2.0, A full features friends list can only be grabbed by people who have specified
            "user_friends" permissions and added this app
         */
        [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
            
            if(error) {
                //There was an error
                NSLog(@"Facebook Error: requestForMyFriends");
                return;
            }
            else {
               _friendsList = [result objectForKey:@"data"];
            }
            
        }];
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        [_delegate userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [_delegate showMessage:alertText WithTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [_delegate showMessage:alertText WithTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [_delegate showMessage:alertText WithTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [_delegate userLoggedOut];
    }
}

- (void) signupWithFacebook {
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {

        //Reset the session? Not sure why??
        [FBSession.activeSession closeAndClearTokenInformation];
        
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];
    }
}

@end
