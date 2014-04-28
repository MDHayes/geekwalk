//
//  GWWalkSummaryCell.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 18/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GWWalkViewModel;

@interface GWWalkSummaryCell : UITableViewCell
@property (strong, nonatomic) GWWalkViewModel *viewModel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UILabel *exploreLabel;
@property (strong, nonatomic) UIImageView *backgroundImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
          viewModel:(GWWalkViewModel *)walkViewModel;
@end
