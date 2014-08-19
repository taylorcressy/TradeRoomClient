//
//  TradeRoomBarItemCell.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/5/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RNBlurModalView.h>

@class TradeRoomBarItemCell;

@protocol TradeRoomBarItemDelegate <NSObject>

@required
- (void) closePressed:(TradeRoomBarItemCell*) cell;

@end

@interface TradeRoomBarItemCell : UICollectionViewCell {
    
}

/*Image of the item to represent*/
@property (nonatomic, strong) UIImageView *imageView;
/*Model of the item this cell represents*/
@property (nonatomic, strong) TradeRoomItem *item;
/*Delegate to inform when we close*/
@property (nonatomic, weak) id<TradeRoomBarItemDelegate> delegate;
/* Using RNCloseButton because I like it :) */
@property (nonatomic, strong) UIButton *closeButton;
@end
