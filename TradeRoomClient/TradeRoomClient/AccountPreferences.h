//
//  AccountPreferences.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountPreferences : NSObject {
    
}

@property (strong, nonatomic) NSString *dob;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;

- (void) updateAccountPreferencesWithDict:(NSDictionary*) dict;

@end
