//
//  CSLocationManager.h
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CSLocationManager : NSObject <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLHeading *heading;
@property (strong, nonatomic) CLLocation *location;

- (void)startUpdatingCoarse;
- (float)getHeadingForDirectionToCoordinate:(CLLocationCoordinate2D)toLoc;
- (CLLocation *)currentLocation;
+ (CSLocationManager *)sharedManager;
@end
