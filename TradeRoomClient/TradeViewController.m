//
//  TradeViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/2/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>

#import "TradeRoomBarItemCell.h"
#import "PropertyListLoader.h"

#import "TradeViewController.h"
#import "ViewTradeItemViewController.h"
#import "TradeRequestViewController.h"
#import "AccountCredentialsConsumer.h"
#import "FriendsConsumer.h"
#import "TradeItemConsumer.h"

#define TRADE_BAR_HEIGHT 66.0f  /*Should aim to be the same size as the top bar*/
#define OTHER_TO_REQUEST_SEGUE @"OtherToRequest"
#define TRADE_TO_ITEM_VIEW @"ViewTradeItem"

/*Dequeue identifiers*/
static NSString *barItemCell = @"BarItemCell";
static NSString *itemCell = @"ItemCell";

@interface TradeViewController () {
    //HTTP consumers
    AccountCredentialsConsumer *accConsumer;
    FriendsConsumer *friendConsumer;
    TradeItemConsumer *itemConsumer;
    
    //For URL handling
    NSDictionary *httpProperties;
    
    //The User associated with the trade room
    User *tradeRoomUser;
    
    /*
        Reference to the items. Note that we do not actually have to store the image data as
        this is cached for us. So simply recalling the URL will handle it
     */
    NSMutableArray *mainRoomItems;
    NSMutableArray *tradeBarItems;
    
    //The image displayed when there is no image for a particular item
    UIImage *noImageForItem;
    
    //The frame for the Trade Bar UICollectionView
    CGRect tradeBarRect;
    
    //The cell that is currently being dragged by the user.
    TradeRoomItemCell *cellBeingDragged;
    //Identifies whether or not the dragged cell is hovering over the trade bar cel
    BOOL cellIsInTradeBar;
    
}

@end

@implementation TradeViewController

#pragma mark - UIView init / delegate methods

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        tradeRoomUser = [[User alloc] init];
        accConsumer = [[AccountCredentialsConsumer alloc] init];
        friendConsumer = [[FriendsConsumer alloc] init];
        itemConsumer = [[TradeItemConsumer alloc] init];
        httpProperties = [PropertyListLoader httpProperties];
        mainRoomItems = [[NSMutableArray alloc] init];
        tradeBarItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
    [tradeBarCollection registerClass:[TradeRoomBarItemCell class] forCellWithReuseIdentifier:barItemCell];
}

