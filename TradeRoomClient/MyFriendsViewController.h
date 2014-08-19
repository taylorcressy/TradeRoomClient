//
//  MyFriendsViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/16/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSPullToRefresh.h>

#import "FriendRequestTableViewCell.h"

@interface MyFriendsViewController : UIViewController <UITableViewDataSource,
                                                            UITableViewDelegate,
                                                            SSPullToRefreshViewDelegate,
                                                            FriendRequestCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *friendsView;

@end
