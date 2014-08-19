//
//  GeoLocation.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/27/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoLocation : NSObject

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *latitude;

@end
