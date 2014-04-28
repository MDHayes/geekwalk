//
//  GWAttractionCell.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 20/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWAttractionCell.h"
#import "GWAttractionViewModel.h"
#import "CSLocationManager.h"
#import "GWAttractionCell.h"
#import "CSCompassView.h"

@implementation GWAttractionCell

-(void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    UIColor *textColor = [UIColor colorWithRed:128.0/255.0 green:136.0/255.0 blue:146.0/255.0 alpha:1.0];

    // Name
    self.nameLabel.textColor = textColor;
    RACChannelTo(self.nameLabel, text) = RACChannelTo(self, viewModel.name);

    // Description
    self.descriptionLabel.textColor = textColor;
    [[RACSignal combineLatest:@[RACObserve(self, viewModel.entryDescription),
                                RACObserve(self, viewModel.openingTimes)]]
     subscribeNext:^(RACTuple *values) {
         self.descriptionLabel.text = [NSString stringWithFormat:@"%@ | %@",
                                       _viewModel.entryDescription, _viewModel.openingTimes];
     }];

    // Type image
    self.typeImageView.layer.masksToBounds = YES;
    self.typeImageView.layer.cornerRadius = 20.0f;
    RACChannelTo(self.typeImageView, image) = RACChannelTo(self, viewModel.typeImage);

    // Compass
    self.compassView = [[CSCompassView alloc] initWithFrame:CGRectMake(275, 10, 30, 30)];
    [self addSubview:self.compassView];
    RACChannelTo(self.compassView, bearing) = RACChannelTo(self, viewModel.bearing);

    // Distance
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    self.distanceLabel.adjustsFontSizeToFitWidth = YES;
    self.distanceLabel.minimumScaleFactor = 0.66;
    self.distanceLabel.textColor = textColor;
    [RACObserve(self, viewModel.distanceMeters) subscribeNext:^(id distanceMeters) {
        if ([distanceMeters floatValue] < 100) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%d m", (int)round([distanceMeters floatValue])];
        } else {
            self.distanceLabel.text = [NSString stringWithFormat:@"%.02f km", [distanceMeters floatValue]/1000.0];
        }
    }];
}

#pragma mark - UIView

-(void)layoutSubviews
{
    [_attractionView autoRemoveConstraintsAffectingView];
    [_attractionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

    [super layoutSubviews];
}

#pragma mark - UITableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
