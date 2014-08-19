//
//  TagsPopupView.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/23/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagsPopupViewDelegate <NSObject>

@required
- (void) addedtag:(NSString*) tag;
- (void) removedTag:(NSInteger) tagIndex;

@optional
- (void) textFieldPressed;
- (void) closePressed;


@end

@interface TagsPopupView : UIView <UIGestureRecognizerDelegate> {
        
    __weak IBOutlet UIWebView *tagsview;
}

@property (weak, nonatomic) IBOutlet UITextField *tagField;
@property (strong, nonatomic) NSMutableArray *tagsList;
@property (weak, nonatomic) id<TagsPopupViewDelegate> delegate;

- (IBAction)AddTagTouched:(id)sender;
- (void) updateWebView;

@end
