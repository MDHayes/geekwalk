//
//  CSCompassView.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 21/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCompassView : UIView

@property (strong, nonatomic) UIImageView *pointerView;
@property (readwrite, nonatomic, setter = setBearing:) NSNumber *bearing; //TODO consider just a dest location

@end
