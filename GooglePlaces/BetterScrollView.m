//
//  BetterScrollView.m
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/4/14.
//
//

#import "BetterScrollView.h"

@implementation BetterScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
