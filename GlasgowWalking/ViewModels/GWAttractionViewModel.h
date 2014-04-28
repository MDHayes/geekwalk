//
//  GWAttractionViewModel.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 20/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"
#import <MapKit/MapKit.h>
@class Attraction;

@interface GWAttractionViewModel : RVMViewModel
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *entryDescription;
@property (strong, nonatomic) NSString *openingTimes;
@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;
@property (readwrite, nonatomic) double bearing;
@property (readwrite, nonatomic) double distanceMeters;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *typeImage;

- (instancetype)initWithAttraction:(Attraction *)attraction;
@end
