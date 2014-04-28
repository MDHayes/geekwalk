//
//  GWWalkViewModel.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 18/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"
@class Walk;

@interface GWWalkViewModel : RVMViewModel
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (readwrite, nonatomic) double distanceKm;
@property (strong, nonatomic) UIImage *overviewImage;
@property (strong, nonatomic) UIImage *providerImage;
@property (strong, nonatomic) NSMutableArray *attractions;
@property (strong, nonatomic) NSMutableArray *points;
- (instancetype)initWithWalk:(Walk *)walk;
@end
