//
//  ProcessingRequestOverlay.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/4/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "ProcessingRequestOverlay.h"

@implementation ProcessingRequestOverlay

static UIView *processingView;

+ (void) showOverlay {
    
    UIActivityIndicatorView *indicatorView;
    UILabel *message;
    
    if(processingView == nil) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        processingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screenSize.width, screenSize.height)];
        message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
        [message setText:@"Loading..."];
        [message setTextColor:[UIColor whiteColor]];
        [message sizeToFit];
    
        //Customize overlay
        [processingView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
    
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [indicatorView setCenter:processingView.center];
        CGPoint indicatorCenter = processingView.center;
        CGPoint messageCenter = indicatorCenter;
        messageCenter.y += 35;
        messageCenter.x += 10;
        message.center = messageCenter;
        [processingView addSubview:indicatorView];
        [processingView addSubview:message];
    }
    
    [[UIApplication sharedApplication].keyWindow.subviews[0] addSubview:processingView];
    
    [indicatorView startAnimating];
}

+ (void) hideOverlay {
    if(processingView == nil)
        return;
    
    [processingView removeFromSuperview];
}

@end
