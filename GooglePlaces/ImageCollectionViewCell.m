//
//  ImageCollectionViewCell.m
//  Dealers
//
//  Created by Gilad Lumbroso on 5/19/15.
//
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 1.0);
    self.layer.shadowRadius = 1.5;
    self.layer.shadowOpacity = 0.25;
}

@end
