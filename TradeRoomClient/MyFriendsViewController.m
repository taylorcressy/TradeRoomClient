//
//  MyFriendsViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/16/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <RNBlurModalView.h>

#import "MyFriendsViewController.h"

#import "UserTableViewCell.h"
#import "FriendRequest.h"
#import "FriendsConsumer.h"
#import "TradeViewController.h"

#define USER_CELL @"UserCell"
#define FRIEND_REQUEST_CELL @"FriendRequestCell"

#define USER_TO_TRADE_VIEW @"UserToTradeView"

#define HEIGHT_OF_HEADERS 30.0f
#define HEIGHT_OF_USER_CELL 100.0f

@interface MyFriendsViewController () {
    NSMutableArray *friendIds;
    NSMutableDictionary *friendDict;
    NSMutableArray *pendingIds;
    NSMutableDictionary *pending;
    
    NSInteger numberOfSections;
    
    SSPullToRefreshView *refreshView;
    
    User *user;
    
    FriendsConsumer *friendConsumer;
}
@end

@implementation MyFriendsViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        user = [User getInstance];
        friendConsumer = [[FriendsConsumer alloc] init];
        friendDict = [[NSMutableDictionary alloc] init];
        pending = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Setup pull to refresh view
    refreshView = [[SSPullToRefreshView alloc] initWithScrollView:_friendsView delegate:self];

    //Register he UITableViewCell
    [_friendsView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:USER_CELL];
    [_friendsView registerNib:[UINib nibWithNibName:@"FriendRequestTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:FRIEND_REQUEST_CELL];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupLists];
}

- (void) setupLists {
    //Retrieve all of the ids
    [friendIds removeAllObjects];
    [friendDict removeAllObjects];
    [pending removeAllObjects];
    [pendingIds removeAllObjects];
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    for(FriendRequest *request in user.friendRequests) {
        if([request.fromId isEqualToString:user.userId]) {
            [ids addObject:request.toId];
            if([request.status isEqualToString:FRIEND_REQUEST_ACCEPTED])
                [friendDict setObject:[NSNull null] forKey:request.toId];
        }
        else {
            [ids addObject:request.fromId];
            
            if([request.status isEqualToString:FRIEND_REQUEST_ACCEPTED])
                [friendDict setObject:[NSNull null] forKey:request.fromId];
            else
                [pending setObject:[NSNull null] forKey:request.fromId];
        }
    }
    
    [ProcessingRequestOverlay showOverlay];
    [self->friendConsumer requestAccountDetailsOfMultipleUsers:ids Completion:^(ServiceMessage *msg) {
        if(msg.responseCode == 800) {
            for(NSDictionary *nextUserDict in [msg array]) {
                User *nextUser = [User dictionaryToUser:nextUserDict];
                
                if([friendDict objectForKey:nextUser.userId] == [NSNull null])
                    [friendDict setObject:nextUser forKey:nextUser.userId];
                else if([pending objectForKey:nextUser.userId] == [NSNull null])
                    [pending setObject:nextUser forKey:nextUser.userId];
            }
            pendingIds = [NSMutableArray arrayWithArray:[pending allKeys]];
            friendIds = [NSMutableArray arrayWithArray:[friendDict allKeys]];
            [_friendsView reloadData];
        }
        
        [ProcessingRequestOverlay hideOverlay];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {

}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueName = [segue identifier];
    if([segueName isEqualToString:USER_TO_TRADE_VIEW]) {
        User *cellUser = (User*) sender;
        TradeViewController *tradeView = [segue destinationViewController];
        tradeView.tradeRoomOwnerId = cellUser.userId;
        tradeView.currentUserIsLoggedInUser = NO;
    }
}

#pragma mark - UITableView Delegate Methods
#define FRIEND_REQUEST_SECTION 0
#define FRIENDS_SECTION 1
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT_OF_USER_CELL;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEIGHT_OF_HEADERS;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isFriendSection;
    
    if(numberOfSections == 2)
    {
        if(indexPath.section == FRIEND_REQUEST_SECTION)
            isFriendSection = YES;
        else
            isFriendSection = NO;
    }
    else if(numberOfSections == 1)
    {
        if(friendIds.count != 0)
            isFriendSection = YES;
        else
            isFriendSection = NO;
    }
    
    if(isFriendSection) {
        UserTableViewCell *cell = (UserTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
        User *cellUser = [cell user];
        [self performSegueWithIdentifier:USER_TO_TRADE_VIEW sender:cellUser];
    }
}


#pragma mark - UITableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(numberOfSections == 2)
    {
        if(section == FRIEND_REQUEST_SECTION)
            return friendDict.count;
        else
            return pending.count;
    }
    else if(numberOfSections == 1)
    {
        if(pending.count != 0)
            return pending.count;
        else
            return friendDict.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL friendRequestSection;
    
    if(numberOfSections == 2) {
        if(indexPath.section == FRIEND_REQUEST_SECTION)
            friendRequestSection = TRUE;
        else
            friendRequestSection = FALSE;
    }
    else if(numberOfSections == 1) {
        if(pending.count != 0)
            friendRequestSection = TRUE;
        else
            friendRequestSection = FALSE;
    }
    
    if(friendRequestSection) {
        FriendRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FRIEND_REQUEST_CELL];
        
        if(cell == nil)
            cell = [[FriendRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FRIEND_REQUEST_CELL];
        NSString *userId = pendingIds[indexPath.row];
        User *nextUser = [pending objectForKey:userId];
        cell.delegate = self;
        cell.user = nextUser;
        [cell.usernameLbl setText:nextUser.username];
        
        if(nextUser.facebookId != nil) {
            NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", nextUser.facebookId];
            [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"no-profile-picture.png"]];
        }
        else
            [cell.profileImageView setImage:[UIImage imageNamed:@"no-profile-picture.png"]];
        
        return cell;
        
    }
    else {
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:USER_CELL];
    
        if(cell == nil)
            cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:USER_CELL];
        
        NSString *userId = friendIds[indexPath.row];
        User *nextUser = [friendDict objectForKey:userId];
        cell.user = nextUser;
        if(nextUser.facebookId != nil)
        {
            NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", nextUser.facebookId];
            [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"no-profile-picture.png"]];
        }
        else
            [cell.profileImage setImage:[UIImage imageNamed:@"no-profile-picture.png"]];
        
        [cell.usernameLabel setText:nextUser.username];
        [cell.numberOfTradesLabel setText:[NSString stringWithFormat:@"%d Successful Trades", nextUser.tradeRoomMeta.numberOfSuccessfulTrades]];
        [cell.addUserButton setHidden:YES];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    numberOfSections = 0;
    if(friendDict.count != 0)
        numberOfSections++;
    if(pending.count != 0)
        numberOfSections++;
    return numberOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(numberOfSections == 2) {
        if(section == FRIEND_REQUEST_SECTION)
            return @"Pending Friend Requests";
        else
            return @"Friends";
    }
    else if(numberOfSections == 1) {
        if(pending.count != 0)
            return @"Pending Friend Requests";
        else
            return @"Friends";
    }
    else return nil;
}