- (void) setupUI {
    /*
     Setup Trade Bar UICollectionView. This needs to be done programatically because it needs to be added as a subview to
     the userItemCollection UIColelctionView. This is primarily because we need to be able to drag UICollectionViewCells from
     one collection to the other without having it be hidden
     */
    CGRect mainCollectionFrame = _userItemsCollection.frame;
    CGFloat heightOfTradeBar = TRADE_BAR_HEIGHT;
    tradeBarRect = CGRectMake(0, mainCollectionFrame.size.height - heightOfTradeBar, mainCollectionFrame.size.width, heightOfTradeBar);
    
    //Setup the Flow Layout
    UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [aFlowLayout setItemSize:CGSizeMake(mainCollectionFrame.size.width, heightOfTradeBar)];
    [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //Init and set the delegate to self
    tradeBarCollection = [[UICollectionView alloc] initWithFrame:tradeBarRect collectionViewLayout:aFlowLayout];
    tradeBarCollection.delegate = self;
    tradeBarCollection.dataSource = self;
    tradeBarCollection.backgroundColor = [UIColor colorWithRed:88.0f/255.0f green:88.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
    [[tradeBarCollection layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    
    //Set insets so that the content ends before the trade bar UICollectionView
    UIEdgeInsets userItemsInsets = UIEdgeInsetsMake(0, 0, heightOfTradeBar, 0);
    [_userItemsCollection addSubview:tradeBarCollection];
    [_userItemsCollection setContentInset:userItemsInsets];
    
    //Always want a bouncing effect
    _userItemsCollection.alwaysBounceVertical = YES;
    tradeBarCollection.alwaysBounceHorizontal = YES;
    
    //Font Label Resize
    _userTitleLbl.adjustsFontSizeToFitWidth = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if(_tradeRoomOwnerId == nil)
        [NSException raise:@"Null Values" format:@"_tradeRoomOwnerId was null in viewWillAppear (TradeViewController)"];
    
    noImageForItem = [UIImage imageNamed:@"NoImageForItem.png"];
    
    //if we have already loaded this user bail out
    if([tradeRoomUser.userId isEqualToString:_tradeRoomOwnerId])
        return;
    
    [ProcessingRequestOverlay showOverlay];
    if(!_currentUserIsLoggedInUser) {
        [friendConsumer requestAccountDetailsOfUser:_tradeRoomOwnerId Completion:^(ServiceMessage *msg) {
            if([msg responseCode] == 500) { //Success
                [tradeRoomUser updateModelWithDict:[msg dict]];
                [itemConsumer requestRetrieveItemsFromList:tradeRoomUser.tradeRoomMeta.itemIds Completion:^(ServiceMessage *itemMsg) {
                    if([itemMsg responseCode] == 240) {
                        [tradeRoomUser updateItemsWithArray:[itemMsg array]];
                        [mainRoomItems addObjectsFromArray:tradeRoomUser.tradeRoomItems];
                        [_userTitleLbl setText:[NSString stringWithFormat:@"%@'s Trade Room", tradeRoomUser.username]];
                        
                        //Swap the item that brought us to this view.
                        //This way, it will be the first cell so we can ensure the animation.
                        if(_initialItem != nil) {
                            [mainRoomItems removeObject:_initialItem];
                            [mainRoomItems insertObject:_initialItem atIndex:0];
                        }
                        
                        //Then reload
                        [_userItemsCollection reloadData];
                        
                        //Then animate the first index
                        if(_initialItem != nil) {
                            [_userItemsCollection layoutIfNeeded];
                            [self animateFirstCell];
                        }
                    }
                    [ProcessingRequestOverlay hideOverlay];
                }];
            }
            else {
                [ProcessingRequestOverlay hideOverlay];
            }
        }];
    }
    else {
        [_userTitleLbl setText:@"Your Trade Room"];
        [[User getInstance] updateTotalModelWithCompletion:^{
            tradeRoomUser = [User getInstance];
            [mainRoomItems addObjectsFromArray:[[User getInstance] tradeRoomItems]];
            [_userItemsCollection reloadData];
            [ProcessingRequestOverlay hideOverlay];
        }];
    }
}

/*
    Animate the first cell in the Main UICollectionView Cell. It is assumed that the datasource 
    has been organized to accomadate the initial item to be the first item.
 */
- (void) animateFirstCell {
    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
    TradeRoomBarItemCell *itemCell = (TradeRoomBarItemCell*) [_userItemsCollection cellForItemAtIndexPath:path];
    itemCell.layer.zPosition = 100;
    [UIView animateWithDuration:1.0 delay:0.5 options:0 animations:^{
        itemCell.center = tradeBarCollection.center;
    } completion:^(BOOL finished) {
        TradeRoomItem *itemReferenced = itemCell.item;
        itemCell.layer.zPosition = 0;
        [mainRoomItems removeObject:itemReferenced];
        [tradeBarItems addObject:itemReferenced];
        cellBeingDragged = nil;
        [tradeBarCollection reloadData];
        [_userItemsCollection reloadData];
    }];
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
    if([[segue identifier] isEqualToString:OTHER_TO_SELF_TRADE_SEGUE]) {
        //Go to next trade view
        TradeViewController *userTradeView = [segue destinationViewController];
        userTradeView.currentUserIsLoggedInUser = YES;  //Very important
        //Never will set an initial item for currentUserLoggedIn (Probably)
        userTradeView.tradeRoomOwnerId = [(User*)[User getInstance] userId];
        userTradeView.firstSetOfItems = [[NSMutableArray alloc] initWithArray:tradeBarItems];
        userTradeView.firstUser = tradeRoomUser;
    }
    else if([[segue identifier] isEqualToString:OTHER_TO_REQUEST_SEGUE]) {
        TradeRequestViewController *tradeRequestController = [segue destinationViewController];
        tradeRequestController.fromItems = tradeBarItems;
        tradeRequestController.toItems = _firstSetOfItems;
        tradeRequestController.otherUser = _firstUser;
    }
    else if([[segue identifier] isEqualToString:TRADE_TO_ITEM_VIEW]) {
        ViewTradeItemViewController *viewItem = [segue destinationViewController];
        TradeRoomItemCell *itemCell = (TradeRoomItemCell *) sender;
        viewItem.item = itemCell.item;
        viewItem.imageToShow = itemCell.itemImage.image;
        viewItem.shouldHideTradeItemButton = YES;
    }
}

#pragma mark - UICollectionView Delegate Flow Layout Methods

// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == _userItemsCollection) {
        CGSize mElementSize = CGSizeMake(95, 95 + LABEL_PADDING);
        return mElementSize;
    }
    else {
        CGSize mElementSize = CGSizeMake(44, 44);
        return mElementSize;
    }
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(collectionView == _userItemsCollection)
        return 5.0f;
    else
        return 50.0f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(collectionView == _userItemsCollection)
        return 5.0f;
    else
        return 15.0f;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0f, 10.0f, 0, 10.0f);
}

#pragma mark - UICollectionView Datasource Methods

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;   //Going to be one for both collection views
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _userItemsCollection) {
        return mainRoomItems.count;
    }
    else
        return tradeBarItems.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _userItemsCollection) {
        //Handle main collection
        TradeRoomItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCell forIndexPath:indexPath];
        cell.itemImage.contentMode = UIViewContentModeScaleAspectFill;
        cell.itemImage.clipsToBounds = YES;
        cell.referencedView = self.view;
        cell.delegate = self;
        [cell enableGesturesAndShouldDrag:YES];
        
        //Active image
        if([mainRoomItems[indexPath.row] imageIds].count > 0) {
            NSString *url = [NSString stringWithFormat:@"http://%@:%@%@?imageId=%@",
                             [self->httpProperties objectForKey:SERVER_ADDR_KEY],
                             [self->httpProperties objectForKey:SERVER_PORT_KEY],
                             GET_IMAGE_BY_ID, [mainRoomItems[indexPath.row] imageIds][0]];
            
            [cell.itemImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:noImageForItem options:SDWebImageRetryFailed];
        }
        
        cell.item = mainRoomItems[indexPath.row];
        cell.itemName.text = [((TradeRoomItem*) mainRoomItems[indexPath.row]).name capitalizedString];
        
        return cell;
    }
    else {
        TradeRoomBarItemCell *barCell = [collectionView dequeueReusableCellWithReuseIdentifier:barItemCell forIndexPath:indexPath];
        if(barCell == nil)
            barCell = [[TradeRoomBarItemCell alloc] initWithFrame:CGRectMake(0, 0, 66, 66)];
        barCell.delegate = self;
        barCell.item = [tradeBarItems objectAtIndex:indexPath.row];
        NSString *url = [NSString stringWithFormat:@"http://%@:%@%@?imageId=%@",
                         [self->httpProperties objectForKey:SERVER_ADDR_KEY],
                         [self->httpProperties objectForKey:SERVER_PORT_KEY],
                         GET_IMAGE_BY_ID, [tradeBarItems[indexPath.row] imageIds][0]];
        
        [barCell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:noImageForItem options:SDWebImageRetryFailed];
        return barCell;
    }
}

