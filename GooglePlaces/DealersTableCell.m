//
//  DealersTableCell.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/16/14.
//
//

#import "DealersTableCell.h"

@implementation DealersTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    self.profilePic.layer.masksToBounds = YES;
    self.profilePicPlaceholder.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    self.profilePicPlaceholder.layer.masksToBounds = YES;
}

@end
