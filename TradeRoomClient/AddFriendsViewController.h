//
//  AddFriendsViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/16/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserTableViewCell.h"

@interface AddFriendsViewController : UIViewController <UITableViewDelegate,
                                                            UITableViewDataSource,
                                                            UITextFieldDelegate,
                                                            UserCellDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)searchFieldFinished:(id)sender;
- (IBAction)backBtnPressed:(id)sender;

@end
