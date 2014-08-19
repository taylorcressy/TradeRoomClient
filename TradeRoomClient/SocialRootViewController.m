//
//  SocialRootViewController.m
//  TradeRoomClient
//
//  The Root View Controller for the primary view controllers within this category.
//  They are the Friends, Trade and (eventually) messages controller
//
//  Created by Taylor James Cressy on 8/13/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#define MY_FRIENDS_PAGE 0
#define TRADE_PAGE 1
#define CHAT_PAGE 2

#define SWAP_TO_ADD_FRIENDS @"SwapToAddFriends"
#define SWAP_EMBED_SEGUE @"SwapEmbedSegue"
#define SWAP_TO_FRIENDS @"SwapToMyFriends"
#define SWAP_TO_TRADE @"SwapToTrade"


#import "SocialRootViewController.h"

#import "MyFriendsViewController.h"


@implementation SwapViewController {
    NSString *currentSegueIdentifier;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self->currentSegueIdentifier = SWAP_TO_FRIENDS;
    [self performSegueWithIdentifier:self->currentSegueIdentifier sender:nil];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [self switchToFriendsPage];
}

- (void) switchToFriendsPage {
    [self performSegueWithIdentifier:SWAP_TO_FRIENDS sender:self];
}

- (void) switchToTradePage {
    [self performSegueWithIdentifier:SWAP_TO_TRADE sender:self];
}

- (void) switchToChatPage {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = [segue identifier];
    if ([segueName isEqualToString:SWAP_TO_FRIENDS])
    {
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:segue.destinationViewController];
        }
        else {
            [self addChildViewController:segue.destinationViewController];
            ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    else if ([segue.identifier isEqualToString:SWAP_TO_TRADE])
    {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:segue.destinationViewController];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    }];
}

- (void)swapViewControllers
{
    if([self->currentSegueIdentifier isEqualToString:SWAP_TO_FRIENDS])
        self->currentSegueIdentifier = SWAP_TO_TRADE;
    else if([self->currentSegueIdentifier isEqualToString:SWAP_TO_TRADE])
        self->currentSegueIdentifier = SWAP_TO_FRIENDS;
    [self performSegueWithIdentifier:self->currentSegueIdentifier sender:nil];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end

@interface SocialRootViewController () {
    
}

@end

@implementation SocialRootViewController {
    SwapViewController *swapController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainSocialSegmentControl.selectedSegmentIndex = 0;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueName = [segue identifier];
    if([segueName isEqualToString:SWAP_EMBED_SEGUE]) {
        swapController = [segue destinationViewController];
    }
}

#pragma mark - UI Controls

- (IBAction)mainSocialSegmentControlChanged:(id)sender {
    switch(_mainSocialSegmentControl.selectedSegmentIndex) {
        case MY_FRIENDS_PAGE: {
            [swapController switchToFriendsPage];
            break;
        }
        case TRADE_PAGE: {
            [swapController switchToTradePage];
            break;
        }
        case CHAT_PAGE: {
            [swapController switchToChatPage];
            break;
        }
    }
}

- (IBAction)addFriendsBtnTouched:(id)sender {
    [self performSegueWithIdentifier:SWAP_TO_ADD_FRIENDS sender:self];
}

@end
