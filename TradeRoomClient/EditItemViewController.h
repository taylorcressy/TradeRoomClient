//
//  EditItemViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/22/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TradeRoomItem.h"
#import "TagsPopupView.h"
#import "DescriptionViewController.h"

@interface EditItemViewController : UIViewController <UITextFieldDelegate,
                                                        UIPickerViewDataSource,
                                                        UIPickerViewDelegate,
                                                        UIImagePickerControllerDelegate,
                                                        UINavigationControllerDelegate,
                                                        UIAlertViewDelegate,
                                                        TagsPopupViewDelegate,
                                                        DescriptionDelegate>{
    
}

@property (strong, nonatomic) TradeRoomItem *itemToShow;
@property (strong, nonatomic) UIImage *imageToShow;
- (IBAction)deleteItem:(id)sender;

@end
