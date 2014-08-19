//
//  TradeRoomItemCell.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/15/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "TradeRoomItemCell.h"

@implementation TradeRoomItemCell {
    CGPoint lastLocation;
    CGPoint originalLocation;
    UIView *originalParent;
    __weak IBOutlet UIView *parentImageView;
}

@synthesize itemImage, item;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) enableGesturesAndShouldDrag:(BOOL) drag {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    if(drag) {
        UILongPressGestureRecognizer *panGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.minimumPressDuration = 0.1;
        self.gestureRecognizers = @[panGesture, tapGesture];
    }
    else
        self.gestureRecognizers = @[tapGesture];
}

- (void) awakeFromNib {
    [self.itemName setAdjustsFontSizeToFitWidth:YES];
    [[self layer] setCornerRadius:20.0f];
    [[self.itemImage layer] setCornerRadius:20.0f];
    [[self->parentImageView layer] setCornerRadius:20.0f];
    [self->parentImageView setBackgroundColor:[UIColor clearColor]];
    [self.itemName setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.itemImage.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height - LABEL_PADDING);
}

#pragma mark - Gesture Recognizers

- (void) handleTap:(UITapGestureRecognizer*) gesture {
    [_delegate cellTapped:self];
}

- (void) handlePan:(UILongPressGestureRecognizer*) gesture {
    CGPoint point  = [gesture locationInView:_referencedView];
    if(gesture.state == UIGestureRecognizerStateBegan) {
        originalLocation = self.center;
        self.layer.zPosition = 100;

        [UIView animateWithDuration:0.3
                         animations:^{
                             self.alpha = 0.8f;
                             self.itemName.alpha = 0;
                         } completion:nil];
    }
    else if(gesture.state == UIGestureRecognizerStateChanged){
        CGPoint center = self.center;
        center.x += point.x - lastLocation.x;
        center.y += point.y - lastLocation.y;
        self.center = center;
        [_delegate currentCenter:point OfCell:self];
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        BOOL shouldAnimate =  [_delegate didFinishDragging];
        
        if(shouldAnimate) {
            [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = originalLocation;
                             self.itemName.alpha = 1;
                             self.alpha = 1.0f;
                         } completion:^(BOOL finished) {
                             self.layer.zPosition = 0;
                             [[self->parentImageView layer] setShadowOpacity:0.0f];
                         }];
        }
        else {
            self.itemName.alpha = 1;
            self.layer.zPosition = 0;
            self.center = originalLocation;
        }
    }
    lastLocation = point;
}

@end
