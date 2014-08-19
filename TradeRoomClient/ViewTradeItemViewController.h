//
//  ViewTradeItemViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/1/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeRoomItem.h"

@interface ViewTradeItemViewController : UIViewController {
    
}
//Passed from previous view controller
@property (strong, nonatomic) TradeRoomItem *item;
@property (strong, nonatomic) UIImage *imageToShow;

//UI Properties
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *conditionLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UIView *descriptionLblBackground;
@property (weak, nonatomic) IBOutlet UIButton *tagsBtn;
@property (weak, nonatomic) IBOutlet UIButton *tradeItemBtn;
@property (nonatomic) BOOL shouldHideTradeItemButton;

//UI Actions
- (IBAction)tagsBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)tradeItemPressed:(id)sender;

@end
