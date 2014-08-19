//
//  PickupDropoffViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/15/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickupDropoffViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *streetNumberField;
@property (weak, nonatomic) IBOutlet UITextField *streetNameField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *countyField;
@property (weak, nonatomic) IBOutlet UITextField *postcodeField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;


- (IBAction)backButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)whyAskPressed:(id)sender;


@end
