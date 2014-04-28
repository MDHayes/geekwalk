//
//  GWWalksViewController.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 18/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GWWalksView, GWWalksViewModel;

@interface GWWalksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) GWWalksView *walksView;
@property (strong, nonatomic) GWWalksViewModel *viewModel;

@end
