//
//  AddItemViewController.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/21/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <RNBlurModalView.h>

#import "AddItemViewController.h"
#import "TradeItemConsumer.h"


#define NO_KEYBOARD_TAG 99
#define NO_KEYBOARD_RESIGN_TAG 100


@interface AddItemViewController () {
    
    User *user;
    TradeItemConsumer *itemConsumer;
    
    DescriptionViewController *descriptionController;
    NSString *descriptionText;
    
    UIPickerView *conditionPicker;
    UIView *inputAccView;
    UIImage *imageToSend;
    
    NSString *condition;
    
    NSMutableArray *tags;
    NSArray *conditions;

    __weak IBOutlet UIScrollView *scrollView;
    
    Resources *resources;
}

@end

@implementation AddItemViewController


- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        self->user = [User getInstance];
        self->itemConsumer = [[TradeItemConsumer alloc] init];
        self->resources = [Resources getInstance];
        self->tags = [[NSMutableArray alloc] init];
        self->descriptionController = [[DescriptionViewController alloc] init];
        return self;
    }
    return nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->user = [User getInstance];
        self->resources = [Resources getInstance];
        self->itemConsumer = [[TradeItemConsumer alloc] init];
        self->tags = [[NSMutableArray alloc] init];
        self->descriptionController = [[DescriptionViewController alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Event Handlers
    [self.conditionBtn addTarget:self action:@selector(conditionTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.tagsBtn addTarget:self action:@selector(tagsTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.descriptionView addTarget:self action:@selector(setDescriptionTouched:) forControlEvents:UIControlEventTouchUpInside];

    self->conditions = [resources conditions];
    
    [self setupUI];
}

- (void) setupUI {
    //Set masks to bounds so we can set corner radius when we reset the image
    self->_imageBtn.layer.masksToBounds = YES;
    
    //Setup Corner radii
    [[self.nameField layer] setCornerRadius:15.0f];
    [[self.countField layer] setCornerRadius:15.0f];
    [[self.descriptionView layer] setCornerRadius:20.0f];
    [[self.conditionBtn layer] setCornerRadius:15.0f];
    [[self->_imageBtn layer] setCornerRadius:20.0f];
    [[self.tagsBtn layer] setCornerRadius:15.0f];


    //Make the description button appear to be a view
    self.descriptionView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionView.titleLabel.numberOfLines = 4;
    [self.descriptionView setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [self.descriptionView setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    
    /*For the number pad*/
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(numpadDone:)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flex, doneButton, nil]];
    self->_countField.inputAccessoryView = keyboardDoneButtonView;
}

- (void) numpadDone:(id) sender {
    [self.view endEditing:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

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

#pragma mark - User Interactions
- (IBAction)addImageTouched:(id)sender {
    
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

- (void) setDescriptionTouched:(id) sender {
    
    if([self->_nameField isFirstResponder])
        [self->_nameField resignFirstResponder];
    else if([self->_countField isFirstResponder])
        [self->_countField resignFirstResponder];
    
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
        [self->_descriptionView setTitle:@"Description" forState:UIControlStateNormal];
    else
        [self->_descriptionView setTitle:desc forState:UIControlStateNormal];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self->imageToSend = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self->_imageBtn setImage:self->imageToSend];
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (IBAction)tagsTouched:(id)sender {
    TagsPopupView *tagsPopup = [[[NSBundle mainBundle] loadNibNamed:@"TagsPopup" owner:self options:nil] objectAtIndex:0];
    RNBlurModalView *dialog = [[RNBlurModalView alloc] initWithParentView:self.view view:tagsPopup];
    tagsPopup.delegate = self;
    tagsPopup.center = CGPointMake(CGRectGetMidX(dialog.frame), CGRectGetHeight(dialog.frame) * .33);
    [dialog show];
}

- (IBAction)conditionTouched:(id)sender {
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
    [self->_conditionBtn setTitle:conditionLabel forState:UIControlStateNormal];
    [self->conditionPicker removeFromSuperview];
    [self->inputAccView removeFromSuperview];
}

/*
 IBAction template that verifies input first
 */
- (IBAction)submitItem:(id)sender {
    if(self.nameField.text.length == 0)
    {
        RNBlurModalView *view = [[RNBlurModalView alloc] initWithTitle:@"No Name" message:@"Please enter a name for your Trade Room Item."];
        [view show];
        return;
    }
    if(self.countField.text.length == 0)
    {
        RNBlurModalView *view = [[RNBlurModalView alloc] initWithTitle:@"No Item Count Specified" message:@"Please enter the number of these Trade Room Items that you have."];
        [view show];
        return;
    }
    
    [self submitItem];
}

/*
 Submit the item to the server
 */
- (void) submitItem {
    [ProcessingRequestOverlay showOverlay];
    NSString *itemName = [self.nameField text];
    NSInteger count = [[self.countField text] intValue];
    NSString *cond = self->condition;
    NSString *itemDescription = self->descriptionText;
    
    if(itemName == nil || cond == nil || itemDescription == nil || tags.count == 0) {
        RNBlurModalView *message = [[RNBlurModalView alloc] initWithTitle:@"Invalid Entry" message:@"Please fill out all fields to add a new Trade Item"];
        [message show];
        [ProcessingRequestOverlay hideOverlay];
        return;
    }
    
    [self->itemConsumer requestAddTradeItem:itemName Description:itemDescription Count:count Tags:tags Condition:cond Completion:^(ServiceMessage *msg) {
        if(msg != nil) {
            switch([msg responseCode]) {
                case 201: {    //Invalid Form
                    [ProcessingRequestOverlay hideOverlay];
                    RNBlurModalView *view = [[RNBlurModalView alloc] initWithTitle:@"Invalid Form Submission" message:@"Please ensure that all fields are correctly filled out."];
                    [view show];
                    break;
                }
                case 202: {    //Null values
                    [ProcessingRequestOverlay hideOverlay];
                    RNBlurModalView *view = [[RNBlurModalView alloc] initWithTitle:@"Invalid Form Submission" message:@"Please ensure that all fields are correctly filled out."];
                    [view show];
                    break;
                }
                case 203: {    //Max Item Limit
                    [ProcessingRequestOverlay hideOverlay];
                    RNBlurModalView *view = [[RNBlurModalView alloc] initWithTitle:@"Max Item Limit Reached" message:@"You have reached the maximum number of Trade Room Items that can be placed in your Trade Room"];
                    [view show];
                    break;
                }
                case 200: {    //Success
                    if(self->imageToSend != nil) {
                        NSString *itemId = [[msg dict] objectForKey:OBJECT_ID];
                        [self->itemConsumer requestAddImageToTradeItem:itemId Image:self->imageToSend Completion:^(ServiceMessage *message) {
                            [ProcessingRequestOverlay hideOverlay];
                            [self.navigationController popViewControllerAnimated:YES];
                            if(message != nil) {
                                switch([message responseCode]) {
                                    case 210: { //Success
                                        RNBlurModalView *view = [[RNBlurModalView alloc] initWithTitle:@"Success" message:@"Successfully added Item to Trade Room"];
                                        [view show];
                                        return;
                                    }
                                    default: {
                                        RNBlurModalView *view = [[RNBlurModalView alloc] initWithTitle:@"Error" message:@"Failed to up load image of item to Trade Room. Please re upload image from the Trade Room Page."];
                                        [view show];
                                        return;
                                    }
                                }
                            }
                        }];
                    }
                    else {
                        RNBlurModalView *view = [[RNBlurModalView alloc] initWithTitle:@"Success" message:@"Successfully added Item to Trade Room"];
                        [view show];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    break;
                }
                default: {     //Connection / Server Error
                    RNBlurModalView *view = [[RNBlurModalView alloc] initWithTitle:@"Connection Error" message:@"Unable to connect to server. Check your connection and try again"];
                    [view show];
                }
            }
            
        }
    }];
}

- (IBAction)backTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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



#pragma mark - TextField Delegate Methods

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField.tag == NO_KEYBOARD_TAG)
        return NO;
    else
        return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField.tag != NO_KEYBOARD_RESIGN_TAG)
        [textField resignFirstResponder];
    return YES;
}

#pragma marks - TagsPopupView Delegate Methods

- (void) addedtag:(NSString *)tag {
    [self->tags addObject:tag];
    NSString *tagString;
    if(tags.count == 1)
        tagString = [NSString stringWithFormat:@"%lu Tag Selected", (unsigned long)[self->tags count]];
    else
        tagString = [NSString stringWithFormat:@"%lu Tags Selected", (unsigned long)[self->tags count]];
    [self->_tagsBtn setTitle:tagString forState:UIControlStateNormal];
}

- (void) removedTag:(NSInteger)tagIndex {
    [self->tags removeObjectAtIndex:tagIndex];
    
    if(tags.count != 0) {
        NSString *tagString;
        if(tags.count == 1)
            tagString = [NSString stringWithFormat:@"%lu Tag Selected", (unsigned long)[self->tags count]];
        else
            tagString = [NSString stringWithFormat:@"%lu Tags Selected", (unsigned long)[self->tags count]];
        [self->_tagsBtn setTitle:tagString forState:UIControlStateNormal];
    }
    else
        [self->_tagsBtn setTitle:@"Tags" forState:UIControlStateNormal];
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
    if ([sender isEqual:self->_nameField] || [sender isEqual:self->_countField])
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
