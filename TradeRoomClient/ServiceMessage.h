//
//  ServiceMessage.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceMessage : NSObject {
    NSInteger responseCode;
    NSString *localizedMessage;
    NSDictionary *dict;
    NSData *rawData;
}

@property(nonatomic) NSInteger responseCode;                /*Server Code Responses*/
@property(strong, nonatomic) NSString *localizedMessage;    /* Server Localized Messages*/
@property(strong, nonatomic) NSDictionary *dict;            /*Primary Data Transfered*/
@property(strong, nonatomic) NSData *rawData;               /*Byte Transfers*/

-(NSArray*) array;

@end
