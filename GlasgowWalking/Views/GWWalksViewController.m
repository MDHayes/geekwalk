//
//  GWWalksViewController.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 18/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWWalksViewController.h"
#import "GWWalkSummaryCell.h"
#import "GWWalksView.h"
#import "GWWalksViewModel.h"
#import "GWWalkViewModel.h"
#import "GWWalkOverviewViewController.h"

@interface GWWalksViewController ()

@end

@implementation GWWalksViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f
                                                  green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];

    _walksView = [GWWalksView new];
    [self.view addSubview:_walksView];
    _walksView.translatesAutoresizingMaskIntoConstraints = NO;
    [_walksView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

    _walksView.walksTableView.delegate = self;
    _walksView.walksTableView.dataSource = self;
    _walksView.walksTableView.backgroundView = nil;
    _walksView.walksTableView.backgroundColor = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Walks"];
    [Flurry logEvent:@"Walks View"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _viewModel.walks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReuseIdentifier = @"WalkCell";
    GWWalkSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];

    if (!cell) {
        cell = [[GWWalkSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:ReuseIdentifier
                                                       viewModel:_viewModel.walks[indexPath.row]];
    } else {
        cell.viewModel = _viewModel.walks[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GWWalkViewModel *walkVM = _viewModel.walks[indexPath.row];
    [Flurry logEvent:@"Walk Tap" withParameters:@{
                                                  @"name": walkVM.name,
                                                  @"index": @(indexPath.row)
                                                  }];
    GWWalkOverviewViewController *overviewVC = [[GWWalkOverviewViewController alloc] initWithViewModel:walkVM];
    [self.navigationController pushViewController:overviewVC animated:YES];
}

@end
