//
//  TradeRoomDatePicker.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/2/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "TradeRoomDatePicker.h"

#define kTabBarHeight 49.0f   /*Necessary for calculating animated transition*/

#define kAccessoryBarHeight 50.0f /*Can Change*/
#define kDatePickerHeight 216.0f


@implementation TradeRoomDatePicker {
    UIDatePicker *datePicker;
    
    NSDateFormatter *formatter;
    
    NSString *finishedString;
    
    UIView *accessoryBar;
    UIButton *done;
    UIButton *cancel;
    
    CGRect mainViewStartRect;
    
    BOOL shown;
}

/*
 
*/
- (id)initWithDelegate:(id<TradeRoomDatePickerDelegate>) del
{
    if(del == nil)
        return nil;
    
    mainViewStartRect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, (kAccessoryBarHeight + kDatePickerHeight));
    
    self = [super initWithFrame:mainViewStartRect];
    if (self) {
        // Initialization code
        
        self->delegate = del;
        
        shown = NO;
        
        //Create the starting rects
        CGRect accessoryBarStartRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kAccessoryBarHeight);
        CGRect datePickerStartRect = CGRectMake(0, kAccessoryBarHeight, [UIScreen mainScreen].bounds.size.width, kDatePickerHeight);
        
        //Rects of buttons
        CGRect doneButton = CGRectMake(accessoryBarStartRect.size.width - 55, accessoryBarStartRect.size.height - 47, 44, 44);
        CGRect cancelButton = CGRectMake(3, 3, 88, 44);
        
        //init the buttons
        self->done = [[UIButton alloc] initWithFrame:doneButton];
        self->cancel = [[UIButton alloc] initWithFrame:cancelButton];
        
        //customize the buttons
        [self->done setTitle:@"Done" forState:UIControlStateNormal];
        [self->cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        
        //Set listeners for buttons
        [self->done addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchDown];
        [self->cancel addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchDown];
        
        //Init the views
        self->datePicker = [[UIDatePicker alloc] initWithFrame:datePickerStartRect];
        self->accessoryBar = [[UIView alloc] initWithFrame:accessoryBarStartRect];
       
        //Add buttons to accessory bar
        [self->accessoryBar addSubview:self->done];
        [self->accessoryBar addSubview:self->cancel];
        
        //Customize the date picker
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.hidden = NO;
        datePicker.backgroundColor = [UIColor colorWithRed:200.0f green:200.0f blue:200.0f alpha:9.0f];
        
        //Set start date
        datePicker.date = [NSDate date];
        
        //Setup control events
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
     
        //Customize Accessory bar
        [self->accessoryBar setBackgroundColor:[[UIColor alloc] initWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        
        //Add picker and accessory bar to main view
        [self addSubview:self->accessoryBar];
        [self addSubview:self->datePicker];
        
        //Initialize and setup date formatter
        self->formatter = [[NSDateFormatter alloc] init];
        [self->formatter setDateFormat:@"dd-MM-yyyy"];
    }
    return self;
}


-(void) show {
    if(shown  == YES)
        return;
    
    [[[[UIApplication sharedApplication] keyWindow].subviews objectAtIndex:0] addSubview:self];
    
    [UIView animateWithDuration:0.4f animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        shown = YES;
    }];
    
}


-(void) hide {
    if(shown == NO)
        return;
    
    [UIView animateWithDuration:0.4f animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        shown = NO;
        
        [self donePressed];
    }];
}


#pragma mark - event handling

-(void) dateChanged:(id) sender {
    
    UIDatePicker *picker = (UIDatePicker*) sender;
    NSDate *date = [picker date];
    self->finishedString = [self->formatter stringFromDate:date];
}

-(void) donePressed {
    if(self->finishedString == nil) {
        NSDate *date = [self->datePicker date];
        self->finishedString = [self->formatter stringFromDate:date];
    }
    else if(self->finishedString.length == 0) {
        NSDate *date = [self->datePicker date];
        self->finishedString = [self->formatter stringFromDate:date];
    }
    
    [self->delegate datePickerFinished:self->finishedString];
    [self hide];
}

-(void) cancelPressed {
    [self->delegate datePickerCancelled];
    [self hide];
}


@end
