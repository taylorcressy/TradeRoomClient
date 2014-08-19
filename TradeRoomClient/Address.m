//
//  Address.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/2/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "Address.h"

@implementation Address {
    
}

@synthesize postcode, county, city, streetName, streetNumber, country;


- (void) updateWithDictionary:(NSDictionary *)dict {
    self->city = [dict objectForKey:ADDR_CITY];
    self->country = [dict objectForKey:ADDR_COUNTRY];
    self->county = [dict objectForKey:ADDR_COUNTY];
    self->postcode = [dict objectForKey:ADDR_POSTCODE];
    self->streetNumber = [dict objectForKey:ADDR_STREET_NUM];
    self->streetName = [dict objectForKey:ADDR_STREET_NAME];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"\n\t\tStreet Number:%@;\n\t\tStreet Name:%@;\n\t\tCountry:%@;\n\t\tCounty:%@;\n\t\tCity:%@\n\t\tPostCode:%@;", self->streetNumber, self->streetName, self->country, self->county, self->city, self->postcode];
}


@end
