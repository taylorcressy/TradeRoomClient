//
//  ProfileViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProfileFieldTableViewCell.h"


@interface ProfileViewController : UIViewController <UITextFieldDelegate,
                                                        UITableViewDelegate,
                                                        UITableViewDataSource,
                                                        ProfileFieldTableViewCellDelegate>{
    
}



@end
