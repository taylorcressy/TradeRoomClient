//
//  TradeItemConsumer.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/21/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "TradeItemConsumer.h"

@implementation TradeItemConsumer {
}

- (id) init {
    self = [super init];
    if(self) {
        
        return self;
    }
    
    return nil;
}


/*
    Send a request to server to add a trade item to the user's account
 */
- (void)requestAddTradeItem:(NSString *)name
                Description:(NSString *)description
                      Count:(NSInteger)count
                       Tags:(NSArray *)tags
                  Condition:(NSString *)condition
                 Completion:(void (^)(ServiceMessage *))complete {
    
    if(name == nil || description == nil || tags == nil || condition == nil || complete == nil) {
        NSLog(@"In requestAddTradeItem: Trade item data is nil");
        return;
    }
    if(!complete) {
        NSLog(@"No completion block specified in requestAddtradeItem");
        return;
    }
   
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:ITEM_NAME_KEY];
    [params setObject:[description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:ITEM_DESCRIPTION_KEY];
    [params setObject:[NSNumber numberWithInt:count] forKey:ITEM_COUNT_KEY];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tags options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [params setObject:jsonString forKey:ITEM_TAGS_KEY];
    
    
    [params setObject:[condition stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey: ITEM_CONDITION_KEY];
    
    [self->handler sendPostRequest:ADD_TRADE_ITEM_REQUEST withParams:params Completion:^(NSDictionary *responseKeysAndValues) {
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];
}

/*
    Send a request to server to retrieve a list of item of the user's account
 */
-(void) requestRetrieveItemsFromList:(NSArray*) itemIds
                          Completion:(void (^)(ServiceMessage*)) complete {

    if(itemIds == nil) {    //No Items For User
        complete(nil);
        return;
    }
    if(!complete) {
        NSLog(@"No completion block specified in requestRetrieveItemsFromList");
        return;
    }
 
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:itemIds options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [params setObject:jsonString forKey:ITEM_ARRAY_IDS];
    
    [self->handler sendGetRequest:GET_TRADE_ITEMS withParams:params Completion:^(NSDictionary *responseKeysAndValues) {
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];

}

/*
    Send a request to update a specific trade item
 */
-(void) requestUpdateTradeItem:(NSString*) itemId
                          Name:(NSString*) name
                   Description:(NSString*) description
                          Tags:(NSArray*) tags
                         Count:(NSInteger) count
                     Condition:(NSString*) condition
                    Completion:(void (^)(ServiceMessage*)) complete {
    if(!complete) {
        NSLog(@"No completion block specified in requestUpdateTradeItem");
        return;
    }
    
    if(name == nil && description == nil && tags == nil && count == -1 && condition == nil)
    {
        complete(nil);
        return;
    }
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setObject:itemId forKey:ITEM_ID_KEY];
    if(name != nil)
        [params setObject:name forKey:ITEM_NAME_KEY];
    if(description != nil)
        [params setObject:description forKey:ITEM_DESCRIPTION_KEY];
    if(condition != nil)
        [params setObject:condition forKey:ITEM_CONDITION_KEY];

    if(count != -1)
        [params setObject:[NSNumber numberWithInt:count] forKey:ITEM_COUNT_KEY];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tags options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [params setObject:jsonString forKey:ITEM_TAGS_KEY];

    [self->handler sendPostRequest:UPDATE_TRADE_ITEM withParams:params Completion:^(NSDictionary *responseKeysAndValues) {
        NSLog(@"%@", responseKeysAndValues);
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];
    
}


/*
    Request to remove a trade item
 */
-(void) requestRemoveTradeItem:(NSString*) itemId
                    Completion:(void (^)(ServiceMessage*)) complete {
    if(!itemId) {
        NSLog(@"itemId is null in requestRemoveTradeItem");
        return;
    }
    if(!complete) {
        NSLog(@"No complete block specified in requestRemoveTradeItem");
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:itemId forKey:ITEM_ID_KEY];
    
    [self->handler sendPostRequest:REMOVE_TRADE_ITEM withParams:params Completion:^(NSDictionary *responseKeysAndValues) {
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];
}

#pragma mark - TRADE ITEM IMAGE HANDLES

/*
    Request to add image to a trade item
 */
-(void) requestAddImageToTradeItem:(NSString*) itemId
                             Image:(UIImage*) imgData
                        Completion:(void (^)(ServiceMessage*)) complete
{
    
    if(!itemId || !imgData) {
        NSLog(@"itemId or imgData is nil in requestAddImageToTradeItem");
        return;
    }
    
    if(!complete) {
        NSLog(@"no complete block specified in requestAddImageToTradeItem");
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:itemId forKey:ITEM_ID_KEY];
    
    [self->handler sendPostRequest:ADD_IMAGE_TO_TRADE_ITEM withParams:params withImage:imgData Completion:^(NSDictionary *responseKeysAndValues) {
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];
}


/*
    Request remove image of trade item
 */
-(void) requestRemoveImageOfTradeItem:(NSString*) itemId
                              ImageId:(NSString*) imageId
                           Completion:(void (^)(ServiceMessage*)) complete {
    if(!itemId) {
        NSLog(@"itemId is null in requestRemoveImageOfTradeItem");
        return;
    }
    if(!imageId) {
        NSLog(@"Image Id is null in requestRemoveImageOfTradeItem");
    }
    if(!complete) {
        NSLog(@"No complete block specified in requestRemoveImageOfTradeItem");
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:itemId forKey:ITEM_ID_KEY];
    [params setObject:imageId forKey:ITEM_IMAGE_KEY];
    
    [self->handler sendPostRequest:REMOVE_IMAGE_BY_ID withParams:params Completion:^(NSDictionary *responseKeysAndValues) {
        [self respondToCaller:responseKeysAndValues Completion:complete];
    }];
}





@end
