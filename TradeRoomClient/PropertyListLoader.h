//
//  PropertyListLoader.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/25/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>


#define PROPERTY_LIST_FILE @"HttpConsumer.plist"
#define PROPERTY_LIST_FILE_BASE @"HttpConsumer"
#define PROPERTY_LIST_FILE_TYPE @"plist"

#define SERVER_ADDR_KEY @"server.addr"
#define SERVER_PORT_KEY @"server.port"
#define SERVER_IMAGE_COMPRESSION @"server.img.compression"

@interface PropertyListLoader : NSObject

+ (NSDictionary*) httpProperties;

@end
