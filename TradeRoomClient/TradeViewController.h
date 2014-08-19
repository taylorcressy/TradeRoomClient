//
//  TradeViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/2/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeRoomItemCell.h"
#import "TradeRoomBarItemCell.h"

#define USER_TO_ITEM_SEGUE @"UserToItem"
#define OTHER_TO_SELF_TRADE_SEGUE @"SelfTradeViewSegue"
#define SELF_TO_TRADE_REQUEST_SETUP_SEGUE @""

@interface TradeViewController : UIViewController<UICollectionViewDelegate,
                                                    UICollectionViewDataSource,
                                                    UICollectionViewDelegateFlowLayout,
                                                    UIScrollViewDelegate,
                                                    TradeRoomItemCellDragDelegate,
                                                    TradeRoomBarItemDelegate> {
    UICollectionView *tradeBarCollection;
}

@property (strong, nonatomic) User *firstUser;
@property (strong, nonatomic) NSMutableArray *firstSetOfItems;  //The original trade views items. Only set on segue to second view
@property (strong, nonatomic) NSString *tradeRoomOwnerId;
@property (nonatomic) BOOL currentUserIsLoggedInUser;

//UI Properties
@property (weak, nonatomic) IBOutlet UICollectionView *userItemsCollection;
@property (weak, nonatomic) IBOutlet UILabel *userTitleLbl;
@property (weak, nonatomic) TradeRoomItem *initialItem;

//UI Actions
- (IBAction)tradeBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)submitTradePressed:(id)sender;

@end
