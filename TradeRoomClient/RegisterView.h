//
//  RegisterView.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/10/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterViewDelegate <NSObject>

@required
- (void) registerSubmittedWithUsername:(NSString*) username Email:(NSString*) email Password:(NSString*) password;
- (void) closeBtnPressed;
- (void) signUpWithFacebookPressed;

@end

@interface RegisterTextField : UITextField @end

@interface RegisterView : UIView <UITextFieldDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) id<RegisterViewDelegate> delegate;

- (IBAction)registerBtnPressed:(id)sender;
- (IBAction)closeBtnPressed:(id)sender;
- (IBAction)facebookBtnPressed:(id)sender;
- (IBAction)googlePlusBtnPressed:(id)sender;

@end
