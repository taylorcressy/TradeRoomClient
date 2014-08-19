//
//  TradeRequestReviewCell.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/11/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "TradeRequestReviewCell.h"

@implementation TradeRequestReviewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    //Setup the cell body
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    //Setup the imageView
    _itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _itemImage.clipsToBounds = YES;
    [_itemImage.layer setCornerRadius:10.0f];
    _itemImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_itemImage];

}

@end
