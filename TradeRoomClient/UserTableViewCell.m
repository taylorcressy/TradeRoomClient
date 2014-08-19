//
//  UserTableViewCell.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/16/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    _profileImage.clipsToBounds = YES;
    _profileImage.contentMode = UIViewContentModeScaleToFill;
    [_profileImage.layer setCornerRadius:15.0f];
    _numberOfTradesLabel.adjustsFontSizeToFitWidth = YES;
    _usernameLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addUserBtnPressed:(id)sender {
    [_delegate addRequested:self.user];
}
@end
