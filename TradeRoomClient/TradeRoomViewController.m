//
//  TradeRoomViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/15/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "TradeRoomViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "AddItemViewController.h"
#import "EditItemViewController.h"

#import "TradeItemConsumer.h"
#import "TradeRoomItemCell.h"

#define ADD_ITEM_SEGUE @"AddItem"
#define EDIT_ITEM_SEGUE @"EditItem"

@interface TradeRoomViewController () {
    User *user;
    TradeItemConsumer *itemConsumer;
    
    UIImage *noImageForItem; //The Image used when the user did not choose an image for a trade item
    UIImage *noItemImage;
    SSPullToRefreshView * refreshView;
    
    NSDictionary *httpProperties;   //Needed for image grabbing (Pretty much the only time our service classes will not be used
    BOOL shouldClearCache;  // Should really only be used from edit item controller
    BOOL shouldClearModel;
    BOOL clearedFromLoad;

}

@end

@implementation TradeRoomViewController

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        user = [User getInstance];
        self->itemConsumer = [[TradeItemConsumer alloc] init];
        self->httpProperties = [PropertyListLoader httpProperties];
        self->shouldClearCache = YES;
        self->shouldClearModel = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Customize the count label
    
    [[_itemCountLabel layer] setCornerRadius:10.0f];
    [_itemCountLabel setText:@"? / ?"];
    [_itemCountLabel setTextColor:[UIColor whiteColor]];
    
    //Force full update on first load (or re-load if received memory warning and this was de-allocated)
    self->clearedFromLoad = YES;
    [self refreshCache:YES UpdateModel:YES ReloadCollection:NO];
    
    //Setup the pull to refresh view
    refreshView = [[SSPullToRefreshView alloc] initWithScrollView:self->_collectionView delegate:self];
    
    //Grab the images for reference
    self->noItemImage =  [UIImage imageNamed:@"TradeItemSlot.png"];
    self->noImageForItem = [UIImage imageNamed:@"NoImageForItem.png"];
    
    //Allow scrolling at all sizes
    [self->_collectionView setAlwaysBounceVertical:YES];
}

-(void) viewWillAppear:(BOOL)animated {
    if(!clearedFromLoad)
        [self refreshCache: shouldClearCache UpdateModel:shouldClearModel ReloadCollection:YES];
    clearedFromLoad = NO;
    [super viewWillAppear:YES];
}

- (void) delayRequestsOfImages:(BOOL) images Models:(BOOL) model {
    if(images) {
        [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME_GAP
                                         target:self
                                       selector:@selector(allowResetOfCache)
                                       userInfo:nil
                                        repeats:NO];
    }
    if(model) {
        [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME_GAP
                                         target:self
                                       selector:@selector(allowResetOfModel)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void) allowResetOfCache {
    self->shouldClearCache = YES;
}

- (void) allowResetOfModel {
    self->shouldClearModel = YES;
}

- (void) refreshCache:(BOOL) clearCache UpdateModel:(BOOL) updateModel ReloadCollection:(BOOL) reloadCollection{
    //Update our model
    if(clearCache) {
        /*This is a forced call to remove cache!!*/
        for(TradeRoomItem *item in user.tradeRoomItems) {
            if(item.imageIds.count > 0) {
                NSString *url = [NSString stringWithFormat:@"http://%@:%@%@?imageId=%@",
                                 [self->httpProperties objectForKey:SERVER_ADDR_KEY],
                                 [self->httpProperties objectForKey:SERVER_PORT_KEY],
                                 GET_IMAGE_BY_ID, [item imageIds][0]];
                [[SDImageCache sharedImageCache] removeImageForKey:url fromDisk:YES];
            }
        }
    }
    if(updateModel) {
        [user updateTotalModelWithCompletion:^{
            [_itemCountLabel setText:[NSString stringWithFormat:@"%d / %d", user.tradeRoomItems.count, user.tradeRoomMeta.maxItemCount]];
            if(reloadCollection)
                [self->_collectionView reloadData];
            [self->refreshView finishLoading];
        }];
    }
    else
        [self->refreshView finishLoading];
    
    self->shouldClearCache = NO;
    self->shouldClearModel = NO;
    [self delayRequestsOfImages:NO Models:YES];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [self->_collectionView reloadData];
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
    if([[segue identifier] isEqualToString:EDIT_ITEM_SEGUE]) {
        EditItemViewController *editItemController = [segue destinationViewController];
        TradeRoomItemCell *cell = (TradeRoomItemCell*) sender;
        editItemController.itemToShow = cell.item;
        editItemController.imageToShow = cell.itemImage.image;
    }
}

#pragma mark - UICollectionView Delegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TradeRoomItemCell *cell = (TradeRoomItemCell*) [collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:EDIT_ITEM_SEGUE sender:cell];
}

#pragma mark - UICollectionView Delegate Flow Layout Methods

// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize mElementSize = CGSizeMake(95, 95 + LABEL_PADDING);
    return mElementSize;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0f;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0f, 10.0f, 0, 10.0f);
}

#pragma mark - UICollectionView Datasource Methods

#define NUMBER_OF_SECTIONS 1

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return NUMBER_OF_SECTIONS;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return user.tradeRoomItems.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemCell = @"ItemCell";
    
    TradeRoomItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCell forIndexPath:indexPath];
    cell.itemImage.contentMode = UIViewContentModeScaleToFill;
    
    if([user.tradeRoomItems[indexPath.row] imageIds].count > 0) {
        NSString *url = [NSString stringWithFormat:@"http://%@:%@%@?imageId=%@",
                         [self->httpProperties objectForKey:SERVER_ADDR_KEY],
                         [self->httpProperties objectForKey:SERVER_PORT_KEY],
                         GET_IMAGE_BY_ID, [user.tradeRoomItems[indexPath.row] imageIds][0]];
        
        //Should switch to loading image item
        [cell.itemImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"NoImageForItem.png"] options:SDWebImageRetryFailed];
    }
    else {
        [cell.itemImage setImage:noImageForItem];
    }
    cell.item = user.tradeRoomItems[indexPath.row];
    cell.itemName.text = [((TradeRoomItem*) user.tradeRoomItems[indexPath.row]).name capitalizedString];
    
    if([indexPath row] == ((NSIndexPath*)[[collectionView indexPathsForVisibleItems] lastObject]).row)
        [self->refreshView finishLoading];
    
    return cell;
}

#pragma mark - SSPullToRefresh Delegate Methods
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self->refreshView startLoading];
    
    [self refreshCache:shouldClearCache UpdateModel:shouldClearModel ReloadCollection:YES];
}


@end
