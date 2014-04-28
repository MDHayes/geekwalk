//
//  GWWalksView.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 18/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWWalksView.h"

@implementation GWWalksView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    UIImage *hexImage = [UIImage imageNamed:@"science-icon"];
    _iconImageView = [[UIImageView alloc] initWithImage:hexImage];
    [self insertSubview:_iconImageView atIndex:0];
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;

    _walksTableView = [UITableView new];
    _walksTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_walksTableView];
    _walksTableView.translatesAutoresizingMaskIntoConstraints = NO;

    return self;
}

#pragma mark - UIView

-(void)layoutSubviews
{
    [_iconImageView autoRemoveConstraintsAffectingView];
    [_iconImageView autoSetDimensionsToSize:CGSizeMake(75, 75)];
    [_iconImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-25];
    [_iconImageView autoAlignAxis:ALAxisVertical toSameAxisOfView:self];

    [_walksTableView autoRemoveConstraintsAffectingView];
    [_walksTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, 0, 0)];

    [super layoutSubviews];
}

@end
