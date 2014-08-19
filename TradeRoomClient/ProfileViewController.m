//
//  ProfileViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <RNBlurModalView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProfileViewController.h"
#import "FBHandler.h"

#import "AccountCredentialsConsumer.h"

#import "ProfileHeaderTableViewCell.h"
#import "ProfileButtonTableViewCell.h"

#import "ProcessingRequestOverlay.h"


#define UPDATE_PREF_SUCCESS 130
#define UPDATE_PREF_FAIL_DATE_INVALID 131
#define UPDATE_PREF_FAIL_INVALID_FORM 132

#define UPDATE_EMAIL_SUCCESS 270
#define UPDATE_EMAIL_FAIL_INVALID_EMAIL 271
#define UPDATE_EMAIL_FAIL_DUPLICATE_EMAIL 272

#define PROFILE_TO_PICKUP_SEGUE @"profileToPickupSegue"
#define PROFILE_TO_PREFERRED_SEGUE @"profileToPreferredSegue"

@interface ProfileViewController() {
    User *user;
    
    NSArray *cellContents;  //Array of NSStrings for content labels
    UITextField *currentTextField;
    CGFloat distanceToSetPoint;
    __weak IBOutlet UITableView *mainTableView;
    
    AccountCredentialsConsumer *consumer;
    
    BOOL userUpdatedEmailAddress;
    BOOL userUpdatedAccountPreferences;
    
    NSString *emailStatusMessage;
    NSString *accountStatusMessage;
}
@end

@implementation ProfileViewController

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        self->consumer = [[AccountCredentialsConsumer alloc] init];
        self->user = [User getInstance];
        self->userUpdatedAccountPreferences = NO;
        self->userUpdatedEmailAddress = NO;
        
        return self;
    }
    return nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *dobString, *firstName, *lastName, *pass;
    if(user.accountPreferences.firstName == nil)
        firstName = @"N/A";
    else
        firstName = user.accountPreferences.firstName;
    if(user.accountPreferences.lastName == nil)
        lastName = @"N/A";
    else
        lastName = user.accountPreferences.lastName;
    if(user.accountPreferences.dob == nil)
        dobString = @"N/A";
    else
        dobString = user.accountPreferences.dob;
    if(user.facebookId == nil)
        pass = @"●●●●●●●●";
    else
        pass = @"Logged in with FB";
    //Populate the cellContents array
    cellContents = @[
                     [NSMutableString stringWithString:user.email],
                     [NSMutableString stringWithString:pass],
                     [NSMutableString stringWithString:firstName],
                     [NSMutableString stringWithString:lastName],
                     [NSMutableString stringWithString:dobString]
                     ];
}
- (void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



 #pragma mark - Navigation

- (void) switchToAddressPage {
    [self performSegueWithIdentifier:PROFILE_TO_PICKUP_SEGUE sender:self];
}

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }



#pragma mark - TableView Delegate Methods

#define NUMBER_OF_SECTIONS 3

#define HEADER_SECTION 0
#define FIELD_SECTION 1
#define BUTTON_SECTION 2

#define NUMBER_OF_FIELDS 5
#define NUMBER_OF_BUTTON 2
/*
 Declare height of cells
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static CGFloat headerSectionHeight = 140.0f;
    static CGFloat fieldSectionHeight = 45.0f;
    static CGFloat buttonSectionHeight = 55.0f;
    
    
    switch(indexPath.section) {
        case HEADER_SECTION: {
            return headerSectionHeight;
        }
        case FIELD_SECTION: {
            return fieldSectionHeight;
        }
        case BUTTON_SECTION: {
            return buttonSectionHeight;
        }
        default: {
            return 0.0f;
        }
    }
}

/*
 Declare height for headers
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == HEADER_SECTION) {
        return 0.0f;
    }
    else if(section == FIELD_SECTION)
        return 20.0f;
    else if(section == BUTTON_SECTION)
        return 0;
    else
        return 0;
}


#pragma mark - TableView Datasource Methods

/*
 Number of sections
 */
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTIONS;
}

/*
 Number of rows in section
 */
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section)
    {
        case HEADER_SECTION: {
            return 1;
            break;
        }
        case FIELD_SECTION: {
            return NUMBER_OF_FIELDS;
        }
        case BUTTON_SECTION: {
            return NUMBER_OF_BUTTON;
        }
    }
    return 0;
}


