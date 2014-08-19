//
//  DescriptionViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/27/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@end

@implementation DescriptionViewController

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
    [self.descriptionText setText:self->_currentText];
    self.descriptionText.contentInset = UIEdgeInsetsMake(20.0f, 10.0f, 20.0f, 10.0f);
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated {
    [self->_descriptionText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)savePressed:(id)sender {
    [self->_delegate descriptionSaved:[self->_descriptionText text]];
    [self removeFromView];
}
- (IBAction)cancelPressed:(id)sender {
    [self removeFromView];
}

- (void) removeFromView {
    [self->_descriptionText resignFirstResponder];
    CGRect frame = self.view.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         [self.view removeFromSuperview];
                     }
     ];
}

@end
