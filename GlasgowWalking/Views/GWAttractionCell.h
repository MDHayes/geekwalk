//
//  GWAttractionCell.h
//  GlasgowWalking
//
//  Created by Chris Sloey on 20/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GWAttractionViewModel, GWAttractionCell, CSCompassView;
@interface GWAttractionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) CSCompassView *compassView;
@property (strong, nonatomic) GWAttractionCell *attractionView;
@property (strong, nonatomic) GWAttractionViewModel *viewModel;

@end
