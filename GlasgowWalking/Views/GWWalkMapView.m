//
//  GWWalkMapView.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 26/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWWalkMapView.h"
#import "GWAttractionCell.h"
#import "GWWalkViewModel.h"
#import <MapKit/MapKit.h>

@implementation GWWalkMapView

- (id)initWithViewModel:(GWWalkViewModel *)walkViewModel
{
    self = [super init];
    if (self) {
        _viewModel = walkViewModel;

        _mapView = [MKMapView new];
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_mapView];

        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GWAttractionDetailsView" owner:self options:nil];
        _attractionView = [topLevelObjects objectAtIndex:0];
        _attractionView.viewModel = _viewModel.attractions[0];
        _attractionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_attractionView];

        _attractionButton = [UIButton new];
        _attractionButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_attractionButton];
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_attractionView autoRemoveConstraintsAffectingView];
    [_attractionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_attractionView autoSetDimension:ALDimensionHeight toSize:60.0];

    // Overlay button on attraction view, to allow clicks
    [_attractionButton autoRemoveConstraintsAffectingView];
    [_attractionButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_attractionButton autoSetDimension:ALDimensionHeight toSize:60.0];

    [_mapView autoRemoveConstraintsAffectingView];
    [_mapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_mapView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_attractionView];

    [super layoutSubviews];
}

@end
