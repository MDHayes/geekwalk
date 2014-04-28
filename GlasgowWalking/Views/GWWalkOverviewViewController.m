//
//  GWWalkOverviewViewController.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 19/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWWalkOverviewViewController.h"
#import "GWWalkViewModel.h"
#import <MapKit/MapKit.h>
#import "GWWalkOverviewView.h"
#import "GWAttractionCell.h"
#import "GWAttractionViewModel.h"
#import "GWWalkMapViewController.h"
#import "GWAttractionViewController.h"

@interface GWWalkOverviewViewController ()

@end

@implementation GWWalkOverviewViewController

- (id)initWithViewModel:(GWWalkViewModel *)walkViewModel;
{
    self = [super init];
    if (self) {
        _viewModel = walkViewModel;
        _locationManager = [CSLocationManager sharedManager];
    }
    return self;
}

#pragma mark - UIViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];

    // Show view
    _imagePulldownView = [[GWWalkOverviewView alloc] initWithViewModel:_viewModel];
    _imagePulldownView.attractionsTable.delegate = self;
    _imagePulldownView.attractionsTable.dataSource = self;

    double navBarHeight = self.navigationController.navigationBar.frame.size.height;
    double statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    _imagePulldownView.scrollInitialOffset = navBarHeight + statusBarHeight;
    _imagePulldownView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_imagePulldownView];

    // Update the height required by the table when the number of rows changes
    [RACObserve(_viewModel, attractions) subscribeNext:^(NSArray *attractions) {
        double requiredBottomHeight = [attractions count] * 60;
        _imagePulldownView.attractionsHeight = requiredBottomHeight;
    }];

    _imagePulldownView.headerButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [Flurry logEvent:@"Map Tap" withParameters:@{@"name":_viewModel.name}];
        GWWalkMapViewController *walkMapVC = [[GWWalkMapViewController alloc] initWithViewModel:_viewModel];
        [self.navigationController pushViewController:walkMapVC animated:YES];
        return [RACSignal empty];
    }];
}

-(void)viewDidLayoutSubviews
{
    [_imagePulldownView autoRemoveConstraintsAffectingView];
    [_imagePulldownView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:_viewModel.name];
    [_locationManager startUpdatingCoarse];
    [Flurry logEvent:@"Walk View" withParameters:@{@"name": _viewModel.name}];

    // Update attraction bearing when user heading changes
    [[[RACSignal combineLatest:@[RACObserve(_locationManager, heading),
                                 RACObserve(_locationManager, location)]]
     filter:^BOOL(RACTuple *values) {
         CLHeading *bearing = values.first;
         return bearing && abs((int)_lastHeadingUsed - (int)bearing.trueHeading) > 10;
     }] subscribeNext:^(RACTuple *values) {
         CLHeading *bearing = values.first;
         CLLocation *location = values.last;
         _lastHeadingUsed = bearing.trueHeading;
         for (int i = 0; i < _viewModel.attractions.count; i++) {
             GWAttractionViewModel *attraction = _viewModel.attractions[i];
             double bearing = [[CSLocationManager sharedManager] getHeadingForDirectionToCoordinate:attraction.coordinate];
             [attraction setBearing:bearing];

             CLLocation *attractionLocation = [[CLLocation alloc] initWithLatitude:attraction.coordinate.latitude
                                                                         longitude:attraction.coordinate.longitude];
             double dist = [location distanceFromLocation:attractionLocation];
             [attraction setDistanceMeters:dist];
         }
     }];

    // Update attraction distances when user moves
    [RACObserve(_locationManager, location)
     subscribeNext:^(id location) {
         for (int i = 0; i < _viewModel.attractions.count; i++) {
             GWAttractionViewModel *attraction = _viewModel.attractions[i];
             CLLocation *attractionLocation = [[CLLocation alloc] initWithLatitude:attraction.coordinate.latitude
                                                                         longitude:attraction.coordinate.longitude];
             double dist = [location distanceFromLocation:attractionLocation];
             [attraction setDistanceMeters:dist];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GWAttractionViewModel *attraction = _viewModel.attractions[indexPath.row];
    [Flurry logEvent:@"Attraction Tap (walk overview)" withParameters:@{
                                                  @"walk":_viewModel.name,
                                                  @"index": @(indexPath.row),
                                                  @"attraction":attraction.name
                                                  }];
    GWAttractionViewController *attractionVC = [[GWAttractionViewController alloc] initWithViewModel:attraction];
    [attractionVC setTitle:_viewModel.name];
    [self.navigationController pushViewController:attractionVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GWAttractionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttractionCell"];
    GWAttractionViewModel *attractionViewModel = _viewModel.attractions[indexPath.row];
    [Flurry logEvent:@"Attraction Tap" withParameters:@{
                                                  @"name":attractionViewModel.name,
                                                  @"index": @(indexPath.row)
                                                  }];
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GWAttractionDetailsView" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.viewModel = attractionViewModel;

    [cell setNeedsLayout];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _viewModel.attractions.count;
}

@end
