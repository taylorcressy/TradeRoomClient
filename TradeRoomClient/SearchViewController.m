//
//  SearchViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "SearchViewController.h"
#import "ViewTradeItemViewController.h"
#import "SearchConsumer.h"
#import "TradeItemTableViewCell.h"
#import "TradeRoomItem.h"
#import "PropertyListLoader.h"

#define TO_ITEM_VIEW_SEGUE @"ToItemView"

@interface SearchViewController () {
    SearchConsumer *searchHandle;
    NSDictionary *httpProperties;
    NSMutableArray *users;
    NSMutableArray *items;
}

@end

@implementation SearchViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Custom initialization
        searchHandle = [[SearchConsumer alloc] init];
        users = [[NSMutableArray alloc] init];
        items = [[NSMutableArray alloc] init];
        self->httpProperties = [PropertyListLoader httpProperties];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        searchHandle = [[SearchConsumer alloc] init];
        items = [[NSMutableArray alloc] init];
        self->httpProperties = [PropertyListLoader httpProperties];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
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
    if([[segue identifier] isEqualToString:TO_ITEM_VIEW_SEGUE]) {
        ViewTradeItemViewController *viewItemController = [segue destinationViewController];
        TradeItemTableViewCell *cell = (TradeItemTableViewCell*) sender;
        viewItemController.item = cell.item;
        viewItemController.imageToShow = cell.itemImage.image;
    }
}


#pragma mark - UI Actions

//Handle the user's search criteria
- (IBAction)readyForSearch:(id)sender {
    if(self->_searchField.text.length == 0)
        return;
    [ProcessingRequestOverlay showOverlay];
    NSString *query = [self->_searchField text];
    [self->searchHandle searchForItem:query Completion:^(ServiceMessage *msg) {
        [self->items removeAllObjects];
        TradeRoomItem *item;
        for(NSDictionary *dict in [msg array]) {
            item = [TradeRoomItem dictionyToItem:dict];
            [self->items addObject:item];
        }
        [self.tableView reloadData];
        [ProcessingRequestOverlay hideOverlay];
    }];
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

// custom view for header. will be adjusted to default or specified header height
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
// custom view for footer. will be adjusted to default or specified footer height
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeItemTableViewCell *selectedCell = (TradeItemTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:TO_ITEM_VIEW_SEGUE sender:selectedCell];
}

#pragma mark - UITableView Datasource Methods

#define TRADE_ITEM_CELL @"TradeItemCell"
#define NUMBER_OF_SECTIONS 1
/*
    Number of rows in the table
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self->items count];
}

/*
    Get Reusable cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Populate the cells from the search arrays
    TradeItemTableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:TRADE_ITEM_CELL];
    
    if(itemCell == nil)
        itemCell = [[TradeItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:TRADE_ITEM_CELL];
    {
        TradeRoomItem *itemToShow = [self->items objectAtIndex:indexPath.row];

        itemCell.itemName.text = itemToShow.name;
        NSString *itemCondition = [[itemToShow.condition lowercaseString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        itemCell.itemCondition.text = [itemCondition capitalizedString];
        [itemCell.itemDescription setText:itemToShow.itemDescription];
    
    
        NSString *url = [NSString stringWithFormat:@"http://%@:%@%@?imageId=%@",
                         [self->httpProperties objectForKey:SERVER_ADDR_KEY],
                         [self->httpProperties objectForKey:SERVER_PORT_KEY],
                         GET_IMAGE_BY_ID, [itemToShow imageIds][0]];
        NSURL *fullUrl = [NSURL URLWithString:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"NoImageForItem.png"];
    
        [itemCell.itemImage sd_setImageWithURL:fullUrl placeholderImage:placeholderImage];
        //Finally give the whole reference to the item to the cell. Mostly for Segue Purposes
        itemCell.item = itemToShow;
    }
    
    return itemCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - UITextField Delegate Methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
