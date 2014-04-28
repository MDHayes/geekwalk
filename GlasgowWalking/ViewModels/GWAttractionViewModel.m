//
//  GWAttractionViewModel.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 20/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWAttractionViewModel.h"
#import "Attraction.h"

@implementation GWAttractionViewModel

- (instancetype)initWithAttraction:(Attraction *)attraction
{
    self = [super init];
    if (self) {
        _name = attraction.name;
        _entryDescription = attraction.entryDescription;
        _openingTimes = attraction.openingTimes;
        _coordinate = CLLocationCoordinate2DMake([attraction.lat doubleValue],
                                                 [attraction.lng doubleValue]);
        _bearing = 0;
        _distanceMeters = 0;
        _typeImage = [UIImage imageNamed:attraction.typeImage];
        _image = [UIImage imageNamed:attraction.image];
        _details = attraction.details;
    }
    return self;
}
@end
