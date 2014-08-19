//
//  LoadingScreenViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "LoadingScreenViewController.h"

@interface LoadingScreenViewController () {
    
    CGRect topArrowCurrentLocation;
    CGRect bottomArrowCurrentLocation;
    CGRect topTextCurrentLocation;
    CGRect bottomTextCurrentLocation;
}

@property (weak, nonatomic) IBOutlet UIImageView *topArrow;
@property (weak, nonatomic) IBOutlet UIImageView *bottomArrow;
@property (weak, nonatomic) IBOutlet UIImageView *topText;
@property (weak, nonatomic) IBOutlet UIImageView *bottomText;

@end

@implementation LoadingScreenViewController

@synthesize topArrow, bottomArrow, topText, bottomText;

-(void) viewDidLayoutSubviews {
    //Move Both Arrow off the screen
    //Grab the two arrows current location
    self->topArrowCurrentLocation = [self->topArrow frame];
    self->bottomArrowCurrentLocation = [self->bottomArrow frame];
    self->topTextCurrentLocation = [self->topText frame];
    self->bottomTextCurrentLocation = [self->bottomText frame];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    [self->topArrow setFrame: CGRectMake(screenWidth, [self->topArrow frame].origin.y, [self->topArrow frame].size.width, [self->topArrow frame].size.height)];
    [self->topText setFrame:CGRectMake(screenWidth + [self->topArrow frame].size.width, [self->topText frame].origin.y, [self->topText frame].size.width, [self->topText frame].size.height)];
    
    [self->bottomArrow setFrame:CGRectMake(0 - [self->bottomArrow frame].size.width,
                                           [self->bottomArrow frame].origin.y,
                                           [self->bottomArrow frame].size.width,
                                           [self->bottomArrow frame].size.height)];
    [self->bottomText setFrame:CGRectMake(0 - [self->bottomText frame].size.width - [self->bottomArrow frame].size.width,
                                          [self->bottomText frame].origin.y,
                                          [self->bottomText frame].size.width,
                                          [self->bottomText frame].size.height)];
    //Animate the arrows in
    
    [UIView animateWithDuration:1.0 animations:^{
        self.topArrow.frame = topArrowCurrentLocation;
        self.bottomArrow.frame = bottomArrowCurrentLocation;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.topText.frame = topTextCurrentLocation;
            self.bottomText.frame = bottomTextCurrentLocation;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(fireSegue) withObject:nil afterDelay:1.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }];
    }];
}

-(void) fireSegue {
    [self performSegueWithIdentifier:@"LoadingToLogin" sender:self];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
