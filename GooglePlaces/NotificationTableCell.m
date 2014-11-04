//
//  NotificationTableCell.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/11/14.
//
//

#import "NotificationTableCell.h"

@implementation NotificationTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.image.layer.cornerRadius = self.image.frame.size.width / 2;
    self.image.layer.masksToBounds = YES;
}

@end
