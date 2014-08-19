//
//  UserItemSectionHeader.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/11/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "UserItemSectionHeader.h"

@implementation UserItemSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) layoutSubviews {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    if(_userName == nil)
        [label setText:@"Your Items"];
    else
        [label setText:[NSString stringWithFormat:@"%@'s Items", [_userName capitalizedString]]];
    [label setTextColor:[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha: 0.9f]];
    [label setAdjustsFontSizeToFitWidth:YES];
    label.center = CGPointMake(self.frame.size.width * .30, self.frame.size.height / 2);
    [self addSubview:label];
}

@end
