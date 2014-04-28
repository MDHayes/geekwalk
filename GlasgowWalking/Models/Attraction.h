//
//  Attraction.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 02/04/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Walk;

@interface Attraction : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * entryDescription;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * openingTimes;
@property (nonatomic, retain) NSString * typeImage;
@property (nonatomic, retain) Walk *walk;

@end
