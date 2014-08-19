//
//  TRPageViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/25/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRPageViewController : UIViewController<UIScrollViewDelegate,
                                                    UIImagePickerControllerDelegate,
                                                    UINavigationControllerDelegate> {
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *imageIDs;
@property (strong, nonatomic) TradeRoomItem *item;

- (IBAction)addImageToTradeItem:(id)sender;
- (IBAction)deleteImageFromTradeItem:(id)sender;

@end
