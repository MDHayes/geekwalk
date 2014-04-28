//
//  GWAttractionView.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 28/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GWAttractionViewModel, GWAttractionCell;

@interface GWAttractionView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) GWAttractionViewModel *viewModel;
@property (readwrite, nonatomic) CGFloat topHeight;
@property (readwrite, nonatomic) CGFloat descriptionHeight;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *attractionImageView;
@property (strong, nonatomic) NSLayoutConstraint *imageHeightConstraint;
@property (strong, nonatomic) GWAttractionCell *attractionSummaryView;
@property (strong, nonatomic) UITextView *attractionDescription;

- (id)initWithViewModel:(GWAttractionViewModel *)attractionViewModel;

@end
