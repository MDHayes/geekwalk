//
//  main.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 17/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GWAppDelegate.h"
#import <Touchpose/QTouchposeApplication.h>

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, NSStringFromClass([QTouchposeApplication class]), NSStringFromClass([GWAppDelegate class]));
    }
}
