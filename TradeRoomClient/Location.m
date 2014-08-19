//
//  Location.m
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 7/26/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#import "Location.h"

#import "GeoLocationConsumer.h"

@implementation Location {
    /*This stuff needs to move*/
    __strong CLLocationManager *locationManager;
    NSString *geoCoords;
    NSTimer *timer;
    GeoLocationConsumer *consumer;
    
}

+ (id)getInstance
{
    static dispatch_once_t onceQueue;
    static Location *location = nil;
    
    dispatch_once(&onceQueue, ^{ location = [[self alloc] init]; });
    return location;
}

- (void) startLocation {
    // Do any additional setup after loading the view.
    self->locationManager = [[CLLocationManager alloc] init];
    self->locationManager.delegate = self;
    self->locationManager.distanceFilter = DISTANCE_FILTER;
    self->consumer = [[GeoLocationConsumer alloc] init];
    [self update];
}

- (void) update {
    [self->locationManager startUpdatingLocation];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *loc = [locations lastObject];
    
    [self->locationManager stopUpdatingLocation];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placeMark = [placemarks lastObject];
        NSString *locality = [placeMark locality];
        [self->consumer requestUpdateCurrentLongitude:[NSNumber numberWithDouble:placeMark.location.coordinate.longitude]
                                             Latitude:[NSNumber numberWithDouble:placeMark.location.coordinate.latitude]
                                                 City:locality
        Completion:^(ServiceMessage *msg) {
            if([msg responseCode] == 150) {
                NSLog(@"Update Location: Success");
            }
        }];
    }];
    
    /**/
    
    //Update location once every 5 minutes.
    timer = [NSTimer scheduledTimerWithTimeInterval:(60 * 15) target:self selector:@selector(update) userInfo:nil repeats:NO];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"GeoLocation error : %@",[error description]);
    
}

- (void) stopLocation {
    [timer invalidate];
}

@end
