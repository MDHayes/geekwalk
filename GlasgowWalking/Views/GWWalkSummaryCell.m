//
//  GWWalkSummaryCell.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 18/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWWalkSummaryCell.h"
#import "GWWalkViewModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation GWWalkSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
          viewModel:(GWWalkViewModel *)walkViewModel
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _viewModel = walkViewModel;

        // Image
        UIImage *backgroundImage = _viewModel.overviewImage;
        _backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self setBackgroundView:_backgroundImageView];
        RACChannelTo(self, backgroundView) = RACChannelTo(self, backgroundImageView);

        // Dark layer over image to make white text visible
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        CGRect gradientFrame = self.frame;
        gradientFrame.size.height = 200;
        gradientLayer.frame = gradientFrame;

        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithWhite:0.4f alpha:0.4f].CGColor,
                                (id)[UIColor colorWithWhite:0.0f alpha:0.4f].CGColor,
                                nil];

        gradientLayer.locations = @[
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:0.85f],
                                    [NSNumber numberWithFloat:1.0f]
                                    ];

        [_backgroundImageView.layer addSublayer:gradientLayer];

        // Name
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        [self addSubview:_nameLabel];
        RACChannelTo(_nameLabel, text) = RACChannelTo(self, viewModel.name);
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;

        // Explore button
        _exploreLabel = [UILabel new];
        _exploreLabel.textAlignment = NSTextAlignmentCenter;
        _exploreLabel.textColor = [UIColor whiteColor];
        [self addSubview:_exploreLabel];
        _exploreLabel.text = @"Explore"; // TODO viewModel
        _exploreLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _exploreLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _exploreLabel.layer.borderWidth = 2.0f;

        // Description
        _descriptionLabel = [UILabel new];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.numberOfLines = 3;
        _descriptionLabel.textColor = [UIColor whiteColor];
        [self addSubview:_descriptionLabel];
        RACChannelTo(_descriptionLabel, text) = RACChannelTo(self, viewModel.description);
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

#pragma mark - UITableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_nameLabel autoRemoveConstraintsAffectingView];
    [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [_nameLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withOffset:20];
    [_nameLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self];

    [_exploreLabel autoRemoveConstraintsAffectingView];
    [_exploreLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-20];
    [_exploreLabel autoSetDimension:ALDimensionHeight toSize:35];
    [_exploreLabel autoSetDimension:ALDimensionWidth toSize:100];
    [_exploreLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];

    [_descriptionLabel autoRemoveConstraintsAffectingView];
    [_descriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameLabel withOffset:20];
    [_descriptionLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_exploreLabel withOffset:-20];
    [_descriptionLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:20];
    [_descriptionLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-20];

    [super layoutSubviews];
}

@end
