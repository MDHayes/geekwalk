//
//  Walk.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 24/04/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attraction, RoutePoint;

@interface Walk : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * distanceKm;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * overviewImage;
@property (nonatomic, retain) NSString * providerImage;
@property (nonatomic, retain) NSSet *attractions;
@property (nonatomic, retain) NSOrderedSet *points;
@end

@interface Walk (CoreDataGeneratedAccessors)

- (void)addAttractionsObject:(Attraction *)value;
- (void)removeAttractionsObject:(Attraction *)value;
- (void)addAttractions:(NSSet *)values;
- (void)removeAttractions:(NSSet *)values;

- (void)insertObject:(RoutePoint *)value inPointsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPointsAtIndex:(NSUInteger)idx;
- (void)insertPoints:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePointsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPointsAtIndex:(NSUInteger)idx withObject:(RoutePoint *)value;
- (void)replacePointsAtIndexes:(NSIndexSet *)indexes withPoints:(NSArray *)values;
- (void)addPointsObject:(RoutePoint *)value;
- (void)removePointsObject:(RoutePoint *)value;
- (void)addPoints:(NSOrderedSet *)values;
- (void)removePoints:(NSOrderedSet *)values;
@end
