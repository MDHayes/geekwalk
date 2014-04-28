//
//  GWScrollView.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 31/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWScrollView.h"

@implementation GWScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark - UIScrollView

// Allow scrolling when a button is being dragged
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

@end
