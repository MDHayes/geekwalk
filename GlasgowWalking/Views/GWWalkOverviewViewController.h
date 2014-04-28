//
//  GWWalkOverviewViewController.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 19/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSLocationManager.h"
@class GWWalkViewModel, GWWalkOverviewView, CSLocationManager;
@interface GWWalkOverviewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) GWWalkViewModel *viewModel;
@property (strong, nonatomic) GWWalkOverviewView *imagePulldownView;

@property (strong, nonatomic) CSLocationManager *locationManager;
@property (readwrite, nonatomic) double lastHeadingUsed;

- (id)initWithViewModel:(GWWalkViewModel *)walkViewModel;
@end
