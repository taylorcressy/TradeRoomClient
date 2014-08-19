//
//  FBHandler.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/10/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>

/*
    The delegate protocol that relays all FB actions to a UI Handler to accurately depict actions done with FB
 */
@protocol FBHandlerUIDelegate <NSObject>

@required
- (void) userLoggedIn:(NSDictionary*) userData;
- (void) userLoggedOut;
- (void) showMessage:(NSString*) text WithTitle:(NSString*) title;

@end

@interface FBHandler : NSObject {
    
}

@property (nonatomic) id<FBHandlerUIDelegate> delegate;
@property (nonatomic) NSArray* friendsList;
+ (id) sharedInstance;

//Should always be called during the entire duration of the app runtime when FB is being user
// Informs the app of sessions state changes for facebook
- (void) sessionStateChanged:(FBSession*) session state:(FBSessionState) state error:(NSError*) error;

/*
    Sign Up With Facebook
 */
- (void) signupWithFacebook;

@end
