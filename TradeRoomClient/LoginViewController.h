//
//  LoginViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterView.h"
#import "FBHandler.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, RegisterViewDelegate, FBHandlerUIDelegate> {

}

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton; //So we can identify the manual segue sender

- (IBAction)loginSubmit:(id)sender;
- (IBAction)registerSubmit:(id)sender;

@property (nonatomic) NSString *registrationUsername;
@property (nonatomic) NSString *registrationPassword;

@end

