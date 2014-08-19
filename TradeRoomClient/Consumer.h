//
//  Consumer.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/18/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpHandler.h"
#import "ServiceMessage.h"

@interface Consumer : NSObject {
    HttpHandler *handler;

}


-(void) respondToCaller:(NSDictionary*) responseKeysAndValues Completion:(void (^)(ServiceMessage*)) complete;

@end
