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
    
    self.dealerProfilePic.layer.cornerRadius = self.dealerProfilePic.frame.size.width / 2;
    self.dealerProfilePic.layer.masksToBounds = YES;
    
    NSDictionary *attributes = @{NSFontAttributeName : self.commentBody.font};
    CGSize boundingRect = CGSizeMake(250.0 ,MAXFLOAT);
    CGRect commentBodyFrame = [self.commentBody.text boundingRectWithSize:boundingRect
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:attributes
                                                            context:nil];
    
    self.commentBody.frame = CGRectMake(self.commentBody.frame.origin.x,
                                        self.commentBody.frame.origin.y,
                                        self.commentBody.frame.size.width,
                                        commentBodyFrame.size.height);
}

@end
