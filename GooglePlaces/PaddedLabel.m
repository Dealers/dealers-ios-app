//
//  PaddedLabel.m
//  Dealers
//
//  Created by Gilad Lumbroso on 5/13/15.
//
//

#import "PaddedLabel.h"

@implementation PaddedLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = UIEdgeInsetsMake(0, 5, 0, 3);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
