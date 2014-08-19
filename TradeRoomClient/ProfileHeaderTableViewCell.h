//
//  ProfileHeaderTableViewCell.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/1/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderTableViewCell : UITableViewCell {
    
}
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerThreeLabel;
@property (weak, nonatomic) IBOutlet UIView *customizedBackgroundView;

@end
