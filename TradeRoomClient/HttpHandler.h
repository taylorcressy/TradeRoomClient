//
//  HttpHandler.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHandler : NSObject <NSURLConnectionDelegate,
                                        NSURLConnectionDataDelegate>{
    NSDictionary *properties;
}

@property (readonly, nonatomic) NSDictionary *properties;

//GET request
-(void) sendGetRequest:(NSString*) request
            withParams:(NSDictionary*) params
            Completion: (void(^)(NSDictionary* responseKeysAndValues))complete;

//POST request
-(void) sendPostRequest:(NSString*) request
             withParams:(NSDictionary*) params
             Completion:(void(^)(NSDictionary* responseKeysAndValues))complete;

//POST request with image
-(void) sendPostRequest:(NSString*) request
             withParams:(NSDictionary*) params
               withImage:(UIImage*) data
             Completion:(void(^)(NSDictionary* responseKeysAndValues))complete;

//PUT request (untested)
-(void) sendPutRequest:(NSString*) request
             withParams:(NSDictionary*) params
             Completion:(void(^)(NSDictionary* responseKeysAndValues))complete;
//Singleton ref
+(id) getInstance;

@end
