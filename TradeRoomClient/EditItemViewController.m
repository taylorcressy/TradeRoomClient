//
//  EditItemViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/22/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "EditItemViewController.h"
#import <RNBlurModalView.h>

#import "TradeItemConsumer.h"

#import "TRPageViewController.h"

@interface EditItemViewController () {
    
    //UI Elements
    __weak IBOutlet UIButton *imageToShowBtn;
    __weak IBOutlet UITextField *itemNameEdit;
    __weak IBOutlet UITextField *itemCountEdit;
    __weak IBOutlet UIButton *itemDescBtn;
    __weak IBOutlet UIButton *itemCondBtn;
    __weak IBOutlet UIButton *itemTagsBtn;
    
    __weak IBOutlet UIButton *itemSubmitButton; //For Edit Mode
    __weak IBOutlet UIButton *itemDeleteButton; //For View Button
    
    __weak IBOutlet UIButton *switchModeButton;
    UIImage *editImage;
    BOOL viewMode;

    __weak IBOutlet UIButton *cancelBtn;
    __weak IBOutlet UIButton *deleteBtn;
    __weak IBOutlet UIButton *submitBtn;
    
    __weak IBOutlet UIScrollView *scrollView;
    
    //Get resources
    Resources *resources;
    NSArray *conditions;
    NSString *condition;    //Chosen Condition
    
    TradeItemConsumer *itemConsumer;
    TRPageViewController *pageViewController;
    NSMutableArray *images;
    NSMutableArray *tags;
    
    //Misc Controllers / Assoc vars
    DescriptionViewController *descriptionController;
    NSString *descriptionText;
    
    UIPickerView *conditionPicker;
    UIView *inputAccView;
    
}

@end

@implementation EditItemViewController

@synthesize itemToShow, imageToShow;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self->itemConsumer = [[TradeItemConsumer alloc] init];
        self->viewMode = YES;
        self->images = [[NSMutableArray alloc] init];
        self->descriptionController = [[DescriptionViewController alloc] init];
        self->resources = [Resources getInstance];
        self->tags = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->itemConsumer = [[TradeItemConsumer alloc] init];
        self->viewMode = YES;
        self->images = [[NSMutableArray alloc] init];
        self->descriptionController = [[DescriptionViewController alloc] init];
        self->resources = [Resources getInstance];
        self->tags = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self->conditions = [resources conditions];
    
    [self setupUI];
    [self switchToViewMode];
}

- (void) setupUI {
    //Set masks to bounds so we can set corner radius when we reset the image
    self->imageToShowBtn.layer.masksToBounds = YES;
    
    //Set the Image to the current image of item
    [self->imageToShowBtn setImage:self->imageToShow forState:UIControlStateNormal];

    //Set the corner radius properties
    [[self->imageToShowBtn layer] setCornerRadius:20.0f];
    [[self->itemNameEdit layer] setCornerRadius:15.0f];
    [[self->itemCountEdit layer] setCornerRadius:15.0f];
    [[self->itemDescBtn layer] setCornerRadius:20.0f];
    [[self->itemCondBtn layer] setCornerRadius:15.0f];
    [[self->itemTagsBtn layer] setCornerRadius:15.0f];
    
    //Make the description button appear to be a view
    self->itemDescBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self->itemDescBtn.titleLabel.numberOfLines = 4;
    [self->itemDescBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [self->itemDescBtn setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    
    //Set the text of each item appropriately
    [self->itemNameEdit setText:self->itemToShow.name];
    NSString *count = [NSString stringWithFormat:@"Number Of This Item: %d", self->itemToShow.count];
    [self->itemCountEdit setText:count];
    [self->itemDescBtn setTitle:[self->itemToShow itemDescription] forState:UIControlStateNormal];
    
    
    //Capture original image/frame of edit button
    self->editImage = [self->switchModeButton imageView].image;
    
    //Add done button to the number pad for the count field
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(numpadDone:)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flex, doneButton, nil]];
    self->itemCountEdit.inputAccessoryView = keyboardDoneButtonView;
}

