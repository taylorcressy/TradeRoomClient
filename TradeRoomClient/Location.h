//
//  Location.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/26/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define DISTANCE_FILTER 100


@interface Location : NSObject<CLLocationManagerDelegate>

+ (id)getInstance;

- (void) startLocation;
- (void) stopLocation;

@end