#pragma mark - FriendRequest Table View Cell Delegate Methods
- (void) acceptFriendRequest:(User *)theUser {
    [ProcessingRequestOverlay showOverlay];
    [friendConsumer requestRespondToFriendRequest:theUser.userId Status:FRIEND_REQUEST_ACCEPTED Completion:^(ServiceMessage *msg) {
        [ProcessingRequestOverlay hideOverlay];

        if(msg.responseCode != 175) {
            RNBlurModalView *modalView = [[RNBlurModalView alloc] initWithTitle:@"Error" message:[msg localizedMessage]];
            [modalView show];
        }
        else {
            [(User*)[User getInstance] updateModelWithConsumerCompletion:^{
                [self->pendingIds removeObject:theUser.userId];
                [self->pending removeObjectForKey:theUser.userId];
                [self->friendIds addObject:theUser.userId];
                [self->friendDict setObject:theUser forKey:theUser.userId];
                [self.friendsView reloadData];
            }];
        }
    }];
}

- (void) denyFriendRequest:(User *)theUser {
    [ProcessingRequestOverlay showOverlay];
    [friendConsumer requestRespondToFriendRequest:theUser.userId Status:FRIEND_REQUEST_DENINED Completion:^(ServiceMessage *msg) {
        [ProcessingRequestOverlay hideOverlay];
        if(msg.responseCode != 175) {
            RNBlurModalView *modalView = [[RNBlurModalView alloc] initWithTitle:@"Error" message:[msg localizedMessage]];
            [modalView show];
        }
        else {
            [(User*)[User getInstance] updateModelWithConsumerCompletion:^{
                [self->pendingIds removeObject:theUser.userId];
                [self->pending removeObjectForKey:theUser.userId];
                [self.friendsView reloadData];
            }];
        }
    }];
}

- (void) blockFriendRequest:(User *)theUser {
    [ProcessingRequestOverlay showOverlay];
    [friendConsumer requestRespondToFriendRequest:theUser.userId Status:FRIEND_REQUEST_BLOCKED Completion:^(ServiceMessage *msg) {
        [ProcessingRequestOverlay hideOverlay];
        
        if(msg.responseCode != 175) {
            RNBlurModalView *modalView = [[RNBlurModalView alloc] initWithTitle:@"Error" message:[msg localizedMessage]];
            [modalView show];
        }
        else {
            [(User*)[User getInstance] updateModelWithConsumerCompletion:^{
                [self->pendingIds removeObject:theUser.userId];
                [self->pending removeObjectForKey:theUser.userId];
                [self.friendsView reloadData];
            }];
        }
    }];
}

#pragma mark - SSPullToRefresh Delegate Methods
- (void) pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    //Refresh View Started Loading
    //TODO: Implement
}

@end
