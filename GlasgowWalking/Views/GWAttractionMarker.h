//
//  GWAttractionMarker.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 27/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class GWAttractionViewModel;

@interface GWAttractionMarker : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) GWAttractionViewModel *viewModel;

@end
