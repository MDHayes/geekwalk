//
//  RoutePoint.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 24/04/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Walk;

@interface RoutePoint : NSManagedObject

@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) Walk *walk;

@end
