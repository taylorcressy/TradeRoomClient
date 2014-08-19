//
//  FriendRequestTableViewCell.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/17/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendRequestCellDelegate <NSObject>

@required
- (void) acceptFriendRequest:(User*) user;
- (void) denyFriendRequest:(User*) user;
- (void) blockFriendRequest:(User*) user;

@end

@interface FriendRequestTableViewCell : UITableViewCell {
    
}

@property (weak, nonatomic) id<FriendRequestCellDelegate> delegate;
@property (weak, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;

- (IBAction)acceptFriendRequestBtnPressed:(id)sender;
- (IBAction)denyFriendRequestBtnPressed:(id)sender;
- (IBAction)blockFriendRequestBtnPressed:(id)sender;

@end
