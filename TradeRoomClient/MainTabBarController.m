//
//  MainTabBarController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "MainTabBarController.h"


@interface MainTabBarController () {
}

@end

@implementation MainTabBarController

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        return self;
    }
    return nil;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*Ensure original images for UITabBar*/
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        for (UITabBarItem *tbi in self.tabBar.items) {
            tbi.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            tbi.image = [tbi.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
