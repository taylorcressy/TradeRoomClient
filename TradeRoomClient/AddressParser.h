//
//  AddressParser.h
//  TradeRoomClient
//
//  Protocol for parsing addresses. For each country that trade room supports. There should be a subclass
//  that implements a parsing method with the provided init function of this super class.
//
//  Future implementations should offer suggessted updated for the the names of addresses and then provide geolocation
//  coordinates for accurate addresses to feed to the server. For now the subclasses will just parse
//
//  Created by Taylor James Cressy on 8/2/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, AddressParserStatus) {
    AddressParserStatusOkay = 0,
    AddressParserStatusInvalidStreetName = 1 << 0,
    AddressParserStatusInvalidStreetNum = 1 << 1,
    AddressParserStatusInvalidCity = 1 << 2,
    AddressParserStatusInvalidCounty = 1 << 3,
    AddressParserStatusInvalidCountry = 1 << 4,
    AddressParserStatusInvalidPostcode = 1 << 5
};

@protocol AddressParser <NSObject>

@required
@property (strong, nonatomic) NSString *streetNumber;
@property (strong, nonatomic) NSString *streetName;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *county;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *postcode;


- (AddressParserStatus) parseAddress;


@end
