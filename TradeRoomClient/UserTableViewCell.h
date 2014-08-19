//
//  UserTableViewCell.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/16/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserCellDelegate <NSObject>

@required
- (void) addRequested:(User*) user;

@end

@interface UserTableViewCell : UITableViewCell {
    
}

@property (weak, nonatomic) id<UserCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfTradesLabel;
@property (weak, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIButton *addUserButton;

- (IBAction)addUserBtnPressed:(id)sender;

@end
