//
//  GWAttractionViewController.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 28/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWAttractionViewController.h"
#import "GWAttractionViewModel.h"
#import "GWAttractionView.h"

@interface GWAttractionViewController ()

@end

@implementation GWAttractionViewController

- (id)initWithViewModel:(GWAttractionViewModel *)attractionViewModel;
{
    self = [super init];
    if (self) {
        _viewModel = attractionViewModel;
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];

    _attractionView = [[GWAttractionView alloc] initWithViewModel:_viewModel];
    _attractionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_attractionView];
}

- (void)viewDidLayoutSubviews
{
    [_attractionView autoRemoveConstraintsAffectingView];
    [_attractionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

    if (_attractionView.descriptionHeight == 0) {
        _attractionView.descriptionHeight = ceilf([_attractionView.attractionDescription sizeThatFits:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)].height);
        CGFloat height = self.view.frame.size.height;
        if (_attractionView.descriptionHeight < height - 200 - 60) {
            _attractionView.descriptionHeight = height - 200 - 60 + 1; // 1 extra to enable scrolling
        }
    }

    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Flurry logEvent:@"Attraction View" withParameters:@{@"attraction":_viewModel.name}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
