//
//  GeoLocationConsumer.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/28/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "GeoLocationConsumer.h"

@implementation GeoLocationConsumer

-(void) requestUpdateCurrentLongitude:(NSNumber*)longitude
                             Latitude:(NSNumber*)latitude
                                 City:(NSString*) city
                           Completion:(void (^)(ServiceMessage *))complete {
    if(longitude == nil || latitude == nil || city == nil) {
        NSLog(@"Retrieving null values for requestUpdateCurrentLongitude");
        return;
    }
    
    
    NSDictionary *params = @{CURRENT_LONGITUDE: longitude, CURRENT_LATITUDE: latitude, CURRENT_CITY: city};
    
    [self->handler sendPostRequest:UPDATE_CURRENT_LOCATION
                        withParams:params Completion:^(NSDictionary *responseKeysAndValues) {
                            [self respondToCaller:responseKeysAndValues Completion:complete];
                        }];
}

@end
