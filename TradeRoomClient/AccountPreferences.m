//
//  AccountPreferences.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 6/30/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "AccountPreferences.h"

@implementation AccountPreferences {
    
}

- (void) updateAccountPreferencesWithDict:(NSDictionary *)dict {
    self->_dob = [dict objectForKey:BIRTH_DAY_KEY];
    self->_firstName = [dict objectForKey:FIRST_NAME_KEY];
    self->_lastName = [dict objectForKey:LAST_NAME_KEY];
    self->_currentCity = [dict objectForKey:CURRENT_CITY];

    if(self->_address == nil)
        self->_address = [[Address alloc] init];

    [self->_address updateWithDictionary:[dict objectForKey:ADDRESS_KEY]];
}

- (NSString*) description {
    
    return [NSString stringWithFormat:@"\n\t\tDOB: %@;\n\t\tFirst Name %@;\n\t\tLast Name: %@; \n\tAddress: %@\n", self->_dob, self->_firstName, self->_lastName, self->_address];
}

@end
