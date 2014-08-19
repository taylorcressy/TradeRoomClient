//
//  TRPageViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/25/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "TRPageViewController.h"
#import "TradeItemConsumer.h"
#import "ProcessingRequestOverlay.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <RNBlurModalView.h>

@interface TRPageViewController () {
    TradeItemConsumer *consumer;
    NSDictionary *httpProperties;
    NSMutableArray *imageURLs;
}

@end

@implementation TRPageViewController

@synthesize scrollView, title, imageIDs;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Custom initialization
        consumer = [[TradeItemConsumer alloc] init];
        httpProperties = [PropertyListLoader httpProperties];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        consumer = [[TradeItemConsumer alloc] init];
        httpProperties = [PropertyListLoader httpProperties];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageURLs = [[NSMutableArray alloc] init];
    [self resetURLs];
    [self loadSlideShow];
}

- (void) resetURLs {
    [imageURLs removeAllObjects];
    for(NSString *itemId in self->imageIDs) {
        NSString *url = [NSString stringWithFormat:@"http://%@:%@%@?imageId=%@",
                         [self->httpProperties objectForKey:SERVER_ADDR_KEY],
                         [self->httpProperties objectForKey:SERVER_PORT_KEY],
                         GET_IMAGE_BY_ID, itemId];
        [imageURLs addObject:url];
    }
}

- (void) loadSlideShow {

    if(imageURLs.count != 0)
        [self.pageControl setNumberOfPages:imageURLs.count];
    else
        [self.pageControl setNumberOfPages:1];
    
    for (int i = 0; i < imageURLs.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        [subview sd_setImageWithURL:[NSURL URLWithString:imageURLs[i]] placeholderImage:[UIImage imageNamed:@"TradeItemSlot.png"]];
        subview.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:subview];
    }
    if(imageURLs.count == 0) {
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        
        [subview setImage:[UIImage imageNamed:@"NoImageForItem.png"]];
        
        subview.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:subview];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }
    else {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * imageURLs.count, self.scrollView.frame.size.height);
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)endSlideShowTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mart - UIScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)deleteImageFromTradeItem:(id)sender {
    if(_item.imageIds.count == 0) {
        RNBlurModalView *popup = [[RNBlurModalView alloc] initWithViewController:self title:@"No Images" message:@"You have no images to delete from this item."];
        [popup show];
        return;
    }
    NSInteger currentPage = [self->_pageControl currentPage];
    [ProcessingRequestOverlay showOverlay];
    [consumer requestRemoveImageOfTradeItem:self->_item.itemId ImageId:self->imageIDs[currentPage] Completion:^(ServiceMessage *message) {
        [ProcessingRequestOverlay hideOverlay];
        RNBlurModalView *popup;
        if(message.responseCode == 230) {
            popup = [[RNBlurModalView alloc] initWithViewController:self title:@"Deleted Image" message:@"You have successfully deleted this image."];
            [popup show];
            [[SDImageCache sharedImageCache] removeImageForKey:imageURLs[currentPage] fromDisk:YES];
            [[User getInstance] updateTotalModelWithCompletion:^{
                [self resetURLs];
                [self loadSlideShow];
            }];
        }
        else {
            popup = [[RNBlurModalView alloc] initWithViewController:self title:@"Failed To Delete Image" message:[message localizedMessage]];
            [popup show];
        }
    }];
}

- (IBAction)addImageToTradeItem:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //Check Camera available or not
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    //Check PhotoLibrary available or not
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - UIImagePicker Delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *imageToSend = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(imageToSend) {
        [ProcessingRequestOverlay showOverlay];
    
        [consumer requestAddImageToTradeItem:_item.itemId Image:imageToSend Completion:^(ServiceMessage *message) {
            [ProcessingRequestOverlay hideOverlay];
            
            if([message responseCode] == 210) {
                RNBlurModalView *popup = [[RNBlurModalView alloc] initWithViewController:self title:@"Success" message:[message localizedMessage]];
                [popup show];
                [[User getInstance] updateTotalModelWithCompletion:^{
                    [self resetURLs];
                    [self loadSlideShow];
                }];
            }
            else if([message responseCode] == 213){
                RNBlurModalView *popup = [[RNBlurModalView alloc] initWithViewController:self title:@"Failed" message:@"Too many images for this trade item already"];
                [popup show];
            }
            else {
                RNBlurModalView *popup = [[RNBlurModalView alloc] initWithViewController:self title:@"Error" message:[message localizedMessage]];
                [popup show];
            }
        }];
    }
}

@end
