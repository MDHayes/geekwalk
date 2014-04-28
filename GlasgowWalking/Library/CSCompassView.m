//
//  CSCompassView.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 21/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "CSCompassView.h"

@implementation CSCompassView

@synthesize pointerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *pointerImage = [UIImage imageNamed:@"up-arrow"];
        [self layoutIfNeeded];
        CGRect imageFrame = CGRectMake(0, 0, 30, 30);
        self.pointerView = [[UIImageView alloc] initWithFrame:imageFrame];
        self.pointerView.image = pointerImage;
        self.pointerView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.pointerView];
    }
    return self;
}

-(void)setBearing:(NSNumber *)bearing
{
    self->_bearing = bearing;
    @weakify(self);
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         @strongify(self);
                         self.pointerView.transform = CGAffineTransformMakeRotation([self.bearing doubleValue] * M_PI/180);
                     }
                     completion:^(BOOL finished){
                     }];

}

@end