- (void) switchToViewMode
{
    //Switch btn back to normal for switch mode button
    [self->cancelBtn setHidden:YES];
    [self->switchModeButton setHidden:NO];
    
    //Set all fields to uneditable
    [self->itemNameEdit setUserInteractionEnabled:NO];
    [self->itemCountEdit setUserInteractionEnabled:NO];
    [self->itemDescBtn setUserInteractionEnabled:NO];
    [self->itemCondBtn setUserInteractionEnabled:NO];
    [self->itemTagsBtn setUserInteractionEnabled:NO];
    
    //Hide the buttons in view mode
    [self->deleteBtn setHidden:NO];
    [self->submitBtn setHidden:YES];
    
    //Lastly, set mode bool
    self->viewMode = YES;
}

- (void) switchToEditMode
{
    //Put a cancel button up
    [self->cancelBtn setHidden:NO];
    [self->switchModeButton setHidden:YES];
    
    //Reset all fields to editable
    [self->itemNameEdit setUserInteractionEnabled:YES];
    [self->itemCountEdit setUserInteractionEnabled:YES];
    [self->itemDescBtn setUserInteractionEnabled:YES];
    [self->itemCondBtn setUserInteractionEnabled:YES];
    [self->itemTagsBtn setUserInteractionEnabled:YES];
    
    //Unhide submit and hide delete
    [self->deleteBtn setHidden:YES];
    [self->submitBtn setHidden:NO];
    
    //Lastly, set mode bool
    self->viewMode = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions
- (IBAction)switchModeButtonPressed:(id)sender {
    if(viewMode)
        [self switchToEditMode];
    else
        [self switchToViewMode];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) numpadDone:(id) sender {
    [self->itemCountEdit resignFirstResponder];
}

- (IBAction)itemImageButtonPressed:(id)sender {
    self->pageViewController = [[TRPageViewController alloc] init];
    self->pageViewController.imageIDs = self.itemToShow.imageIds;
    self->pageViewController.item = self->itemToShow;
    [self presentViewController:self->pageViewController animated:YES completion:nil];
}

- (IBAction)tagsPressed:(id)sender {
    TagsPopupView *tagsPopup = [[[NSBundle mainBundle] loadNibNamed:@"TagsPopup" owner:self options:nil] objectAtIndex:0];
    RNBlurModalView *dialog = [[RNBlurModalView alloc] initWithParentView:self.view view:tagsPopup];
    tagsPopup.delegate = self;
    tagsPopup.center = CGPointMake(CGRectGetMidX(dialog.frame), CGRectGetHeight(dialog.frame) * .33);
    [dialog show];
}

- (IBAction)conditionsPressed:(id)sender {
    //Initialize the picker view
    conditionPicker = [[UIPickerView alloc] init];
    [conditionPicker setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - conditionPicker.frame.size.height,
                                         [UIScreen mainScreen].bounds.size.width, conditionPicker.frame.size.height)];
    conditionPicker.delegate = self;
    conditionPicker.showsSelectionIndicator = YES;
    [conditionPicker.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    
    //Create the input accessory view
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0, conditionPicker.frame.origin.y - 40, [UIScreen mainScreen].bounds.size.width, 40)];
    [inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    //[inputAccView setAlpha:0.8];
    
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setFrame:CGRectMake(inputAccView.frame.size.width - 50, 5, 60, 30)];
    [inputAccView addSubview:doneButton];
    
    //Action Listener for the uiButton
    [doneButton addTarget:self action:@selector(donePickingCondition:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:conditionPicker];
    [self.view addSubview:inputAccView];
    
}

