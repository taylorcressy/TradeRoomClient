//
//  AddFriendsViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/16/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "AddFriendsViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <RNBlurModalView.h>

#import "FriendsConsumer.h"
#import "SearchConsumer.h"
#import "FBHandler.h"

#define USER_CELL_IDENT @"UserCell"
#define HEIGHT_OF_USER_CELL 100.0f
#define HEIGHT_OF_HEADERS 20.0f;

@interface AddFriendsViewController () {
    FriendsConsumer *friendConsumer;
    SearchConsumer *searchConsumer;
    
    NSMutableArray *searchResultFriends;
    NSMutableArray *recommendedFriends;
}

@end

@implementation AddFriendsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        friendConsumer = [[FriendsConsumer alloc] init];
        searchConsumer = [[SearchConsumer alloc] init];
        recommendedFriends = [[NSMutableArray alloc] init];
        searchResultFriends = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        friendConsumer = [[FriendsConsumer alloc] init];
        searchConsumer = [[SearchConsumer alloc] init];
        recommendedFriends = [[NSMutableArray alloc] init];
        searchResultFriends = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:USER_CELL_IDENT];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self requestFacebookData];
    [_searchField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) requestFacebookData {
    if(((FBHandler*)[FBHandler sharedInstance]).friendsList != nil &&
        ((FBHandler*)[FBHandler sharedInstance]).friendsList.count != 0) {
        
        [ProcessingRequestOverlay showOverlay];
        [friendConsumer requestAccountDetailsOfFacebookUsers:[FBHandler sharedInstance] Completion:^(ServiceMessage *msg) {
            [ProcessingRequestOverlay hideOverlay];
            if([msg responseCode] == 800)
            {
                recommendedFriends = [NSMutableArray arrayWithArray:[msg array]];
            }
        }];
        
    }
}

#pragma mark - UI Actions
- (IBAction)searchFieldFinished:(id)sender {
    [searchResultFriends removeAllObjects];
    [ProcessingRequestOverlay showOverlay];
    NSString *searchCriteria = [self->_searchField text];
    [searchConsumer searchForUser:searchCriteria
                       Completion:^(ServiceMessage *msg) {
                           if([msg responseCode] == 400) {
                               for(NSString *jsonString in [msg array]) {
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                                   [searchResultFriends addObject:[User dictionaryToUser:dict]];
                               }
                               [_tableView reloadData];
                           }
                           [ProcessingRequestOverlay hideOverlay];
    }];
}

- (IBAction)backBtnPressed:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate Methods
#define SEARCH_SECTION 0
#define RECOMMEND_SECTION 1

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT_OF_USER_CELL;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(numberOfSections == 2) {
        if(section == SEARCH_SECTION)
            return 0.0f;
        else if(section == RECOMMEND_SECTION)
            return HEIGHT_OF_HEADERS;
    }
    if(numberOfSections == 1) {
        if(searchResultFriends.count != 0)
            return 0.0f;
        else
            return HEIGHT_OF_HEADERS;
    }
    return 0.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     Handle UI Event
     */
}



#pragma mark - UITableView Datasource Methods

NSInteger numberOfSections;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(numberOfSections == 2) { //Boths sections are populated
        switch(section) {
            case SEARCH_SECTION: {
                return searchResultFriends.count;
            }
            case RECOMMEND_SECTION: {
                return recommendedFriends.count;
            }
        }
    }
    else if(numberOfSections == 1) {
        if(searchResultFriends.count != 0) {
            //Only have search results
            return searchResultFriends.count;
        }
        else {
            //Only have recommendations
            return recommendedFriends.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if((numberOfSections == 2 && indexPath.section == SEARCH_SECTION) || (numberOfSections == 1 && searchResultFriends.count != 0)) {
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:USER_CELL_IDENT];
        if(cell == nil)
            cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:USER_CELL_IDENT];
    
        User *user = [searchResultFriends objectAtIndex:indexPath.row];
        cell.user = user;
        cell.delegate = self;
        if(user.facebookId != nil) {
            NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user.facebookId];
            [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"no-profile-picture.png"]];
        }
    
        [cell.usernameLabel setText:user.username];
        [cell.numberOfTradesLabel setText:[NSString stringWithFormat:@"%d Successful Trades", user.tradeRoomMeta.numberOfSuccessfulTrades]];
        return cell;
    }
    else    //This will be the recommended friends section
        return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    numberOfSections = 0;
    if(searchResultFriends.count != 0)
        numberOfSections++;
    if(recommendedFriends.count != 0)
        numberOfSections++;
    return numberOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(numberOfSections == 2) {
        if(section == SEARCH_SECTION)
            return nil;
        else if(section == RECOMMEND_SECTION)
            return @"Recommended Friends";
    }
    if(numberOfSections == 1) {
        if(searchResultFriends.count != 0)
            return nil;
        else
            return @"Recommended Friends";
    }
    return nil;
}

#pragma mark - UITextField Delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UserTable Cell Delegate Method
- (void) addRequested:(User *)user {
    [self->friendConsumer requestSendFriendRequestTo:user.userId Completion:^(ServiceMessage *msg) {
        switch([msg responseCode]) {
            case 170: { //Accepted
                RNBlurModalView *modalView = [[RNBlurModalView alloc] initWithTitle:@"Friend Request Sent" message:@"Your Friend Request has been sent."];
                [modalView show];
                break;
            }
            case 171: { //No user
                break;
            }
            case 172: { //Friend Exists
                RNBlurModalView *modalView = [[RNBlurModalView alloc] initWithTitle:@"Already Friends" message:[NSString stringWithFormat:@"You are already friends with %@.", user.username]];
                [modalView show];
                break;
            }
            case 173: { //User is blocked (bi-directional block)
                RNBlurModalView *modalView = [[RNBlurModalView alloc] initWithTitle:@"Blocked Friend" message:[NSString stringWithFormat:@"Unable to send friend request to %@.", user.username]];
                [modalView show];
                break;
            }
            case 174: { //User already sent pending friend request
                RNBlurModalView *modalView = [[RNBlurModalView alloc] initWithTitle:@"Pending Friends" message:[NSString stringWithFormat:@"You already have a pending friend request with %@.", user.username]];
                [modalView show];
                break;
            }
        }
    }];
}

@end
