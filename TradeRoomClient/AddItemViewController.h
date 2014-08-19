//
//  AddItemViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/21/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
#import "TagsPopupView.h"
#import "DescriptionViewController.h"


@interface AddItemViewController : UIViewController <UITextFieldDelegate,
                                                        UIPickerViewDataSource,
                                                        UIPickerViewDelegate,
                                                        UIImagePickerControllerDelegate,
                                                        UINavigationControllerDelegate,
                                                        TagsPopupViewDelegate,
                                                        DescriptionDelegate> {
}

@property (weak, nonatomic) IBOutlet UIImageView *imageBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *countField;
@property (weak, nonatomic) IBOutlet UIButton *descriptionView;
@property (weak, nonatomic) IBOutlet UIButton *tagsBtn;
@property (weak, nonatomic) IBOutlet UIButton *conditionBtn;

@end
