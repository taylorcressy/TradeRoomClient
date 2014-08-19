//
//  HttpHandler.m
//  TradeRoomClient
//
//  Front-level class providing basic RESTful requests to the server.
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "HttpHandler.h"

#import "TRURLConnection.h"

#define CONNECTION_TIMEOUT 20.0f

@implementation HttpHandler {
    BOOL servingRequest;
    BOOL didAuthenticate;
}

@synthesize properties;

/*
 Singleton and Constructor
 */
#pragma mark - INIT
+(id) getInstance {
    static HttpHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

-(id) init {
    self = [super init];
    
    if(self) {
        if([self readPropertiesFromPropertyList] == NO) {
            //IO Error in essence, shouldn't get here
            return nil;
        }
        
        self->didAuthenticate = NO;
        self->servingRequest = NO;
        
        return self;
    }
    
    return nil;
}


#pragma mark - RESTful Methods


/*
    Called Exclusively by NSTimer
 */
- (void) sendGetRequest:(NSTimer*) timer {
    NSDictionary *userInfo = [timer userInfo];
    
    [self sendGetRequest:[userInfo valueForKey:@"request"]
               withParams:[userInfo valueForKey:@"params"]
               Completion:[userInfo valueForKey:@"completion"]];
}

/*
    Send a GET request
 
    Expects the API call and an option for parameter dictionary - Check Server Web API documentation
 */
- (void) sendGetRequest:(NSString*) request withParams:(NSDictionary*) params Completion:(void (^)(NSDictionary*)) complete {
    /*if(self->servingRequest) {
        //Pack variables and rerun
        NSDictionary *userInfo = @{@"request": request,
                                   @"params": (params == nil) ? [NSNull null] : params, //Exclusive for GET requests(As they can have nil params sometimes)
                                   @"completion": complete};
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendGetRequest:) userInfo:userInfo repeats:NO];
        return;
    }*/
    self->servingRequest = YES;

    NSString *urlStr;
    if(![params isEqual:[NSNull null]]) {
        //Populate parameters
        NSMutableString *getParams = [[NSMutableString alloc] init];
        for(NSString *key in [params allKeys]) {
            [getParams appendString:[NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]]];
        }
        NSString *fixedParams = nil;
        if([[params allKeys] count] > 0)
            fixedParams = [[getParams substringToIndex:[getParams length] - 1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //Grab Request Object and set the URL
        urlStr = [NSString stringWithFormat:@"http://%@:%@/%@?%@", [self->properties valueForKey:SERVER_ADDR_KEY],
                            [self->properties valueForKey:SERVER_PORT_KEY],
                            request, fixedParams];
    }
    else {
        urlStr = [NSString stringWithFormat:@"http://%@:%@/%@", [self->properties valueForKey:SERVER_ADDR_KEY],
                   [self->properties valueForKey:SERVER_PORT_KEY],
                   request];
    }
    
    
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                               cachePolicy:NSURLCacheStorageAllowed
                                                           timeoutInterval:CONNECTION_TIMEOUT];
    
    [getRequest setHTTPMethod:@"GET"];
    
    TRURLConnection *connection = [[TRURLConnection alloc] initWithRequest:getRequest delegate:self startImmediately:NO];
    
    [connection start];
    
    if(connection) {
        connection.data = [NSMutableData data];
        connection.completionBlock = complete;
    }

    
}


/*
    Called exclusively by NSTimer
 */
- (void) sendPostRequest:(NSTimer*) timer {
    NSDictionary *userInfo = [timer userInfo];
    
    [self sendPostRequest:[userInfo valueForKey:@"request"]
               withParams:[userInfo valueForKey:@"params"]
               Completion:[userInfo valueForKey:@"completion"]];
}


/*
 Send a POST request
 
 Expects the API Call and Key Value paired parameter dictionary
 */
-(void) sendPostRequest:(NSString*) request withParams:(NSDictionary*) params Completion:(void (^)(NSDictionary*))complete {
    /*if(self->servingRequest) {
        //Pack variables and rerun
        NSDictionary *userInfo = @{@"request": request,
                                   @"params": params,
                                   @"completion": complete};
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPostRequest:) userInfo:userInfo repeats:NO];
        return;
    }*/
    self->servingRequest = YES;

    
    //Populate parameters
    NSMutableString *postParams = [[NSMutableString alloc] init];
    for(NSString *key in [params allKeys]) {
        [postParams appendString:[NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]]];
    }
    
    //Encode to NSData using ASCII String Encoding
    NSData *data = [postParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    //Grab Request Object and set the URL
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/%@", [self->properties valueForKey:SERVER_ADDR_KEY],
                        [self->properties valueForKey:SERVER_PORT_KEY],
                        request];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                               cachePolicy:NSURLCacheStorageAllowed
                                                           timeoutInterval:CONNECTION_TIMEOUT];
    
    
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:data];
    
    TRURLConnection *connection = [[TRURLConnection alloc] initWithRequest:postRequest delegate:self startImmediately:NO];
    
    [connection start];
    
    if(connection) {
        connection.data = [NSMutableData data];
        connection.completionBlock = complete;
    }
}

