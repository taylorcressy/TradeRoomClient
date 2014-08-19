//
//  LoginViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "LoginViewController.h"

#import <SSKeychain.h>
#import <SSKeychainQuery.h>
#import <SDWebImageManager.h>
#import <RNBlurModalView.h>

#import "AccountCredentialsConsumer.h"
#import "ClientPropertiesAndMessages.h"

#define LOGIN_TO_LANDING_SEGUE @"loginToLandingSegue"

#define LOGIN_SUCCESS 110
#define LOGIN_FAILED_USERNAME_PASS_COMBO 111

#define REGISTER_SUCCESS 100
#define REGISTER_FAIL_DUP_EMAIL 101
#define REGISTER_FAIL_DUP_USERNAME 102
#define REGISTER_FAIL_INVALID_FORM 103

#define TRADE_ROOM_KEY_IDENT @"com.traderoom.TradeRoomClient"
#define TRADE_ROOM_USERNAME_KEYCHAIN_KEY @"TradeRoomUsername"
#define TRADE_ROOM_PASSWORD_KEYCHAIN_KEY @"TradeRoomPassword"

@interface LoginViewController () {
    RNBlurModalView *modalView;
    
    AccountCredentialsConsumer *accountConsumer;

    ClientPropertiesAndMessages *properties;
    Resources *resources;
    NSDictionary *userDataToPass;
}

@end

@implementation LoginViewController

@synthesize registrationUsername, registrationPassword;

/*
    This is the init method to be called as it is UIController linked to story board
 */
-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {        
        self->accountConsumer = [[AccountCredentialsConsumer alloc] init];
        self->properties = [ClientPropertiesAndMessages getInstance];
        self->resources = [Resources getInstance];
        return self;
    }
    else return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Hide navigation bar
    [[self navigationController] setNavigationBarHidden:YES];
    
    //Check for username and password in keychain
    NSArray *accounts = [SSKeychain accountsForService:TRADE_ROOM_KEY_IDENT];
    NSDictionary *account;
    NSString *password;
    
    
    if([accounts count] != 0){
        account = [accounts objectAtIndex:0];
        
        if(account != nil) {
            [self->_emailField setText:[account valueForKey:@"acct"]];
            password = [SSKeychain passwordForService:TRADE_ROOM_KEY_IDENT account:[account valueForKey:@"acct"]];
            if(password != nil) {
                [self->_passwordField setText:password];
            }
        }
    }

}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //Determine if the register controller set the username field. If so, populate this field
    if(self->registrationUsername != nil) {
        [self->_emailField setText:self->registrationUsername];
    }
    if(self->registrationPassword != nil) {
        [self->_passwordField setText:self->registrationPassword];
    }
    
    ((FBHandler*)[FBHandler sharedInstance]).delegate = self;
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [[FBHandler sharedInstance] sessionStateChanged:session state:state error:error];
                                      }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}


#pragma mark - Server Request
- (IBAction)loginSubmit:(id)sender {
    
    NSString *email = [self->_emailField text];
    NSString *password = [self->_passwordField text];

    [ProcessingRequestOverlay showOverlay];
    [self->accountConsumer requestLoginWithUsername:email Password:password Completion:^(ServiceMessage *message) {
        [ProcessingRequestOverlay hideOverlay];
        if(message == nil) {
            NSLog(@"Connection Error");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ConnectionErrorTitle", nil)
                                                                message:NSLocalizedString(@"ConnectionErrorMessage", nil) delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            
            [alertView show];
            return;
        }
        
        if([message responseCode] == LOGIN_SUCCESS) {
            self->userDataToPass = [message dict];
            
            //Save Username and Password to keychain for next time
            NSArray *accounts = [SSKeychain accountsForService:TRADE_ROOM_KEY_IDENT];
            
            //We only want to save one account/password combination
            if([accounts count] != 0) {
                NSString *firstUsername = [[accounts objectAtIndex:0] valueForKey:@"acct"];
                
                //Different account stored in keychain (destroy current one)
                if([email caseInsensitiveCompare:firstUsername] != NSOrderedSame) {
                    //Destroy with query
                    SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
                    
                    query.service = TRADE_ROOM_KEY_IDENT;
                    query.account = firstUsername;
                    
                    [query deleteItem:nil];                    
                }
                //Save updated information
                NSError *error;
                [SSKeychain setPassword:password forService:TRADE_ROOM_KEY_IDENT account:email error:&error];
            }
            else {
                //Nothing stored yet, so save
                [SSKeychain setPassword:password forService:TRADE_ROOM_KEY_IDENT account:email];
            }
            [self postLoginSetup];
        }
        else if([message responseCode] == LOGIN_FAILED_USERNAME_PASS_COMBO) {
            // Invalid Username/Password combination
            
            //TODO: Localize (but altogether remove UIAlertView with a more user friends interface response
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"InvalidUsernamePasswordTitle", nil) message:NSLocalizedString(@"InvalidUsernamePasswordMessage", nil) delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            
            [alertView show];
        }
        else {
            //Unknown Error
        }
    }];
    
}

