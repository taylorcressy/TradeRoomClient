//
//  ProfileHeaderTableViewCell.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/1/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "ProfileHeaderTableViewCell.h"

@implementation ProfileHeaderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization Code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    //Adjust size of fonts to fit label box
    self.headerOneLabel.adjustsFontSizeToFitWidth = YES;
    self.headerTwoLabel.adjustsFontSizeToFitWidth = YES;
    self.headerThreeLabel.adjustsFontSizeToFitWidth = YES;
    //Borders
    [[self.customizedBackgroundView layer] setBorderWidth:0.5f];
    [[self.customizedBackgroundView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    //Shadow
    self.customizedBackgroundView.layer.masksToBounds = NO;
    //self.customizedBackgroundView.layer.shadowOffset = CGSizeMake(-0.5, 1);
    //self.customizedBackgroundView.layer.shadowRadius = 5;
    //self.customizedBackgroundView.layer.shadowOpacity = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
