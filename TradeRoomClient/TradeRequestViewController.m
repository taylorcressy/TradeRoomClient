//
//  TradeRequestViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/11/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "TradeRequestViewController.h"
#import "UserItemSectionHeader.h"
#import "TradeRequestReviewCell.h"

#define CELL_BOX_DIM 66
#define SUB_COLLECTION_HEIGHT 80
#define TEXT_VIEW_HEIGHT 140
#define HEADER_HEIGHT 35

#define USER_HEADER @"PersonHeader"

static NSString *itemCell = @"TradeRequestItem";
static NSString *placeholderCell = @"placeholderCell";
static NSString *pickupDescription = @"Ask other user to pick up the trade.";
static NSString *dropoffDescription = @"I will pick up the trade.";
static NSString *contactDescription = @"Put me in contact with this user.";

@interface TradeRequestViewController () {
    UILabel *messageLabel;
    UILabel *tradeOptionsDescLabel;
    //For URL handling
    NSDictionary *httpProperties;
    UICollectionView *otherCollection;
    UICollectionView *thisCollection;
    
    DescriptionViewController *descriptionView;
    
    UISegmentedControl *segmentedControl;
    Resources *resources;
}

@end

@implementation TradeRequestViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        httpProperties = [PropertyListLoader httpProperties];
        resources = [Resources getInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void) setupUI {
    
    //Register Headers for the higher UICollectionView
    [_displayRequestView registerClass:[UserItemSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:USER_HEADER];
        
    //Register a placeholder cell for the sub-collections to be placed in
    [_displayRequestView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:placeholderCell];
    
    CGRect subCollectionFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SUB_COLLECTION_HEIGHT);
    
    UICollectionViewFlowLayout *thisSubCollectionLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionViewFlowLayout *otherSubCollectionLayout = [[UICollectionViewFlowLayout alloc] init];
    [thisSubCollectionLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [otherSubCollectionLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //Setup the sub collections. We are primarily doing this so that we can scroll each collection view separately
    otherCollection = [[UICollectionView alloc] initWithFrame:subCollectionFrame collectionViewLayout:thisSubCollectionLayout];
    thisCollection = [[UICollectionView alloc] initWithFrame:subCollectionFrame collectionViewLayout:otherSubCollectionLayout];
    
    //Allow bouncing (Needs to get fixed)
    [_displayRequestView setBounces:YES];
    [otherCollection setBounces:YES];
    [thisCollection setBounces:YES];
    [_displayRequestView alwaysBounceVertical];
    [otherCollection alwaysBounceHorizontal];
    [thisCollection alwaysBounceHorizontal];
    
    //Make clear background
    [otherCollection setBackgroundColor:[UIColor clearColor]];
    [thisCollection setBackgroundColor:[UIColor clearColor]];
    
    //Hide horizontal scroll view indicators
    [otherCollection setShowsHorizontalScrollIndicator:NO];
    [thisCollection setShowsHorizontalScrollIndicator:NO];
    
    //Register the custom cell
    [otherCollection registerClass:[TradeRequestReviewCell class] forCellWithReuseIdentifier:itemCell];
    [thisCollection registerClass:[TradeRequestReviewCell class] forCellWithReuseIdentifier:itemCell];
    
    //Set the delegate / datasources
    otherCollection.dataSource = self;
    otherCollection.delegate = self;
    thisCollection.dataSource = self;
    thisCollection.delegate = self;
    
    //Setup popup description view
    descriptionView = [[DescriptionViewController alloc] init];
    descriptionView.delegate = self;
    
    //Setup the trade options select
    NSMutableArray *tradeOptions = [[NSMutableArray alloc] init];
    for(NSString *option in resources.tradeOptions) {
        NSString *toAdd = [[[option lowercaseString] stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
        [tradeOptions addObject:toAdd];
    }
    segmentedControl = [[UISegmentedControl alloc] initWithItems:tradeOptions];
    CGRect segFrame = segmentedControl.frame;
    segFrame.size.width = [UIScreen mainScreen].bounds.size.width / 1.1;
    segmentedControl.frame = segFrame;
    UIFont *font = [UIFont boldSystemFontOfSize:11.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    //Set the selected index of the segmented control
    segmentedControl.selectedSegmentIndex = 0;
    
    //Trade Options Description Label Setup
    tradeOptionsDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 150, 33)];
    [tradeOptionsDescLabel setText:pickupDescription];
    [tradeOptionsDescLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [tradeOptionsDescLabel sizeToFit];
    [tradeOptionsDescLabel setTextColor:[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:0.9f]];
    
    //Add actions
    [segmentedControl addTarget:self action:@selector(segmentedOptionChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionView Delegate Flow Layout Methods

// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == _displayRequestView) {
        if(indexPath.section != 3)
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, SUB_COLLECTION_HEIGHT);
        else
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, TEXT_VIEW_HEIGHT);
    }
    else
        return CGSizeMake(CELL_BOX_DIM, CELL_BOX_DIM);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(collectionView == _displayRequestView)
        return UIEdgeInsetsMake(5.0f, 0, 20.0f, 0);
    else
        return UIEdgeInsetsMake(3.0f, 25.0f, 3.0f, 10.0f);
}

#pragma mark - UICollectionView Datasource Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if((section == 2 || section == 1) && collectionView == _displayRequestView) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, HEADER_HEIGHT);
    }
    else
        return CGSizeZero;
}

- (UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UserItemSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:USER_HEADER forIndexPath:indexPath];
    if(indexPath.section == 2)
        sectionHeader.userName = _otherUser.username;
    //else if(indexPath.section == 1)
        //sectionHeader.userName = @"Your";//((User*)[User getInstance]).username;
    return sectionHeader;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if(collectionView == _displayRequestView)
        return 4;
    else
        return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _displayRequestView)
        return 1;
    else if(collectionView == otherCollection)
        return _toItems.count;
    else if(collectionView == thisCollection)
        return _fromItems.count;
    else
        return 0;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView != _displayRequestView) {
        TradeRequestReviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCell forIndexPath:indexPath];

        if(cell == nil)
            cell = [[TradeRequestReviewCell alloc] initWithFrame:CGRectMake(0, 0, CELL_BOX_DIM, CELL_BOX_DIM)];
    
        NSString *url;
        if(collectionView == otherCollection) {
            url = [NSString stringWithFormat:@"http://%@:%@%@?imageId=%@",
                            [self->httpProperties objectForKey:SERVER_ADDR_KEY],
                            [self->httpProperties objectForKey:SERVER_PORT_KEY],
                            GET_IMAGE_BY_ID, [_toItems[indexPath.row] imageIds][0]];
        }
        else if(collectionView == thisCollection) {
            url = [NSString stringWithFormat:@"http://%@:%@%@?imageId=%@",
                            [self->httpProperties objectForKey:SERVER_ADDR_KEY],
                            [self->httpProperties objectForKey:SERVER_PORT_KEY],
                            GET_IMAGE_BY_ID, [_fromItems[indexPath.row] imageIds][0]];
        }
        
        [cell.itemImage sd_setImageWithURL:[NSURL URLWithString:url]
                          placeholderImage:[UIImage imageNamed:@"NoImageForItem.png"]
                                   options:SDWebImageRetryFailed];
        return cell;
    }
    else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:placeholderCell forIndexPath:indexPath];
        if(indexPath.section == 2)
            [cell.contentView addSubview:otherCollection];
        else if(indexPath.section == 1)
            [cell.contentView addSubview:thisCollection];
        else if(indexPath.section == 0) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SUB_COLLECTION_HEIGHT)];
            [view setBackgroundColor:[UIColor clearColor]];
            CGPoint viewCenter = view.center;
            viewCenter.y += 15;
            segmentedControl.center = viewCenter;
            [view addSubview:segmentedControl];
            [view addSubview:tradeOptionsDescLabel];
            [cell.contentView addSubview:view];
        }
        else if(indexPath.section == 3) {
            //Setup Trade Request Message View
            UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(25, 10, _displayRequestView.frame.size.width - 50, TEXT_VIEW_HEIGHT - 20)];
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messagePressed:)];
            //Setup message label
            messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, messageView.frame.size.width - 10, TEXT_VIEW_HEIGHT - 30)];
            messageLabel.textAlignment = NSTextAlignmentLeft;
            [messageLabel setTextColor:[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:0.9f]];
            [messageLabel setNumberOfLines:4];
            [messageLabel setText:@"Additional Message (Optional)"];
            [messageView.layer setCornerRadius:15.0f];
            [messageView setBackgroundColor:[UIColor whiteColor]];
            messageView.gestureRecognizers = @[tapRecognizer];
            [messageView addSubview:messageLabel];
            [cell.contentView addSubview:messageView];
        }
        return cell;
    }
}

