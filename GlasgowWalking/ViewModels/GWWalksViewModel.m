//
//  GWWalksViewModel.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 18/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWWalksViewModel.h"
#import "GWWalkViewModel.h"
#import "GWAttractionViewModel.h"
#import "Walk.h"

@implementation GWWalksViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _walks = [NSMutableArray new];
        NSArray *walks = [Walk MR_findAll];
        for (int i = 0; i < walks.count; i++) {
            Walk *walk = walks[i];
            [_walks addObject:[[GWWalkViewModel alloc] initWithWalk:walk]];
        }
    }
    return self;
}
@end
