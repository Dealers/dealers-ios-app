//
//  NewDealsTableViewCell.m
//  Dealers
//
//  Created by Gilad Lumbroso on 3/2/15.
//
//

#import "DealTableViewCell.h"

@implementation DealTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setWritingDirection];
    [self styleExpiredTag];
    [self stylePriceAndDiscountContainer];
}

- (void)setWritingDirection
{
    if ([[[NSBundle mainBundle] preferredLocalizations].firstObject isEqualToString:@"he"]) {
        self.title.textAlignment = NSTextAlignmentRight;
        self.store.textAlignment = NSTextAlignmentRight;
        self.likesCounter.textAlignment = NSTextAlignmentRight;
    }
}

- (void)styleExpiredTag
{
    self.expiredTag.layer.cornerRadius = 5.0;
    self.expiredTag.layer.masksToBounds = YES;
    self.expiredTag.layer.borderWidth = 1.5;
    self.expiredTag.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)stylePriceAndDiscountContainer
{
    self.priceAndDiscountContainer.layer.cornerRadius = 5.0;
    self.priceAndDiscountContainer.layer.masksToBounds = YES;
}

+ (UIColor *)randomBackgroundColors:(NSString *)colorNumber
{
    switch (colorNumber.intValue) {
        case 0:
            return [UIColor colorWithRed:79.0/255.0 green:195.0/255.0 blue:247.0/255.0 alpha:1.0]; // Blue
            break;
        case 1:
            return [UIColor colorWithRed:129.0/255.0 green:216.0/255.0 blue:132.0/255.0 alpha:1.0]; // Green
            break;
        case 2:
            return [UIColor colorWithRed:255.0/255.0 green:100.0/255.0 blue:105.0/255.0 alpha:1.0]; // Red
            break;
        case 3:
            return [UIColor colorWithRed:255.0/255.0 green:212.0/255.0 blue:40.0/255.0 alpha:1.0]; // Yellow
            break;
            
        default:
            return nil;
            break;
    }
}


@end
