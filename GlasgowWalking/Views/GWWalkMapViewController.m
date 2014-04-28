//
//  GWWalkMapViewController.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 26/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWWalkMapViewController.h"
#import "GWWalkViewModel.h"
#import "GWAttractionViewModel.h"
#import "GWWalkMapView.h"
#import "GWAttractionMarker.h"
#import "GWAttractionViewController.h"
#import "GWAttractionCell.h"

@interface GWWalkMapViewController ()

@end

@implementation GWWalkMapViewController

- (id)initWithViewModel:(GWWalkViewModel *)walkViewModel;
{
    self = [super init];
    if (self) {
        _viewModel = walkViewModel;
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];

    _walkMapView = [[GWWalkMapView alloc] initWithViewModel:_viewModel];
    _walkMapView.translatesAutoresizingMaskIntoConstraints = NO;
    _walkMapView.mapView.delegate = self;

    // Add annotations
    for (int i = 0; i < _viewModel.attractions.count; i++) {
        GWAttractionViewModel *attraction = _viewModel.attractions[i];
        GWAttractionMarker *annotation = [[GWAttractionMarker alloc] init];
        [annotation setCoordinate:attraction.coordinate];
        [annotation setViewModel:attraction];
        [annotation setTitle:attraction.name];
        [_walkMapView.mapView addAnnotation:annotation];
    }

    // Add route
    if (_viewModel.points) {
        NSLog(@"Points!");
        NSInteger numberOfSteps = _viewModel.points.count;
        CLLocationCoordinate2D *locationCoordinate2DArray = malloc(numberOfSteps * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < numberOfSteps; i++)
        {
            NSDictionary *coord = [_viewModel.points objectAtIndex:i];
            CLLocationDegrees lat = [[coord objectForKey:@"lat"] doubleValue];
            CLLocationDegrees lng = [[coord objectForKey:@"lng"] doubleValue];
            CLLocation* current = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            locationCoordinate2DArray[i] = current.coordinate;
        }

        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:locationCoordinate2DArray
                                                             count:numberOfSteps];
        free(locationCoordinate2DArray);
        
        [_walkMapView.mapView addOverlay:polyline];
    }

    // Zoom to fit annotations
    MKMapRect zoomRect = MKMapRectNull;
    for (GWAttractionViewModel *attraction in _viewModel.attractions)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(attraction.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    MKMapRect paddedZoomRect = MKMapRectMake(zoomRect.origin.x - 4000, zoomRect.origin.y -= 4000,
                                             zoomRect.size.width + 8000, zoomRect.size.height + 8000);
    [_walkMapView.mapView setVisibleMapRect:paddedZoomRect animated:YES];

    [self.view addSubview:_walkMapView];

    // Show attraction detials VC when tapping attraction view
    _walkMapView.attractionButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        GWAttractionViewModel *attraction = _walkMapView.attractionView.viewModel;
        [Flurry logEvent:@"Attraction Tap (map view)" withParameters:@{
                                                            @"walk":_viewModel.name,
                                                            @"attraction":attraction.name
                                                            }];
        GWAttractionViewController *attractionVC = [[GWAttractionViewController alloc] initWithViewModel:attraction];
        [attractionVC setTitle:_viewModel.name];
        [self.navigationController pushViewController:attractionVC animated:YES];

        return [RACSignal empty];
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [_walkMapView autoRemoveConstraintsAffectingView];
    [_walkMapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:_viewModel.name];
    [Flurry logEvent:@"Map View" withParameters:@{@"walk":_viewModel.name}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[GWAttractionMarker class]]) {
        GWAttractionMarker *marker = view.annotation;
        [Flurry logEvent:@"Annotation Tap" withParameters:@{
                                                            @"walk":_viewModel.name,
                                                            @"attraction":marker.viewModel.name
                                                            }];
        GWAttractionCell *attractionView = _walkMapView.attractionView;
        attractionView.viewModel = marker.viewModel;
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 2.5;
    return  renderer;
}



@end
