//
//  SearchViewController.h
//  TradeRoomClient
//
//  
//
//  Created by Taylor James Cressy on 7/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITextFieldDelegate,
                                                    UITableViewDelegate,
                                                    UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

- (IBAction)readyForSearch:(id)sender;

@end