#pragma mark - UIScrollView Delegate methods
//Adjust the tradebar view to appear static.
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    tradeBarCollection.frame = CGRectMake(0, tradeBarRect.origin.y + _userItemsCollection.bounds.origin.y, tradeBarRect.size.width, tradeBarRect.size.height);
}

#pragma mark - TradeRoomItemCellDrag Delegate Methods
- (void) cellTapped:(TradeRoomItem *)item {
    [self performSegueWithIdentifier:TRADE_TO_ITEM_VIEW sender:item];
}

- (void) currentCenter:(CGPoint)center OfCell:(TradeRoomItemCell *)cell {
    self->cellBeingDragged = cell;
    if(CGRectContainsPoint([self.view convertRect:tradeBarCollection.frame fromView:_userItemsCollection], center))
    {
        [[tradeBarCollection layer] setBorderWidth:2.0f];
        cellIsInTradeBar = YES;
    }
    else
    {
        [[tradeBarCollection layer] setBorderWidth:0.0f];
        cellIsInTradeBar = NO;
    }
}

- (BOOL) didFinishDragging {
    [[tradeBarCollection layer] setBorderWidth:0.0f];
    if(!cellIsInTradeBar)
        return YES;
    else {
        TradeRoomItem *itemReferenced = cellBeingDragged.item;
        [mainRoomItems removeObject:itemReferenced];
        [tradeBarItems addObject:itemReferenced];
        cellBeingDragged = nil; 
        [tradeBarCollection reloadData];
        [_userItemsCollection reloadData];
        return NO;
    }
}

#pragma mark - TradeRoomBarItemCell Delegate Methods
- (void) closePressed:(TradeRoomBarItemCell *)cell {
    TradeRoomItem *itemReferenced = cell.item;
    [tradeBarItems removeObject:itemReferenced];
    [mainRoomItems addObject:itemReferenced];
    [tradeBarCollection reloadData];
    [_userItemsCollection reloadData];
}

#pragma mark - UI Actions
- (IBAction)tradeBtnPressed:(id)sender {
    [self performSegueWithIdentifier:OTHER_TO_SELF_TRADE_SEGUE sender:nil];
}

- (IBAction)backBtnPressed:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)submitTradePressed:(id)sender {
    [self performSegueWithIdentifier:OTHER_TO_REQUEST_SEGUE sender:nil];
}

@end