-(void) sendPostRequestWithData:(NSTimer*) timer {
    NSDictionary *userInfo = [timer userInfo];
    
    [self sendPostRequest:[userInfo valueForKey:@"request"]
               withParams:[userInfo valueForKey:@"params"]
                 withImage:[userInfo valueForKey:@"data"]
               Completion:[userInfo valueForKey:@"completion"]];
}

-(void) sendPostRequest:(NSString*) request
             withParams:(NSDictionary*) params
               withImage:(UIImage*) imgData
             Completion:(void(^)(NSDictionary* responseKeysAndValues))complete {
    /*if(self->servingRequest) {
        //Pack variables and rerun
        NSDictionary *userInfo = @{@"request": request,
                                   @"params": params,
                                   @"data": imgData,
                                   @"completion": complete};
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPostRequestWithData:) userInfo:userInfo repeats:NO];
        return;
    }*/

    NSString *boundary = @"---------------------------7da24f2e50046";
    
    //Populate parameters
    NSMutableString *postParams = [[NSMutableString alloc] init];
    for(NSString *key in [params allKeys]) {
        [postParams appendString:[NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]]];
    }
    
    //Grab Request Object and set the URL
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/%@", [self->properties valueForKey:SERVER_ADDR_KEY],
                        [self->properties valueForKey:SERVER_PORT_KEY],
                        request];
    
    //Init URL Request
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                               cachePolicy:NSURLCacheStorageAllowed
                                                           timeoutInterval:CONNECTION_TIMEOUT];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [postRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [postRequest setHTTPMethod:@"POST"];
    
    /*Set Params*/
    NSMutableData *body = [NSMutableData data];
    for (NSString *param in params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    /*Append the image data*/
    //Assumes the parater requires an image with key value 'imageData'
    const NSString *imgDataKey = @"imageData";
    
    NSData *imageData = UIImageJPEGRepresentation(imgData, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", imgDataKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    //Terminate the header
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postRequest setHTTPBody:body];
    
    TRURLConnection *connection = [[TRURLConnection alloc] initWithRequest:postRequest delegate:self startImmediately:NO];
    
    self->servingRequest = YES;
    [connection start];
    
    if(connection) {
        connection.data = [NSMutableData data];
        connection.completionBlock = complete;
    }
}



/*
 Called exclusively by NSTimer
 */
- (void) sendPutRequest:(NSTimer*) timer {
    NSDictionary *userInfo = [timer userInfo];
    
    [self sendPostRequest:[userInfo valueForKey:@"request"]
               withParams:[userInfo valueForKey:@"params"]
               Completion:[userInfo valueForKey:@"completion"]];
}


/*
 Send a PUT request
 
 Expects the API Call and Key Value paired parameter dictionary
 */
-(void) sendPutRequest:(NSString*) request withParams:(NSDictionary*) params Completion:(void (^)(NSDictionary*))complete {
    if(self->servingRequest) {
        //Pack variables and rerun
        NSDictionary *userInfo = @{@"request": request,
                                   @"params": params,
                                   @"completion": complete};
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPutRequest:) userInfo:userInfo repeats:NO];
        return;
    }
    
    //Populate parameters
    NSMutableString *postParams = [[NSMutableString alloc] init];
    for(NSString *key in [params allKeys]) {
        [postParams appendString:[NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]]];
    }
    
    //Encode to NSData using ASCII String Encoding
    NSData *data = [postParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    //Grab Request Object and set the URL
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/%@", [self->properties valueForKey:SERVER_ADDR_KEY],
                        [self->properties valueForKey:SERVER_PORT_KEY],
                        request];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                               cachePolicy:NSURLCacheStorageAllowed
                                                           timeoutInterval:CONNECTION_TIMEOUT];
    
    [postRequest setHTTPMethod:@"PUT"];
    [postRequest setHTTPBody:data];
    
    TRURLConnection *connection = [[TRURLConnection alloc] initWithRequest:postRequest delegate:self startImmediately:NO];
    
    self->servingRequest = YES;
    [connection start];
    
    if(connection) {
        connection.data = [NSMutableData data];
        connection.completionBlock = complete;
    }
}

/*
 Called Exclusively by NSTimer
 */
- (void) sendDeleteRequest:(NSTimer*) timer {
    NSDictionary *userInfo = [timer userInfo];
    
    [self sendGetRequest:[userInfo valueForKey:@"request"]
              withParams:[userInfo valueForKey:@"params"]
              Completion:[userInfo valueForKey:@"completion"]];
}

