//
//  ResourceConsumer.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/22/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Consumer.h"

@interface ResourceConsumer : Consumer {
    
}

-(void) requestConditionsListWithCompletion:(void (^)(ServiceMessage*)) complete;
-(void) requestTradeOptionsWithCompletion:(void (^)(ServiceMessage*)) complete;

@end
