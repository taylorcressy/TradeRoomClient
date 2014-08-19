//
//  ProfileFieldTableViewCell.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/1/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "ProfileFieldTableViewCell.h"

static NSInteger inset = 30.0f;

@interface ProfileFieldTableViewCell() {
    BOOL currentlyEditing;  //NOTE: We are using a custom boolean instead of
    //super.editing to handle editing mode in a custom way
    TradeRoomDatePicker *datePicker;
}

@end

@implementation ProfileFieldTableViewCell

@synthesize editField, passwordCell, contentChanged, dateCell, delegate;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        currentlyEditing = NO;
        dateCell = NO;
        passwordCell = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    CGRect mainViewFrame = self.mainView.frame;
    mainViewFrame.size.width = frame.size.width;
    self.mainView.frame = mainViewFrame;
    [super setFrame:frame];
}

//Called during dequeue
//Called ONCE
- (void)awakeFromNib
{
    //Content view handling
    [[self.mainView layer] setCornerRadius:15.0f];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    //Edit Field
    [self.editField setBorderStyle:UITextBorderStyleNone];
}

//Called after dequeue
//Called multiple times!
-(void) layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
}

#pragma mark - TradeRoomDatePicker Delegate Methods

-(void)datePickerFinished:(NSString *)changedStr {
    if(delegate == nil)
        [NSException raise:@"No delegate" format:@"No Delegate given to ProfileFieldTableViewCell"];
    
    self.editField.placeholder = changedStr;
    [self->delegate contentChanged:changedStr Cell:self];
}

-(void) datePickerCancelled {
    //Do nothing
}

@end
