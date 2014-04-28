//
//  Walk.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 24/04/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "Walk.h"
#import "Attraction.h"
#import "RoutePoint.h"


@implementation Walk

@dynamic details;
@dynamic distanceKm;
@dynamic name;
@dynamic overviewImage;
@dynamic providerImage;
@dynamic attractions;
@dynamic points;

// Work-around for ordered one-to-many CoreData bug
- (void)addPointsObject:(RoutePoint *)value
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.points];
    [tempSet addObject:value];
    self.points = tempSet;
}

@end