#pragma mark - Description Delegate
- (void) descriptionSaved:(NSString *)desc {
    if(desc == nil || [desc length] == 0)
        return;
    
    [messageLabel setText:desc];
}

#pragma mark - UI Actions

- (void) messagePressed:(UITapGestureRecognizer*) tapGesture {
    CGRect frame = self->descriptionView.view.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self->descriptionView.view.frame = frame;
    [descriptionView.navigationItemRef setTitle:@"Message"];

    [self.view addSubview:self->descriptionView.view];
    
    [UIView beginAnimations: nil context: nil];
    frame.origin.y = 0;
    self->descriptionView.view.frame = frame;
    [UIView commitAnimations];
}

- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendBtnPressed:(id)sender {
}

- (void) segmentedOptionChanged:(id) sender {
    switch(segmentedControl.selectedSegmentIndex) {
        case 0: {
            [tradeOptionsDescLabel setText:pickupDescription];
            [tradeOptionsDescLabel sizeToFit];
            break;
        }
        case 1: {
            [tradeOptionsDescLabel setText:dropoffDescription];
            [tradeOptionsDescLabel sizeToFit];
            break;
        }
        case 2: {
            [tradeOptionsDescLabel setText:contactDescription];
            [tradeOptionsDescLabel sizeToFit];
            break;
        }
    }
}
@end
