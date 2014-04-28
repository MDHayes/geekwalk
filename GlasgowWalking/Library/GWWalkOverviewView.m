//
//  GWWalkOverviewView.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 20/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWWalkOverviewView.h"
#import "GWWalkViewModel.h"
#import "GWScrollView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat InitialTopHeight = 200.0;

@implementation GWWalkOverviewView

- (id)initWithViewModel:(GWWalkViewModel *)walkViewModel
{
    self = [super init];
    if (self) {
        // Sensible default, should be set by controller using this view
        // 64 is default 20px statusbar + 44px portrait nav bar
        _scrollInitialOffset = 64;
        _topHeight = InitialTopHeight;

        _viewModel = walkViewModel;
        _contentView = [GWScrollView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.delegate = self;
        _contentView.canCancelContentTouches = YES;
        [self addSubview:_contentView];

        // Top image
        _imageView = [[UIImageView alloc] initWithImage:_viewModel.overviewImage];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_contentView insertSubview:_imageView atIndex:0];

        // Top details
        _descriptionLabel = [UILabel new];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = [UIColor whiteColor];
        RACChannelTo(_descriptionLabel, text) = RACChannelTo(_viewModel, description);
        _descriptionLabel.numberOfLines = 3;
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView insertSubview:_descriptionLabel aboveSubview:_imageView];

        _detailLabel = [UILabel new];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [UIColor whiteColor];
        [[RACSignal combineLatest:@[RACObserve(_viewModel, attractions), RACObserve(_viewModel, distanceKm)]]
                subscribeNext:^(RACTuple *args) {
                    NSArray *attractions = args.first;
                    NSNumber *distance = args.last;
                    _detailLabel.text = [NSString stringWithFormat:@"%lu Attractions | %@ km",
                                                (unsigned long)attractions.count, distance];
                }];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView insertSubview:_detailLabel aboveSubview:_descriptionLabel];

        _mapLabel = [UILabel new];
        _mapLabel.textAlignment = NSTextAlignmentCenter;
        _mapLabel.textColor = [UIColor whiteColor];
        [_contentView insertSubview:_mapLabel aboveSubview:_detailLabel];
        _mapLabel.text = @"Map";
        _mapLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _mapLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _mapLabel.layer.borderWidth = 2.0f;

        // Interaction with top image
        _headerButton = [UIButton new];
        _headerButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView insertSubview:_headerButton aboveSubview:_mapLabel];

        // Attractions Table
        _attractionsTable = [UITableView new];
        _attractionsTable.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0
                                                                 blue:239/255.0 alpha:1.0];
        //_attractionsTable.separatorColor = [UIColor whiteColor];
        _attractionsTable.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView insertSubview:_attractionsTable aboveSubview:_headerButton];

        [RACObserve(self, attractionsHeight) subscribeNext:^(id height) {
            [self layoutIfNeeded];
        }];

        // Footer
        _footerView = [UIView new];
        _footerView.translatesAutoresizingMaskIntoConstraints = NO;
        _footerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];

        UIImage *footerImage = [UIImage imageNamed:@"science-icon"];
        _footerImageView = [[UIImageView alloc] initWithImage:footerImage];
        _footerImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_footerView addSubview:_footerImageView];
        [_contentView addSubview:_footerView];

        // Draw top image gradient last, we need the image frame for positioning
        [self layoutIfNeeded];
        CGRect gradientFrame = _imageView.frame;
        gradientFrame.size.height = 500;
        _gradient = [CAGradientLayer layer];
        _gradient.frame = gradientFrame;

        _gradient.colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithWhite:0.4f alpha:0.4f].CGColor,
                                (id)[UIColor colorWithWhite:0.0f alpha:0.4f].CGColor,                                nil];

        _gradient.locations = @[
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:0.85f],
                                    [NSNumber numberWithFloat:1.0f]
                                    ];
        [_imageView.layer addSublayer:_gradient];

    }
    return self;
}

#pragma mark - UIView

-(void)layoutSubviews
{
    [_contentView autoRemoveConstraintsAffectingView];
    [_contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

    [_imageView autoRemoveConstraintsAffectingView];
    [_imageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:_contentView.contentOffset.y];
    [_imageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView];
    [_imageView autoConstrainAttribute:ALDimensionWidth toAttribute:ALDimensionWidth ofView:self];
    [_imageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView];
    if (_imageHeightConstraint) {
        [_imageHeightConstraint autoRemove];
    }
    double headerImageHeight = _topHeight;
    if (_topHeight < 0) {
        headerImageHeight = 0;
    }
    _imageHeightConstraint = [_imageView autoSetDimension:ALDimensionHeight toSize:headerImageHeight];

    [_headerButton autoRemoveConstraintsAffectingView];
    [_headerButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:_contentView.contentOffset.y];
    [_headerButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView];
    [_headerButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView];
    [_headerButton autoConstrainAttribute:ALDimensionHeight toAttribute:ALDimensionHeight ofView:_imageView];

    [_attractionsTable autoRemoveConstraintsAffectingView];
    [_attractionsTable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_contentView withOffset:_topHeight + _contentView.contentOffset.y];
    [_attractionsTable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView];
    [_attractionsTable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView];
    [_attractionsTable autoSetDimension:ALDimensionHeight toSize:_attractionsHeight];

    [_mapLabel autoRemoveConstraintsAffectingView];
    [_mapLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_contentView withOffset:InitialTopHeight - 20.0];
    [_mapLabel autoSetDimension:ALDimensionHeight toSize:35];
    [_mapLabel autoSetDimension:ALDimensionWidth toSize:100];
    [_mapLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self];

    [_detailLabel autoRemoveConstraintsAffectingView];
    [_detailLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_mapLabel withOffset:-15.0];
    [_detailLabel autoSetDimensionsToSize:CGSizeMake(200, 21)];
    [_detailLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self];

    [_descriptionLabel autoRemoveConstraintsAffectingView];
    [_descriptionLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_detailLabel withOffset:-15.0];
    [_descriptionLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-20.0];
    [_descriptionLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:20.0];

    [_footerView autoRemoveConstraintsAffectingView];
    [_footerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_attractionsTable];
    [_footerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_contentView];
    [_footerView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [_footerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [_footerView autoSetDimension:ALDimensionHeight toSize:300];

    [_footerImageView autoRemoveConstraintsAffectingView];
    [_footerImageView autoSetDimensionsToSize:CGSizeMake(100, 100)];
    [_footerImageView autoCenterInSuperview];

    [super layoutSubviews];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yPos = -scrollView.contentOffset.y;
    _topHeight = InitialTopHeight + yPos;

    // Gradually hide elements in front of image with scrolling
    double offset = yPos - _scrollInitialOffset;
    if (offset >= 0) {
        float targetOpacity = 1.0 - (offset / 100.0);
        _mapLabel.layer.opacity = targetOpacity;
        _detailLabel.layer.opacity = targetOpacity;
        _descriptionLabel.layer.opacity = targetOpacity;
        _gradient.opacity = targetOpacity;
    }

    // Resize image and gradient
    if (_topHeight >= 0) {
        if (_imageHeightConstraint) {
            [_imageHeightConstraint autoRemove];
        }
        _imageHeightConstraint = [_imageView autoSetDimension:ALDimensionHeight toSize:_topHeight];
    }
}

@end
