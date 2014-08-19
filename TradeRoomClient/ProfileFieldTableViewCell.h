//
//  ProfileFieldTableViewCell.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/1/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TradeRoomDatePicker.h"


#define TOP_CELL 0
#define MIDDLE_CELL 1
#define BOTTOM_CELL 2

@protocol ProfileFieldTableViewCellDelegate <NSObject>

@required
-(void) contentChanged:(NSString*) newContent Cell:(id) cell;

@end


@interface ProfileFieldTableViewCell : UITableViewCell <TradeRoomDatePickerDelegate>{
    BOOL passwordCell;
    BOOL contentChanged;
    
    BOOL dateCell;
    
    id<ProfileFieldTableViewCellDelegate> delegate;
}
@property (weak, nonatomic) IBOutlet UITextField *editField;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (nonatomic) BOOL passwordCell;
@property (nonatomic) BOOL contentChanged;
@property (nonatomic) BOOL dateCell;

@property (nonatomic) id<ProfileFieldTableViewCellDelegate> delegate;

@end