/*
 Declare the cells
 */

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *headerCell = @"HeaderCell";
    static NSString *fieldCell = @"FieldCell";
    static NSString *buttonCell = @"ButtonCell";
    
    if(indexPath.section == HEADER_SECTION) {
        ProfileHeaderTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:headerCell];
        
        NSString *nameString = user.username;
        NSString *tradeCountString = [NSString stringWithFormat:@"Trades Completed: %d",
                                      user.tradeRoomMeta.numberOfSuccessfulTrades];
        NSString *dateJoinedString = [NSString stringWithFormat:@"Member Since: %@", user.dateJoined];
        
        if(user.facebookId != nil) {
            NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user.facebookId];
            [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:url]];
        }
        
        [[cell headerOneLabel] setText:nameString];
        [[cell headerTwoLabel] setText:tradeCountString];
        [[cell headerThreeLabel] setText:dateJoinedString];
        return cell;
    }
    else if(indexPath.section == FIELD_SECTION) {
        ProfileFieldTableViewCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:fieldCell];
        
        cell.delegate = self;
        cell.editField.delegate = self;
        cell.editField.tag = indexPath.row;
        
        if(indexPath.row == (NUMBER_OF_FIELDS - 1)) {
            [cell setTag:BOTTOM_CELL];
            
            cell.dateCell = YES;
            
            [cell.categoryLabel setText:@"Birth Date: "];
            
            cell.editField.placeholder = [self->cellContents objectAtIndex:indexPath.row];
        }
        else if(indexPath.row == 0) {
            [cell setTag:TOP_CELL];
            
            [cell.categoryLabel setText:@"Email: "];
            cell.editField.placeholder =  [self->cellContents objectAtIndex:indexPath.row];
        }
        else {
            [cell setTag:MIDDLE_CELL];
            
            if(indexPath.row == 1) {
                cell.passwordCell = YES;
                [cell.categoryLabel setText:@"Password: "];
                cell.editField.placeholder = [self->cellContents objectAtIndex:indexPath.row];
            }
            else if(indexPath.row == 2) {
                [cell.categoryLabel setText:@"First Name: "];
                cell.editField.placeholder = [self->cellContents objectAtIndex:indexPath.row];
            }
            else if(indexPath.row == 3) {
                [cell.categoryLabel setText:@"Last Name: "];
                cell.editField.placeholder = [self->cellContents objectAtIndex:indexPath.row];
            }
        }
        return cell;
    }
    else if(indexPath.section == BUTTON_SECTION) {
        ProfileButtonTableViewCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:buttonCell];
        
        if(indexPath.row == 0) {
            [cell.mainButton setTitle:@"Set Home Address" forState:UIControlStateNormal];
            [cell.mainButton addTarget:self action:@selector(switchToAddressPage) forControlEvents:UIControlEventTouchDown];
        }
        else if(indexPath.row == 1) {
            [cell.mainButton setTitle:@"Logout" forState:UIControlStateNormal];
            [cell.mainButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
            cell.backgroundColor = [UIColor redColor];
            [cell.mainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        return cell;
    }
    else return nil;    //Should NOT reach here
}


- (void) logout:(id) sender {
    if(user.facebookId != nil)
        [FBSession.activeSession closeAndClearTokenInformation];
    else {
        [consumer requestLogoutCompletion:^(ServiceMessage *msg) {
        
            NSArray *array = [self.navigationController viewControllers];
        
            [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
        }];
    }
}

#pragma mark - ProfileFieldTableViewCellDelegate Methods

-(void) contentChanged:(NSString *)newContent Cell:(id)cell {
    CGPoint cellPosition = [cell convertPoint:CGPointZero toView:self->mainTableView];
    NSIndexPath *indexPath = [self->mainTableView indexPathForRowAtPoint:cellPosition];
    
    if([newContent compare:[self->cellContents objectAtIndex:indexPath.row]] != 0) {
        
        if(indexPath.row == 0)
            self->userUpdatedEmailAddress = YES;
        else
            self->userUpdatedAccountPreferences = YES;
    }
    
    [[self->cellContents objectAtIndex:indexPath.row] setString:newContent];
}


#pragma mark - Keyboard Handling Methods


/*
 Keyboad will show, act accordingly
 */
-(void) keyboardWillShow:(NSNotification*) notification {
    static CGFloat verticalPoint = 150.0f;
    
    //Increase content area size for scrolling purposes
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGSize current = [self->mainTableView contentSize];
    [self->mainTableView setContentSize:CGSizeMake(current.width, current.height + keyboardFrameBeginRect.size.height)];
    
    
    CGPoint pointOfTextField = [self->currentTextField.superview convertPoint:self->currentTextField.frame.origin toView:nil];
    
    distanceToSetPoint = verticalPoint - pointOfTextField.y;
    if(distanceToSetPoint > 0)
        return;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(0, (self.view.frame.origin.y + distanceToSetPoint), 320, 480);
    }];
}

-(void) keyboardWillHide:(NSNotification*) notification {
    if(distanceToSetPoint > 0)
        return;
    
    //Reduce content area size to original size
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    CGSize current = [self->mainTableView contentSize];
    [self->mainTableView setContentSize:CGSizeMake(current.width, current.height - keyboardFrameBeginRect.size.height)];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.origin.y - distanceToSetPoint, 320, 480);
    }];
}


-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    self->currentTextField = textField;
    return YES;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    if([textField text].length != 0) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:textField.tag inSection:FIELD_SECTION];
        UITableViewCell *cell = [mainTableView cellForRowAtIndexPath:path];
        
        [self contentChanged:textField.text Cell:cell];
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Server Request Methods

BOOL updateEmailSuccess;
BOOL updateAccountSuccess;
/*
 User Requested to submit updates to personal preferences
 */
