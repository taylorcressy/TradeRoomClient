//
//  PropertyListLoader.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/25/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "PropertyListLoader.h"

@implementation PropertyListLoader

+ (NSDictionary *)httpProperties {
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
        return nil;
    }
    else {
        return temp;
    }
}

@end