/*
    Handle setup after a successful login
 */
-(void) postLoginSetup {
    //Retrieve resources
    [self->resources updateResources];
    
    //Basic Auth stuff. 
    //NSString *authStr = [NSString stringWithFormat:@"%@:%@", USER, AUTHENTICATION];
    //NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    //NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    //manager.username = USER;
    //manager.password = AUTHENTICATION;
    //[manager setValue:authValue forHTTPHeaderField:@"authorization"];
    
    //Give SDWebImage the Jsession cookie we should have just received
    //Add custom header to SDWebImage Downloader for authentication purposes
    SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSHTTPCookie *sessionCookie;
    for(NSHTTPCookie *cookie in [storage cookies]) {
        if([[cookie name] isEqualToString:@"JSESSIONID"]) {
            sessionCookie = cookie;
        }
    }
    NSString *value = [NSString stringWithFormat:@"%@=%@", [sessionCookie name], [sessionCookie value]];
    [manager setValue:value forHTTPHeaderField:@"cookie"];
    /////////
    
    //Start the location handler
    [[Location getInstance] startLocation];
    
    //Call segue
    [[User getInstance] updateModelWithDict:self->userDataToPass];
    [self performSegueWithIdentifier:LOGIN_TO_LANDING_SEGUE sender:self->_loginButton];
    
    //REMEBER TO REMOVE!!!!
    NSLog(@"%@", [[User getInstance] description]);
}

- (IBAction)registerSubmit:(id)sender {
    RegisterView *registerView = [[NSBundle mainBundle] loadNibNamed:@"RegisterViewPopup" owner:self options:nil][0];
    registerView.delegate = self;
    modalView = [[RNBlurModalView alloc] initWithParentView:self.view view:registerView];
    [modalView hideCloseButton:YES];
    [modalView show];
}

#pragma mark - RegisterView Delegate Methods
- (void) registerSubmittedWithUsername:(NSString *)username Email:(NSString *)email Password:(NSString *)password {
    [modalView hide];
    if(username == nil || password == nil || email == nil) {
        RNBlurModalView *errorView = [[RNBlurModalView alloc] initWithTitle:@"Form Not Completed" message:@"In order to register for Trade Room, you must fille all fields provided on the Register page"];
        [errorView show];
    }
    
    [self->accountConsumer requestRegistration:username Email:email FirstName:nil LastName:nil Password:password Completion:^(ServiceMessage *message) {
        
        if(message == nil) {
            //Connection Error
            NSLog(@"Connection Error");
            return;
        }
        
        //Handle Server Response
        if([message responseCode] == REGISTER_SUCCESS) {
            RNBlurModalView *successView = [[RNBlurModalView alloc] initWithTitle:@"Success" message:@"Congratualtions! You have successfully registered for Trade Room."];
            [successView show];
            [modalView hide];
            _emailField.text = username;
            _passwordField.text = password;
            [self loginSubmit:nil];
        }
        else if([message responseCode] == REGISTER_FAIL_DUP_EMAIL) {
            RNBlurModalView *errorView = [[RNBlurModalView alloc] initWithTitle:@"Registration Failed" message:@"A user with that email address already exists"];
            [errorView show];
        }
        else if([message responseCode] == REGISTER_FAIL_DUP_USERNAME) {
            RNBlurModalView *errorView = [[RNBlurModalView alloc] initWithTitle:@"Registration Failed" message:@"A User with that username already exists. Please choose another one."];
            [errorView show];
        }
        else if([message responseCode] == REGISTER_FAIL_INVALID_FORM) {
            RNBlurModalView *errorView = [[RNBlurModalView alloc] initWithTitle:@"Registration Failed" message:@"Invalid Entries. Did you use a valid email? Is your username and password longer than four characters?"];
            [errorView show];
        }
        else {
            //Unknown Error
        }
    }];

}

- (void) signUpWithFacebookPressed {
    [modalView hide];
    [[FBHandler sharedInstance] signupWithFacebook];
}

- (void) closeBtnPressed {
    [modalView hide];
}

#pragma mark - FBHandler UI Delegate Methods

- (void) userLoggedIn:(NSDictionary*) userData {
    self->userDataToPass = userData;
    [self postLoginSetup];
}
- (void) userLoggedOut {
    while(self.navigationController.viewControllers[self.navigationController.viewControllers.count - 1] != self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [accountConsumer requestLogoutCompletion:nil];
}
- (void) showMessage:(NSString*) text WithTitle:(NSString*) title {
    RNBlurModalView *messageView = [[RNBlurModalView alloc] initWithTitle:title message:text];
    [messageView show];
}


#pragma mark - Text Field Delegate Methods

/*
 Handles transitioning between text fields
 */
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
        
    if(textField == self->_emailField) {
        [self->_passwordField becomeFirstResponder];
    }
    
    [textField resignFirstResponder];
    return YES;
}

@end
