//
//  TRNSURLConnection.h
//  TradeRoomClient
//
//  Extension of NSURLConnection to support associating an NSMutableData Object with the connection.
//  This allows Trade Room to make numerous RESTful requests asynchronously
//
//  Created by Taylor James Cressy on 5/5/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ServiceMessage.h"

@interface TRURLConnection : NSURLConnection {
    NSMutableData *data;
}

@property(nonatomic) NSMutableData* data;
@property(strong, nonatomic) void (^completionBlock) (NSDictionary*);

@end
