//
//  GWWalkOverviewView.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 20/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GWWalkViewModel, GWScrollView;

@interface GWWalkOverviewView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) GWWalkViewModel *viewModel;

// Container
@property (strong, nonatomic) GWScrollView *contentView;

// Header image
@property (readwrite, nonatomic) CGFloat topHeight;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) CAGradientLayer *gradient;
@property (strong, nonatomic) NSLayoutConstraint *imageHeightConstraint;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *mapLabel;
@property (strong, nonatomic) UIButton *headerButton;

// Attractions table
@property (strong, nonatomic) UITableView *attractionsTable;
@property (readwrite, nonatomic) CGFloat attractionsHeight;

// Footer
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIImageView *footerImageView;


@property (readwrite, nonatomic) float scrollInitialOffset;

//- (id)initWithImage:(UIImage *)image content:(UIView *)bottom footerImage:(UIImage *)footerImage;
- (id)initWithViewModel:(GWWalkViewModel *)walkViewModel;
@end
