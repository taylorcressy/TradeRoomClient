//
//  AccountPreferences.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeoLocation.h"
#import "Address.h"

@interface AccountPreferences : NSObject {
    
}

@property (strong, nonatomic) NSString *dob;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *currentCity;
@property (strong, nonatomic) Address *address;

- (void) updateAccountPreferencesWithDict:(NSDictionary*) dict;

@end
