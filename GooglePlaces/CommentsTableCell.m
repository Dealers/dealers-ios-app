//
//  CommentsTabelCell.m
//  Dealers
//
//  Created by Gilad Lumbroso on 9/8/14.
//
//

#import "CommentsTableCell.h"

@implementation CommentsTableCell

@synthesize requiredCellHeight;

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
    
    self.dealerProfilePic.layer.cornerRadius = self.dealerProfilePic.frame.size.width / 2;
    self.dealerProfilePic.layer.masksToBounds = YES;
    
    CGSize maxSize = CGSizeMake(250.0f, CGFLOAT_MAX);
    CGSize requiredSize = [self.commentBody sizeThatFits:maxSize];
    self.commentBody.frame = CGRectMake(self.commentBody.frame.origin.x, self.commentBody.frame.origin.y, requiredSize.width, requiredSize.height);
    
    // Calculate cell height
    
    requiredCellHeight = 10.0f + self.dealerName.frame.size.height + 6.0f + 10.0f;
    requiredCellHeight += self.commentBody.frame.size.height;
}

@end
