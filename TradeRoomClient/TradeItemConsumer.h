//
//  TradeItemConsumer.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 5/21/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Consumer.h"

@interface TradeItemConsumer : Consumer {
}


/*
    Trade Item Requests
 */
-(void) requestAddTradeItem:(NSString*) name
                Description:(NSString*) description
                      Count:(NSInteger) count
                       Tags:(NSArray*) tags
                  Condition:(NSString*) condition
                 Completion:(void (^)(ServiceMessage*)) complete;


-(void) requestRetrieveItemsFromList:(NSArray*) itemIds
                          Completion:(void (^)(ServiceMessage*)) complete;

-(void) requestUpdateTradeItem:(NSString*) itemId
                          Name:(NSString*) name
                   Description:(NSString*) description
                          Tags:(NSArray*) tags
                         Count:(NSInteger) count
                     Condition:(NSString*) condition
                    Completion:(void (^)(ServiceMessage*)) complete;

-(void) requestRemoveTradeItem:(NSString*) itemId
                    Completion:(void (^)(ServiceMessage*)) complete;

/*
    Trade Item Image Requests
 */
-(void) requestAddImageToTradeItem:(NSString*) itemId
                             Image:(UIImage*) imgData
                        Completion:(void (^)(ServiceMessage*)) complete;

-(void) requestRemoveImageOfTradeItem:(NSString*) itemId
                              ImageId:(NSString*) imageId
                           Completion:(void (^)(ServiceMessage*)) complete;

@end
