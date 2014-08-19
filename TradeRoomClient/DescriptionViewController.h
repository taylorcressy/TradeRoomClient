//
//  DescriptionViewController.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/27/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DescriptionDelegate <NSObject>

@required
-(void) descriptionSaved:(NSString*) desc;

@end

@interface DescriptionViewController : UIViewController

@property (strong, nonatomic) NSString *currentText;
@property (weak, nonatomic) id<DescriptionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItemRef;


@end
