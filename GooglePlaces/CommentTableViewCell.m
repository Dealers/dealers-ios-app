//
//  CommentsTabelCell.m
//  Dealers
//
//  Created by Gilad Lumbroso on 9/8/14.
//
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dealerProfilePicPlaceholder.layer.cornerRadius = self.dealerProfilePicPlaceholder.frame.size.width / 2;
    self.dealerProfilePicPlaceholder.layer.masksToBounds = YES;
    self.dealerProfilePic.layer.cornerRadius = self.dealerProfilePic.frame.size.width / 2;
    self.dealerProfilePic.layer.masksToBounds = YES;
    self.dealerProfilePic.imageView.contentMode = UIViewContentModeScaleAspectFill;
}


@end
