//
//  GWWalkMapView.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 26/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKMapView, GWAttractionCell, GWWalkViewModel;

@interface GWWalkMapView : UIView

@property (strong, nonatomic) GWWalkViewModel *viewModel;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) GWAttractionCell *attractionView;
@property (strong, nonatomic) UIButton *attractionButton;

- (id)initWithViewModel:(GWWalkViewModel *)walkViewModel;

@end
