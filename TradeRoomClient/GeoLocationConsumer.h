//
//  GeoLocationConsumer.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/28/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "Consumer.h"

@interface GeoLocationConsumer : Consumer {
    
}

-(void) requestUpdateCurrentLongitude:(NSNumber*)longitude
                             Latitude:(NSNumber*)latitude
                                 City:(NSString*) city
                           Completion:(void (^)(ServiceMessage *))complete;

@end
