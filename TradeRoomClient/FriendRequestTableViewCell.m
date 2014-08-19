//
//  FriendRequestTableViewCell.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/17/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "FriendRequestTableViewCell.h"

@implementation FriendRequestTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    //Customize Label
    _usernameLbl.adjustsFontSizeToFitWidth = YES;
    
    //Customize Profile Image View
    _profileImageView.clipsToBounds = YES;
    _profileImageView.contentMode = UIViewContentModeScaleToFill;
    _profileImageView.layer.cornerRadius = 15.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)acceptFriendRequestBtnPressed:(id)sender {
    [_delegate acceptFriendRequest:_user];
}

- (IBAction)denyFriendRequestBtnPressed:(id)sender {
    [_delegate denyFriendRequest:_user];
}

- (IBAction)blockFriendRequestBtnPressed:(id)sender {
    [_delegate blockFriendRequest:_user];
}
@end
