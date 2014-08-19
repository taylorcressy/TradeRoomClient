//
//  TradeRoomBarItemCell.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/5/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "TradeRoomBarItemCell.h"

@implementation TradeRoomBarItemCell {
    CGPoint originalLocation;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    //Setup the Close Button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setBackgroundImage:[UIImage imageNamed:@"RemoveButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(self.frame.size.width - 5, 5);
    button.layer.zPosition = 10;
    [self addSubview:button];
    
    //Setup the cell body
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    //Setup the imageView
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _imageView.clipsToBounds = YES;
    [_imageView.layer setCornerRadius:10.0f];
    [self addSubview:_imageView];
}

- (void) closePressed:(id) sender {
    [_delegate closePressed:self];
}
@end
