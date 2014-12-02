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
}

@end
