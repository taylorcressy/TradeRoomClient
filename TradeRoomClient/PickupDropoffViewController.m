//
//  PickupDropoffViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/15/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <RNBlurModalView.h>
#import "PickupDropoffViewController.h"

#import "AccountCredentialsConsumer.h"

@interface PickupDropoffViewController () {
    AccountCredentialsConsumer *consumer;
    Address *address;
}

@end

@implementation PickupDropoffViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        consumer = [[AccountCredentialsConsumer alloc] init];
        address = [[User getInstance] accountPreferences].address;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self->_streetNumberField.text = address.streetNumber;
    self->_streetNameField.text = address.streetName;
    self->_cityField.text = address.city;
    self->_countyField.text = address.county;
    self->_countryField.text = address.country;
    self->_postcodeField.text = address.postcode;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate Methods
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UI Actions
- (IBAction)backButtonPressed:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
    NSString *streetName = self->_streetNameField.text;
    NSString *streetNumber = self->_streetNumberField.text;
    NSString *city = self->_cityField.text;
    NSString *county = self->_countyField.text;
    NSString *country = self->_countryField.text;
    NSString *postcode = self->_postcodeField.text;
    
    //Do form validation here
    
    //Submit request
    [consumer requestUpdateAddressDetails:streetNumber
                               StreetName:streetName
                                 Postcode:postcode
                                   County:county
                                     City:city
                                  Country:country
                               Completion:^(ServiceMessage *msg) {
                                   if([msg responseCode] == 140) {  //Success
                                       RNBlurModalView *modal = [[RNBlurModalView alloc] initWithTitle:@"Success" message:@"You have successfully updated your account details"];
                                       [modal show];
                                       [[User getInstance] updateModelWithConsumerCompletion:nil];
                                   }
                                   else {
                                       RNBlurModalView *modal = [[RNBlurModalView alloc] initWithTitle:@"Failed" message:[msg localizedMessage]];
                                       [modal show];
                                   }
                               }];
}

- (IBAction)whyAskPressed:(id)sender {
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithTitle:@"Why We Ask" message:@"Trade Room will never release your personal address details without your permission. Addresses will only be used in the case where you specify a Trade Request which requires a pickup or dropoff location for either another User or a postal service."];
    [modal show];
}
@end