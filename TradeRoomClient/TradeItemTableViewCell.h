//
//  TradeItemTableViewCell.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeItemTableViewCell : UITableViewCell

@property (strong, nonatomic) TradeRoomItem *item;

@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UILabel *itemDescription;
@property (weak, nonatomic) IBOutlet UILabel *itemCondition;
@property (weak, nonatomic) IBOutlet UIView *itemContent;

@end
