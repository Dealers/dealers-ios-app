//
//  NewDealsTableViewCell.h
//  Dealers
//
//  Created by Gilad Lumbroso on 3/2/15.
//
//

#import <UIKit/UIKit.h>

@interface DealTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *storeIcon;
@property (weak, nonatomic) IBOutlet UILabel *store;
@property (weak, nonatomic) IBOutlet UIView *priceAndDiscountContainer;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UIImageView *likesIcon;
@property (weak, nonatomic) IBOutlet UILabel *likesCounter;
@property (weak, nonatomic) IBOutlet UIView *expiredTag;
@property (weak, nonatomic) IBOutlet UIView *separator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceDiscountHorizontalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likesStoreVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likesIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likesCounterHeightConstraint;


+ (UIColor *)randomBackgroundColors:(NSString *)colorNumber;


@end
