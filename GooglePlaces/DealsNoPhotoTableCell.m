//
//  DealsNoPhotoTableCell.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/1/14.
//
//

#import "DealsNoPhotoTableCell.h"

#define SIDE_MARGIN 15

@implementation DealsNoPhotoTableCell

- (void)awakeFromNib {
    // Initialization code
    self.separatorInset = UIEdgeInsetsZero;
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)layoutSubviews
{
    xPointTitle = self.contentView.frame.size.width - SIDE_MARGIN;
    xPointDetails = self.contentView.frame.size.width -SIDE_MARGIN;
    
    CGFloat x, y, width, height;
    
    // Set the title and likes section according to the input
    
    if (self.likesCounter.hidden == NO) {
        
        NSDictionary *attributes = @{NSFontAttributeName : self.likesCounter.font};
        CGSize boundingRect = CGSizeMake(MAXFLOAT ,16.0);
        CGRect likesCounterBodyFrame = [self.likesCounter.text boundingRectWithSize:boundingRect
                                                                            options:NSStringDrawingUsesFontLeading
                                                                         attributes:attributes
                                                                            context:nil];
        x = self.contentView.frame.size.width - likesCounterBodyFrame.size.width - SIDE_MARGIN;
        y = self.likesCounter.frame.origin.y;
        width = likesCounterBodyFrame.size.width;
        height = self.likesCounter.frame.size.height;
        
        self.likesCounter.frame = CGRectMake(x, y, width, height);
        
        CGRect likesIconFrame = self.likesIcon.frame;
        likesIconFrame.origin.x = self.likesCounter.frame.origin.x - 5 - self.likesIcon.frame.size.width;
        self.likesIcon.frame = likesIconFrame;
        
        xPointTitle = self.likesIcon.frame.origin.x - 5;
    }
    
    CGRect titleFrame = self.title.frame;
    titleFrame.size.width = xPointTitle - self.title.frame.origin.x;
    self.title.frame = titleFrame;
    
    // set the details section according to the input
    
    if (self.discount.hidden == NO) {
        
        NSDictionary *discountAttributes = @{NSFontAttributeName : self.discount.font};
        CGSize discountBoundingRect = CGSizeMake(MAXFLOAT ,44.0);
        CGRect discountBodyFrame = [self.discount.text boundingRectWithSize:discountBoundingRect
                                                                    options:NSStringDrawingUsesFontLeading
                                                                 attributes:discountAttributes
                                                                    context:nil];
        x = self.contentView.frame.size.width - discountBodyFrame.size.width - SIDE_MARGIN;
        y = self.discount.frame.origin.y;
        width = discountBodyFrame.size.width;
        height = self.discount.frame.size.height;
        
        self.discount.frame = CGRectMake(x, y, width, height);
        xPointDetails = self.discount.frame.origin.x - 10;
    }
    
    if (self.price.hidden == NO) {
        NSDictionary *priceAttributes = @{NSFontAttributeName : self.price.font};
        CGSize priceBoundingRect = CGSizeMake(MAXFLOAT ,44.0);
        CGRect priceBodyFrame = [self.price.text boundingRectWithSize:priceBoundingRect
                                                              options:NSStringDrawingUsesFontLeading
                                                           attributes:priceAttributes
                                                              context:nil];
        x = xPointDetails - priceBodyFrame.size.width;
        y = self.price.frame.origin.y;
        width = priceBodyFrame.size.width;
        height = self.price.frame.size.height;
        
        self.price.frame = CGRectMake(x, y, width, height);
        xPointDetails = self.price.frame.origin.x - 10;
    }
    
    CGRect storeFrame = self.store.frame;
    storeFrame.size.width = xPointDetails - self.store.frame.origin.x;
    self.store.frame = storeFrame;
    
    // Setting the separator inset
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // Setting the exipred tag
    self.expiredTag.layer.cornerRadius = 5.0;
    self.expiredTag.layer.masksToBounds = YES;
    self.expiredTag.layer.borderWidth = 1.5;
    self.expiredTag.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.expiredTag.text = NSLocalizedString(@"Expired", nil);
}

+ (UIImage *)randomBackgroundImages
{
    int random = arc4random_uniform(4);
    switch (random) {
        case 0:
            return [UIImage imageNamed:@"Background 1"];
            break;
        case 1:
            return [UIImage imageNamed:@"Background 2"];
            break;
        case 2:
            return [UIImage imageNamed:@"Background 3"];
            break;
        case 3:
            return [UIImage imageNamed:@"Background 4"];
            break;
            
        default:
            return nil;
            break;
    }
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
            return [UIColor colorWithRed:190.0/255.0 green:158.0/255.0 blue:131.0/255.0 alpha:1.0]; // Brown
            break;
            
        default:
            return nil;
            break;
    }
}


@end
