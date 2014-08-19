//
//  TagsPopupView.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/23/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "TagsPopupView.h"

#import "HTMLParser.h"

@implementation TagsPopupView {
    int direction;
    int shakes;
}

@synthesize tagField, tagsList;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Init
        [[self layer] setCornerRadius:4.0f];
        self->tagsList = [[NSMutableArray alloc] init];
            }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:shouldReceiveTouch:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    [self->tagsview addGestureRecognizer:tapGesture];
    [self->tagField becomeFirstResponder];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self->tagsview setBackgroundColor:[UIColor whiteColor]];
    [[self->tagsview layer] setCornerRadius:4.0f];
    [[self->tagsview layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self->tagsview layer] setBorderWidth:2.0f];

}

- (IBAction)AddTagTouched:(id)sender {
    NSString *tag = [[[self->tagField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] capitalizedString];
    self->direction = 1;
    self->shakes = 5;
    if(tag.length == 0)
    {
        [self shake:self->tagField];
        return;
    }
    [self->tagField setText:@""];

    if([self->tagsList containsObject:tag]) {
        [self shake:self->tagField];
        return;
    }
    
    
    [self->tagsList addObject:tag];
    [self->_delegate addedtag:tag];
    
    
    [self updateWebView];
}

- (void) updateWebView {
    //Open HTML
    NSMutableString *inlineCSS = [[NSMutableString alloc ] initWithString:@"<!doctype><html><head><style>"];
    //Individiual CSS Styles
    [inlineCSS appendString:@".main{width: 100%; height: 100%;} .bubble{background-image: linear-gradient(bottom, rgb(210,244,254) 25%, rgb(149,194,253) 100%); border: solid 1px rgba(0, 0, 0, 0.5); background-image: -o-linear-gradient(bottom, rgb(210,244,254) 25%, rgb(149,194,253) 100%); background-image: -moz-linear-gradient(bottom, rgb(210,244,254) 25%, rgb(149,194,253) 100%); background-image: -webkit-linear-gradient(bottom, rgb(210,244,254) 25%, rgb(149,194,253) 100%); background-image: -ms-linear-gradient(bottom, rgb(210,244,254) 25%, rgb(149,194,253) 100%); background-image: -webkit-gradient(linear, left bottom, left top, color-stop(0.25, rgb(210,244,254)), color-stop(1, rgb(149,194,253)));border-radius: 20px; box-shadow: inset 0 5px 5px rgba(255, 255, 255, 0.4), 0 1px 3px rgba(0, 0, 0, 0.2); box-sizing: border-box; float: left; padding: 4px 12px; text-shadow: 0 1px 1px rgba(255, 255, 255, 0.7); width: auto; max-width: 100%; word-wrap: break-word;}"];
    
    //Close Head
    [inlineCSS appendString:@"</style></head><body><div class='main'>"];
    
    int i = 0;
    for(NSString* next in self->tagsList) {
        [inlineCSS appendString:[NSString stringWithFormat:@"<div class='bubble'><span value='%d'>%@</span></div>", i, next]];
        i++;
    }
    
    //Close HTML
    [inlineCSS appendString:@"</body></html>"];
    
    [self->tagsview loadHTMLString:inlineCSS baseURL:nil];
}

/*
 Shake a view (fun effect)
 */
-(void)shake:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.1 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(shakes >= 10)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             return;
         }
         shakes++;
         direction = direction * -1;
         [self shake:theOneYouWannaShake];
     }];
}


#pragma mark - Gesture Recognizer For UIWebView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Retrieve gesture point
    CGPoint point = [touch locationInView:self->tagsview];
    
    //Write up javascript to find element in HTML doc
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).outerHTML", point.x, point.y];
    
    //Execute Javascript
    NSString *webViewString = [self->tagsview stringByEvaluatingJavaScriptFromString:js];
    if(webViewString != nil){   //Should always get a response
        NSError *error = NULL;
        //Parse HTML
        HTMLParser *parser = [[HTMLParser alloc] initWithString:webViewString error:&error];
        if (error) {
            NSLog(@"Error Parsing HTML in TagPopupView. Error: %@", [error localizedDescription]);
            return NO;
        }
        
        HTMLNode *bodyNode = [parser body];
        
        //Check if user pressed outside of tags
        if([bodyNode findChildOfClass:@"main"] != nil)
            return NO;
        
        //If pressed a tag figure out which one
        NSArray *inputNodes = [bodyNode findChildTags:@"span"];
        
        //Should only find one, but loop through anyway...
        for (HTMLNode *inputNode in inputNodes) {
            //Get HTML tag value
            NSInteger index = [[inputNode getAttributeNamed:@"value"] integerValue];
            
            //Remove the corresponding value from the tagslist
            [self->tagsList removeObjectAtIndex:index];
            
            //Inform delegate
            [self->_delegate removedTag:index];
            
            //Update our web view
            [self updateWebView];
        }
        return YES;
    } else {
        NSLog(@"JavaScript failed to execute in TagsPopupView");
        return NO;
    }
}


@end
