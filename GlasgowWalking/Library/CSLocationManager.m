//
//  CSLocationManager.m
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "CSLocationManager.h"
#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)

@implementation CSLocationManager
@synthesize locationManager, location, heading;

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    }
    return self;
}

-(CLLocation *)currentLocation
{
    return self.locationManager.location;
}

-(CLHeading *)currentHeading
{
    return self.locationManager.heading;
}

-(void)startUpdatingCoarse
{
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [self.locationManager setHeadingFilter:0.5]; // 1 degree
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
}

- (float)getHeadingForDirectionToCoordinate:(CLLocationCoordinate2D)toLoc
{
    CLLocationCoordinate2D fromLoc = [self currentLocation].coordinate;
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);

    float degree = radiandsToDegrees(atan2(sin(tLng-fLng)*cos(tLat),
                                           cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));

    // Diff with current heading
    degree -= [self currentHeading].trueHeading;

    if (degree < 0) {
        return degree + 360;
    } else {
        return (int)floor(degree) % 360;
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = locations[0];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO handle user saying no
    NSLog(@"Location error %@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    self.heading = newHeading;
}

#pragma mark - Singleton

+ (CSLocationManager *)sharedManager
{
    static dispatch_once_t pred;
    static CSLocationManager *_manager = nil;

    dispatch_once(&pred, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}
@end
