//
//  ClientPropertiesAndMessages.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientPropertiesAndMessages : NSObject {
    NSDictionary *serverCodesAndMessages;
}

+(id) getInstance;

@property (readonly) NSDictionary *serverCodesAndMessages;

@end
