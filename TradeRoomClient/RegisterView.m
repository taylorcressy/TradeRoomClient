//
//  RegisterView.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/10/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "RegisterView.h"

@implementation RegisterTextField {
    
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
    }
    return self;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

@end

@implementation RegisterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    //Setup corner radii
    [_emailField.layer setCornerRadius:15.0f];
    [_usernameField.layer setCornerRadius:15.0f];
    [_passwordField.layer setCornerRadius:15.0f];
}


#pragma mark - UI Actions
- (IBAction)registerBtnPressed:(id)sender {
    [_delegate registerSubmittedWithUsername:_usernameField.text Email:_emailField.text Password:_passwordField.text];
}

- (IBAction)closeBtnPressed:(id)sender {
    [_delegate closeBtnPressed];
}

- (IBAction)facebookBtnPressed:(id)sender {
    [_delegate signUpWithFacebookPressed];
}

- (IBAction)googlePlusBtnPressed:(id)sender {
}


#pragma mark - UITextField Delegate Methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
