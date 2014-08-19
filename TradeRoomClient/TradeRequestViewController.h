//
//  TradeRequestViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/11/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DescriptionViewController.h"

@interface TradeRequestViewController : UIViewController<UICollectionViewDataSource,
                                                            UICollectionViewDelegate,
                                                            UICollectionViewDelegateFlowLayout,
                                                            DescriptionDelegate> {
    
}

@property (strong, nonatomic) User *otherUser;
@property (strong, nonatomic) NSArray *fromItems;   /*Item data Not IDs*/
@property (strong, nonatomic) NSArray *toItems; /*Item data Not IDs*/

@property (weak, nonatomic) IBOutlet UICollectionView *displayRequestView;

- (IBAction)backBtnPressed:(id)sender;
- (IBAction)sendBtnPressed:(id)sender;
@end
