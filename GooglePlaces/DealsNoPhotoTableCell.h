//
//  DealsNoPhotoTableCell.h
//  Dealers
//
//  Created by Gilad Lumbroso on 12/1/14.
//
//

#import <UIKit/UIKit.h>

@interface DealsNoPhotoTableCell : UITableViewCell {
    
    CGFloat xPointTitle;
    CGFloat xPointDetails;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundWithImage;
@property (weak, nonatomic) IBOutlet UIView *backgroundWithColor;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *likesCounter;
@property (weak, nonatomic) IBOutlet UIImageView *likesIcon;
@property (weak, nonatomic) IBOutlet UILabel *store;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *expiredTag;

+ (UIImage *)randomBackgroundImages;
+ (UIColor *)randomBackgroundColors:(NSString *)colorNumber;

@end
