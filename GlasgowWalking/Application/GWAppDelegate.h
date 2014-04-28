//
//  GWAppDelegate.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 17/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HockeySDK/HockeySDK.h>

@interface GWAppDelegate : UIResponder <UIApplicationDelegate, BITHockeyManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)preloadWalks;

@end
