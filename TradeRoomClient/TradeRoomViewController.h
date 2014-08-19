//
//  TradeRoomViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/15/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SSPullToRefresh.h>

@interface TradeRoomViewController : UIViewController <UICollectionViewDataSource,
                                                            UICollectionViewDelegate,
                                                            UICollectionViewDelegateFlowLayout,
                                                            SSPullToRefreshViewDelegate> {
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;
@property (weak, nonatomic) IBOutlet UIView *topPanel;


@end
