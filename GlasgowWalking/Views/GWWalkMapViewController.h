//
//  GWWalkMapViewController.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 26/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class GWWalkViewModel, GWWalkMapView;
@interface GWWalkMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) GWWalkViewModel *viewModel;
@property (strong, nonatomic) GWWalkMapView *walkMapView;

- (id)initWithViewModel:(GWWalkViewModel *)walkViewModel;

@end
