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
    [self.commentBody sizeToFit];
    self.dealerProfilePic.layer.cornerRadius = self.dealerProfilePic.frame.size.width / 2;
    self.dealerProfilePic.layer.masksToBounds = YES;
    
    CGSize maxSize = CGSizeMake(self.commentBody.frame.size.width, CGFLOAT_MAX);
    CGSize requiredSize = [self.commentBody sizeThatFits:maxSize];
    self.commentBody.frame = CGRectMake(self.commentBody.frame.origin.x, self.commentBody.frame.origin.y, requiredSize.width, requiredSize.height);
    
    // Calculate cell height
    
    requiredCellHeight = 8.0f + self.dealerName.frame.size.height + 4.0f + 8.0f;
    requiredCellHeight += self.commentBody.frame.size.height;
}

@end
