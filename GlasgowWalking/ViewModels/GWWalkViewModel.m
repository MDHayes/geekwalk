//
//  GWWalkViewModel.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 18/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWWalkViewModel.h"
#import "GWAttractionViewModel.h"
#import "Walk.h"
#import "Attraction.h"
#import "RoutePoint.h"

@implementation GWWalkViewModel

- (instancetype)initWithWalk:(Walk *)walk
{
    self = [super init];
    if (self) {
        _attractions = [NSMutableArray new];

        // Walk data
        _name = walk.name;
        _description = walk.details;
        _distanceKm = [walk.distanceKm doubleValue];
        _overviewImage = [UIImage imageNamed:walk.overviewImage];

        // Attractions
        for (Attraction *attraction in walk.attractions) {
            [_attractions addObject:[[GWAttractionViewModel alloc] initWithAttraction:attraction]];
        }

        // Route
        if(walk.points) {
            _points = [NSMutableArray new];
            for (RoutePoint *point in walk.points) {
                NSDictionary *pointData = @{
                                            @"lat": point.lat,
                                            @"lng": point.lng
                                            };
                [_points addObject:pointData];
            }
        }
    }
    return self;
}
@end
