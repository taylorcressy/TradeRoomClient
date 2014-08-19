//
//  TradeRoomItemCell.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/15/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TradeRoomItem.h"

#define LABEL_PADDING 35


@class TradeRoomItemCell;

@protocol TradeRoomItemCellDragDelegate <NSObject>

@required
- (void) currentCenter:(CGPoint) center OfCell:(TradeRoomItemCell*) cell;
- (BOOL) didFinishDragging; /*bool informs cell if it should animate back*/
- (void) cellTapped:(TradeRoomItemCell*) item;

@end

@interface TradeRoomItemCell : UICollectionViewCell {
    
}

@property (strong, nonatomic) TradeRoomItem *item;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemName;

@property (weak, nonatomic) UIView *referencedView;

@property (weak, nonatomic) id<TradeRoomItemCellDragDelegate> delegate;

- (void) enableGesturesAndShouldDrag:(BOOL) drag;

@end