/*
 Send a GET request
 
 Expects the API call and an option for parameter dictionary - Check Server Web API documentation
 */
- (void) sendDeleteRequest:(NSString*) request withParams:(NSDictionary*) params Completion:(void (^)(NSDictionary*)) complete {
    /*if(self->servingRequest) {
        //Pack variables and rerun
        NSDictionary *userInfo = @{@"request": request,
                                   @"params": params,
                                   @"completion": complete};
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendDeleteRequest:) userInfo:userInfo repeats:NO];
        return;
    }*/
    self->servingRequest = YES;

    //Populate parameters
    NSMutableString *getParams = [[NSMutableString alloc] init];
    for(NSString *key in [params allKeys]) {
        [getParams appendString:[NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]]];
    }
    
    //Grab Request Object and set the URL
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/%@?%@", [self->properties valueForKey:SERVER_ADDR_KEY],
                        [self->properties valueForKey:SERVER_PORT_KEY],
                        request, getParams];
    
    
    
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                              cachePolicy:NSURLCacheStorageAllowed
                                                          timeoutInterval:CONNECTION_TIMEOUT];
    
    [getRequest setHTTPMethod:@"DELETE"];
    
    TRURLConnection *connection = [[TRURLConnection alloc] initWithRequest:getRequest delegate:self startImmediately:NO];
    
    [connection start];
    
    if(connection) {
        connection.data = [NSMutableData data];
        connection.completionBlock = complete;
    }
    
    
}




#pragma mark - NSURLConnection Delegate Methods
-(void) connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"Canceled Authentication Challenge");
    self->servingRequest = NO;
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed with error: %@", [error localizedDescription]);
    self->servingRequest = NO;
    ((TRURLConnection*) connection).completionBlock(nil);
    self->servingRequest = NO;
}

-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"Received Authentication Challenge: %@", [challenge debugDescription]);
    //if([challenge previousFailureCount] == 0 && didAuthenticate == NO) {
        NSURLCredential *credential = [[NSURLCredential alloc] initWithUser:USER
                                                                   password: AUTHENTICATION
                                                                persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        didAuthenticate = YES;
        NSLog(@"Called");
    //}

    }

/*-(void) connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
        self->servingRequest = NO;
}*/

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [((TRURLConnection*) connection).data appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"%@", [[NSString alloc] initWithData:((TRURLConnection*) connection).data encoding:NSUTF8StringEncoding]);
    NSDictionary *converted = [self parseJsonRequest:((TRURLConnection*) connection).data];
    
    self->servingRequest = NO;
    
    if(converted == nil) { //Error with server
        ((TRURLConnection*) connection).completionBlock(nil);
        return;
    }
    
    NSDictionary *dataDictionary = nil;
    NSMutableDictionary *response = [NSMutableDictionary dictionaryWithDictionary:converted];
    if(![[response valueForKey:SRV_DATA_KEY] isKindOfClass:[NSDictionary class]] && ![[response valueForKey:SRV_DATA_KEY] isKindOfClass:[NSArray class]])
    {
        NSString *jsonData = [response valueForKey:SRV_DATA_KEY];
    
        if(![jsonData isEqual:[NSNull null]]) {
            dataDictionary = [self parseJsonRequest:[jsonData dataUsingEncoding:NSUTF8StringEncoding]];
            if(dataDictionary == nil)
            {
                NSLog(@"Error parsing data dictionary");
                return;
            }
        }
    }
    
    if(dataDictionary != nil) {
        [response setValue:dataDictionary forKeyPath:SRV_DATA_KEY];
    }    
    [response setValue:[converted objectForKey:SRV_CODE_KEY] forKeyPath:SRV_CODE_KEY];
    [response setValue:[converted objectForKey:SRV_MSG_KEY] forKeyPath:SRV_MSG_KEY];
    ((TRURLConnection*) connection).completionBlock(response);
}


#pragma mark - Helpers
/*
 Read attributes from the property files
 */
-(BOOL) readPropertiesFromPropertyList {
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", PROPERTY_LIST_FILE_BASE, PROPERTY_LIST_FILE_TYPE]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:PROPERTY_LIST_FILE_BASE ofType:PROPERTY_LIST_FILE_TYPE];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %u", errorDesc, format);
        return NO;
    }
    else {
        self->properties = temp;
        return YES;
    }
}

-(NSDictionary*) parseJsonRequest:(NSData*) returnedData{
    if(returnedData == nil) {   //Check if nil, don't know how a third party library will react
        return nil;
    }
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:returnedData
                     options:0
                     error:&error];
        
        if(error) {
            NSLog(@"JSON Was Malformed: Fatal");
            return nil;
        }
        
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            return results;
        }
        else
        {
            NSLog(@"Couldn't convert JSON to NSDictionary type");
            return nil;
        }
    }
    else
    {
        NSLog(@"IOS 4 or below");
        return nil;
    }
}

@end
