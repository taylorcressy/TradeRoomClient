//
//  ViewTradeItemViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/1/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "ViewTradeItemViewController.h"
#import "TagsPopupView.h"
#import "TradeViewController.h"
#import <RNBlurModalView.h>

#define TO_USER_ROOM_SEGUE @"ToUserRoom"

@interface ViewTradeItemViewController () {
    
}

@end

@implementation ViewTradeItemViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        _shouldHideTradeItemButton = NO;
    }
    return self;
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

    [self setupUI];
}

-(void) setupUI {
    [self->_imageBtn setClipsToBounds:YES];
    [[self->_imageBtn layer] setCornerRadius:15.0f];
    [[_nameLbl layer] setCornerRadius:15.0f];
    [[_countLbl layer] setCornerRadius:15.0f];
    
    _descriptionLbl.numberOfLines = 0;
    [_descriptionLbl sizeToFit];
    [[_descriptionLblBackground layer] setCornerRadius:15.0f];
    
    [[_conditionLbl layer] setCornerRadius:15.0f];
    [[_tagsBtn layer] setCornerRadius:15.0f];
    
    if (_shouldHideTradeItemButton)
        [_tradeItemBtn setHidden:YES];
    
    //Fix that pesky status bar layout issue
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_imageBtn setImage:_imageToShow forState:UIControlStateNormal];
    _nameLbl.text = _item.name;
    _countLbl.text = [NSString stringWithFormat:@"%d", _item.count];
    _descriptionLbl.text = _item.itemDescription;
    _conditionLbl.text = [[[_item.condition lowercaseString] capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    [_tagsBtn setTitle:[NSString stringWithFormat:@"%d Tags", _item.tags.count] forState:UIControlStateNormal];
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:TO_USER_ROOM_SEGUE]) {
        TradeViewController *tradeView = [segue destinationViewController];
        tradeView.tradeRoomOwnerId = [(TradeRoomItem*)sender ownerId];
        tradeView.initialItem = (TradeRoomItem*) sender;
        tradeView.currentUserIsLoggedInUser = NO;
    }
}


#pragma mark - UI Actions

- (IBAction)backBtnPressed:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)tagsBtnPressed:(id)sender {
    TagsPopupView *tagsPopup = [[[NSBundle mainBundle] loadNibNamed:@"TagsPopup" owner:self options:nil] objectAtIndex:0];
    tagsPopup.tagsList = [[NSMutableArray alloc] initWithArray:_item.tags];
    RNBlurModalView *modalView = [[RNBlurModalView alloc] initWithParentView:self.view view:tagsPopup];
    [modalView show];
}


- (IBAction)tradeItemPressed:(id)sender {
    [self performSegueWithIdentifier:TO_USER_ROOM_SEGUE sender:_item];
}
@end
