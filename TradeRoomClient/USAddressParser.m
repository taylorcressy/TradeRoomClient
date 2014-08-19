//
//  USAddressParser.m
//  TradeRoomClient
//
//  Address Parser for united states postcodes
//
//  Created by Taylor James Cressy on 8/2/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "USAddressParser.h"

#define COUNTRY_NAME @"united states of america"    //Does lowercase string comparison
#define COUNTRY_CODE @"usa"                         //Does lowercase string comparison

@implementation USAddressParser {
    
}

@synthesize postcode, country, streetNumber, streetName, county, city;

- (id) initWithStreetName:(NSString *) name
             StreetNumber:(NSString*) num
                  Country:(NSString*) cntry
                     City:(NSString*) cit
                   County:(NSString*) count
                 Postcode:(NSString*) post
{
    self = [super init];
    if(self) {
        self.streetName = name;
        self.streetNumber = num;
        self.country = cntry;
        self.county = count;
        self.postcode = post;
    }
    return self;
}


- (AddressParserStatus) parseAddress {
    AddressParserStatus retStats = AddressParserStatusOkay;
    
    if(![[county lowercaseString]isEqualToString:COUNTRY_NAME] && ![[county lowercaseString] isEqualToString:COUNTRY_CODE]) {
        retStats = AddressParserStatusInvalidCountry;
    }
    
    /*
        Parse the rest
     */
    
    
    return 0;
}

@end
