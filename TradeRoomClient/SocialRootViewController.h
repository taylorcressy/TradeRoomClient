//
//  SocialRootViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/13/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SwapViewController : UIViewController

- (void) switchToFriendsPage;
- (void) switchToTradePage;
- (void) switchToChatPage;

@end

@interface SocialRootViewController : UIViewController


//The social segment control (switch between MyFriends, Chat, And Trade Views
@property (weak, nonatomic) IBOutlet UISegmentedControl *mainSocialSegmentControl;

- (IBAction)mainSocialSegmentControlChanged:(id)sender;
- (IBAction)addFriendsBtnTouched:(id)sender;

@end