- (IBAction)submitUpdatesPressed:(id)sender {
    //Grab Updated Email Address String
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:FIELD_SECTION];
    ProfileFieldTableViewCell *cell = (ProfileFieldTableViewCell*) [self->mainTableView cellForRowAtIndexPath:index];
    
    NSString *emailString = [cell editField].text;
    
    ProfileFieldTableViewCell *passCell, *firstNameCell, *lastNameCell, *dobCell;
    NSIndexPath *passPath, *firstNamePath, *lastNamePath, *dobPath;
    NSString *passStr, *firstNameStr, *lastNameStr, *dobStr;
    
    passPath = [NSIndexPath indexPathForRow:1 inSection:FIELD_SECTION];
    firstNamePath = [NSIndexPath indexPathForRow:2 inSection:FIELD_SECTION];
    lastNamePath = [NSIndexPath indexPathForRow:3 inSection:FIELD_SECTION];
    dobPath = [NSIndexPath indexPathForRow:4 inSection:FIELD_SECTION];
    
    passCell = (ProfileFieldTableViewCell*) [self->mainTableView cellForRowAtIndexPath:passPath];
    firstNameCell = (ProfileFieldTableViewCell*) [self->mainTableView cellForRowAtIndexPath:firstNamePath];
    lastNameCell = (ProfileFieldTableViewCell*) [self->mainTableView cellForRowAtIndexPath:lastNamePath];
    dobCell = (ProfileFieldTableViewCell*) [self->mainTableView cellForRowAtIndexPath:dobPath];
    
    passStr = passCell.editField.text;
    firstNameStr = firstNameCell.editField.text;
    lastNameStr = lastNameCell.editField.text;
    dobStr = dobCell.editField.text;
    
    if(passStr.length == 0 &&
       emailString.length == 0 &&
       firstNameStr.length == 0 &&
       lastNameStr.length == 0 &&
       dobStr.length == 0)
        return;
    
    [ProcessingRequestOverlay showOverlay];
    
    updateAccountSuccess = NO;
    updateEmailSuccess = NO;
    
    //NOTE: updating the user's email address and updating account preferences are separate web api calls.
    if(userUpdatedEmailAddress) {
        [self->consumer requestUpdateEmailAddress:emailString Completion:^(ServiceMessage *message) {
            
            if([message responseCode] == UPDATE_EMAIL_SUCCESS) {
                [user updateModelWithDict:message.dict];
                self->emailStatusMessage = @"Email Successfully Updated";
            }
            else if([message responseCode] == UPDATE_EMAIL_FAIL_INVALID_EMAIL) {
                self->emailStatusMessage = @"Invalid Email Address";
            }
            else if([message responseCode] == UPDATE_EMAIL_FAIL_DUPLICATE_EMAIL) {
                self->emailStatusMessage = @"Duplicate Email Address";
            }
            else {
                //Unknown error. should not get here
                NSLog(@"Unknown Error received from server");
            }

            self->userUpdatedEmailAddress = NO;
            [self showMessage];
        }];
    }
    
    if(userUpdatedAccountPreferences) {
        if([firstNameStr length] == 0)
            firstNameStr = nil;
        if([lastNameStr length] == 0)
            lastNameStr = nil;
        if([passStr length] == 0)
            passStr = nil;
        if([dobStr compare:@"N/A"] == 0)
            dobStr = nil;
        
        [self->consumer requestUpdateAccountPassword:passStr
                                           FirstName:firstNameStr
                                            LastName:lastNameStr
                                                 dob:dobStr
                                          Completion:^(ServiceMessage *message)
         {
             if([message responseCode] == UPDATE_PREF_SUCCESS) {
                 [user updateModelWithDict:message.dict];
                 
                 self->accountStatusMessage = @"Account Details Updated Successfully";
             }
             else if([message responseCode] == UPDATE_PREF_FAIL_DATE_INVALID) {
                 
                 self->accountStatusMessage = @"Invalid Date";
             }
             else if([message responseCode] == UPDATE_PREF_FAIL_INVALID_FORM) {
                                  
                 NSString *invalidField = [[message dict] valueForKey:INVALID_FIELD_KEY];
                 NSString *messageField = nil;
                 
                 if([invalidField compare:FIRST_NAME_KEY] == 0)
                     messageField = @"First Name";
                 else if([invalidField compare:LAST_NAME_KEY] == 0)
                     messageField = @"Last Name";
                 else if([invalidField compare:PASSWORD_KEY] == 0)
                     messageField = @"Password";
                 
                 self->accountStatusMessage = [NSString stringWithFormat:@"Invalid %@", messageField];
             }
             else {
                 //Uknown response
                 NSLog(@"Unknown Response: account");
             }
             
             self->userUpdatedAccountPreferences = NO;
             [self showMessage];
         }];
    }
}

- (void) showMessage {
    
    if(!userUpdatedAccountPreferences && !userUpdatedEmailAddress)
    {
        RNBlurModalView *msgAlert = [[RNBlurModalView alloc] initWithTitle:@"Profile Update"
                                                               message:self->accountStatusMessage];
        [msgAlert show];
        [ProcessingRequestOverlay hideOverlay];
    }
}
@end
