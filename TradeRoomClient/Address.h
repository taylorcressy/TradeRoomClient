//
//  Address.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 8/2/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject {

}
@property (strong, nonatomic) NSString *streetNumber;
@property (strong, nonatomic) NSString *streetName;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *county;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *postcode;

- (void) updateWithDictionary:(NSDictionary*) dict;
@end
