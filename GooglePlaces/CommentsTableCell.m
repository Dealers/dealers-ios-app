//
//  CommentsTabelCell.m
//  Dealers
//
//  Created by Gilad Lumbroso on 9/8/14.
//
//

#import "CommentsTableCell.h"

@implementation CommentsTableCell

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
    
    NSDictionary *attributes = @{NSFontAttributeName : self.commentBody.font};
    CGSize boundingRect = CGSizeMake(250.0 ,MAXFLOAT);
    CGRect commentBodyFrame = [self.commentBody.text boundingRectWithSize:boundingRect
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:attributes
                                                            context:nil];
    
    CGFloat x = self.commentBody.frame.origin.x;
    CGFloat y = self.commentBody.frame.origin.y;
    CGFloat width = self.commentBody.frame.size.width;
    CGFloat height = ceil(commentBodyFrame.size.height);

    self.commentBody.frame = CGRectMake(x, y, width, height);
}


@end