- (void) donePickingCondition:(id) sender {
    NSInteger selected = [conditionPicker selectedRowInComponent:0];
    
    self->condition = [self->conditions objectAtIndex:selected];
    NSString *conditionLabel = [[[self->condition lowercaseString] capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    [self->itemCondBtn setTitle:conditionLabel forState:UIControlStateNormal];
    [self->conditionPicker removeFromSuperview];
    [self->inputAccView removeFromSuperview];
    
}


#pragma mark - DescriptionViewController delegate methods
- (IBAction)descriptionTouched:(id)sender {
    if([self->itemNameEdit isFirstResponder])
        [self->itemNameEdit resignFirstResponder];
    else if([self->itemCountEdit isFirstResponder])
        [self->itemCountEdit resignFirstResponder];
    
    self->descriptionController.delegate = self;
    CGRect frame = self->descriptionController.view.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self->descriptionController.view.frame = frame;
    
    [self.view addSubview:self->descriptionController.view];
    
    [UIView beginAnimations: nil context: nil];
    frame.origin.y = 0;
    self->descriptionController.view.frame = frame;
    [UIView commitAnimations];
}

- (void) descriptionSaved:(NSString *)desc {
    self->descriptionText = desc;
    if([[desc stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0)
        [self->itemDescBtn setTitle:@"Description" forState:UIControlStateNormal];
    else
        [self->itemDescBtn setTitle:desc forState:UIControlStateNormal];
}

#pragma mark - TagPopupView Delegate Methods
- (void) addedtag:(NSString *)tag {
    [self->tags addObject:tag];
    NSString *tagString;
    if(tags.count == 1)
        tagString = [NSString stringWithFormat:@"%lu Tag Selected", (unsigned long)[self->tags count]];
    else
        tagString = [NSString stringWithFormat:@"%lu Tags Selected", (unsigned long)[self->tags count]];
    [self->itemTagsBtn setTitle:tagString forState:UIControlStateNormal];
}

- (void) removedTag:(NSInteger)tagIndex {
    [self->tags removeObjectAtIndex:tagIndex];
    
    if(tags.count != 0) {
        NSString *tagString;
        if(tags.count == 1)
            tagString = [NSString stringWithFormat:@"%lu Tag Selected", (unsigned long)[self->tags count]];
        else
            tagString = [NSString stringWithFormat:@"%lu Tags Selected", (unsigned long)[self->tags count]];
        
        [self->itemTagsBtn setTitle:tagString forState:UIControlStateNormal];
    }
    else
        [self->itemTagsBtn setTitle:@"Tags" forState:UIControlStateNormal];
}

#pragma mark - Picker View Delegate Methods

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = self->conditions.count;
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *conditionLabel = [[[[self->conditions objectAtIndex:row] lowercaseString] capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    return conditionLabel;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


#pragma mark - Consumer Requests

- (IBAction)submitUpdateTouched:(id)sender {
    
    NSString *name = [self->itemNameEdit text];
    
    NSString *countText = [self->itemCountEdit text];
    NSInteger count;
    if(countText != nil)
        count = [countText integerValue];
    else
        count = -1;
    
    NSString *desc = self->descriptionText;
    NSString *cond = self->condition;
    NSArray *tagsArr = self->tags;
    
    //Form check
    [itemConsumer requestUpdateTradeItem:self->itemToShow.itemId
                                    Name:name
                             Description:desc
                                    Tags:tagsArr
                                   Count:count
                               Condition:cond
                              Completion:^(ServiceMessage *msg) {
                                  if([msg responseCode] == 250) {
                                      [self.navigationController popViewControllerAnimated:YES];
                                      RNBlurModalView *popup = [[RNBlurModalView alloc]  initWithTitle:@"Success" message:@"You have successfully updated your trade item"];
                                      [popup show];
                                  }
                                  else {
                                      [self.navigationController popViewControllerAnimated:YES];
                                      RNBlurModalView *popup = [[RNBlurModalView alloc] initWithTitle:@"Failed" message:[msg localizedMessage]];
                                      [popup show];
                                  }
                              }];
    
}

- (IBAction)deleteItem:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete?"
                                                        message:@"Are you sure you want to delete this item?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
        return;
    else {
        [itemConsumer requestRemoveTradeItem:self->itemToShow.itemId Completion:^(ServiceMessage *message) {
            if([message responseCode] == 260) { //Success
                RNBlurModalView *popup = [[RNBlurModalView alloc] initWithViewController:self title:@"Success" message:@"You have successfully deleted your trade item"];
                [popup show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                RNBlurModalView *popup = [[RNBlurModalView alloc] initWithViewController:self title:@"Failed" message:[message localizedMessage]];
                [popup show];
            }
        }];
    }
}



#pragma mark - UITextField Delegate Methods
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual: self->itemNameEdit])
        [textField resignFirstResponder];
    return YES;
}


#pragma mark - Screen Changing Handling
#define kOFFSET_FOR_KEYBOARD 100.0

-(void)keyboardWillHide {
    if(self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    sender.placeholder = nil;
    if ([sender isEqual:self->itemNameEdit] || [sender isEqual:self->itemCountEdit])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
    else {
        if(self.view.frame.origin.y < 0)
            [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


@end
