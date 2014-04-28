//
//  GWAttractionViewController.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 28/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GWAttractionViewModel, GWAttractionView;

@interface GWAttractionViewController : UIViewController

@property (strong, nonatomic) GWAttractionViewModel *viewModel;
@property (strong, nonatomic) GWAttractionView *attractionView;

- (id)initWithViewModel:(GWAttractionViewModel *)attractionViewModel;

@end
