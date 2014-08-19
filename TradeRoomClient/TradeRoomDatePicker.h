//
//  TradeRoomDatePicker.h
//  TradeRoomClient
//
//  Only supporting portrait
//
//  Created by Taylor James Cressy on 5/2/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TradeRoomDatePickerDelegate <NSObject>

@required
-(void) datePickerFinished:(NSString*) changedStr;
-(void) datePickerCancelled;

@end

@interface TradeRoomDatePicker : UIView {
    
    id<TradeRoomDatePickerDelegate> delegate;
}

- (id)initWithDelegate:(id<TradeRoomDatePickerDelegate>) delegate;

- (void) show;
- (void) hide;

@end
