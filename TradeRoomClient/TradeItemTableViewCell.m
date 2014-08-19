//
//  TradeItemTableViewCell.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "TradeItemTableViewCell.h"

#define TABLE_CELL_INSET 10

@implementation TradeItemTableViewCell

@synthesize itemDescription, itemImage, itemName, itemCondition;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += TABLE_CELL_INSET;
    [super setFrame:frame];
}

- (void)awakeFromNib
{
    // Initialization code
    [self->itemDescription sizeToFit];
    self->itemDescription.numberOfLines = 0;
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [[self->_itemContent layer] setCornerRadius:15.0f];
    [[self->itemImage layer] setCornerRadius:15.0f];
    self->itemImage.contentMode = UIViewContentModeScaleToFill;
    itemImage.layer.masksToBounds = YES;
    
    CGRect rect = self.contentView.frame;
    rect.size.width *= .85;
    [self.contentView setFrame:rect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
