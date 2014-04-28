//
//  GWAttractionView.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 28/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWAttractionView.h"
#import "GWAttractionViewModel.h"
#import "GWAttractionCell.h"

static int InitialTopHeight = 200;

@implementation GWAttractionView

- (id)initWithViewModel:(GWAttractionViewModel *)attractionViewModel
{
    self = [super init];
    if (self) {
        _viewModel = attractionViewModel;
        _topHeight = InitialTopHeight;

        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_scrollView];

        _attractionImageView = [[UIImageView alloc] init];
        _attractionImageView.image = _viewModel.image;
        _attractionImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _attractionImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_attractionImageView];

        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GWAttractionDetailsView" owner:self options:nil];
        _attractionSummaryView = [topLevelObjects objectAtIndex:0];
        _attractionSummaryView.viewModel = _viewModel;
        _attractionSummaryView.translatesAutoresizingMaskIntoConstraints = NO;
        [_scrollView addSubview:_attractionSummaryView];

        // Attributed text for description
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7;
        paragraphStyle.firstLineHeadIndent = 15;
        paragraphStyle.headIndent = 15;
        paragraphStyle.tailIndent = -15;

        NSDictionary *attrsDictionary = @{
                                          NSFontAttributeName : [UIFont systemFontOfSize:14.0],
                                          NSParagraphStyleAttributeName: paragraphStyle
                                         };

        _attractionDescription = [UITextView new];
        _attractionDescription.attributedText = [[NSAttributedString alloc] initWithString:_viewModel.details
                                                                                attributes:attrsDictionary];
        _attractionDescription.textColor = [UIColor colorWithRed:128.0/255.0 green:136.0/255.0 blue:146.0/255.0 alpha:1.0];
        _attractionDescription.userInteractionEnabled = NO;
        _attractionDescription.selectable = NO;
        _attractionDescription.translatesAutoresizingMaskIntoConstraints = NO;
        [_scrollView addSubview:_attractionDescription];

        _descriptionHeight = 0;
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_scrollView autoRemoveConstraintsAffectingView];
    [_scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

    [_attractionImageView autoRemoveConstraintsAffectingView];
    [_attractionImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self
                           withOffset:_scrollView.contentOffset.y];
    [_attractionImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_scrollView];
    [_attractionImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_scrollView];
    [_attractionImageView autoConstrainAttribute:ALDimensionWidth toAttribute:ALDimensionWidth ofView:self];

    CGFloat imageHeight = _topHeight;
    if (imageHeight < 0) {
        imageHeight = 0;
    }
    _imageHeightConstraint = [_attractionImageView autoSetDimension:ALDimensionHeight toSize:imageHeight];

    [_attractionSummaryView autoRemoveConstraintsAffectingView];
    [_attractionSummaryView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_scrollView withOffset:imageHeight + _scrollView.contentOffset.y];
    [_attractionSummaryView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_scrollView];
    [_attractionSummaryView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_scrollView];
    [_attractionSummaryView autoSetDimension:ALDimensionHeight toSize:60.0];

    [_attractionDescription autoRemoveConstraintsAffectingView];
    [_attractionDescription autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_attractionSummaryView];
    [_attractionDescription autoSetDimension:ALDimensionHeight toSize:_descriptionHeight];
    [_attractionDescription autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [_attractionDescription autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [_attractionDescription autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_scrollView];

    [super layoutSubviews];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yPos = -scrollView.contentOffset.y;
    _topHeight = InitialTopHeight + yPos;

    // Resize image
    if (_topHeight >= 0) {
        if (_imageHeightConstraint) {
            [_imageHeightConstraint autoRemove];
        }
        _imageHeightConstraint = [_attractionImageView autoSetDimension:ALDimensionHeight toSize:_topHeight];
    }
}

@end
