//
//  DealsTableCell.h
//  Dealers
//
//  Created by Gilad Lumbroso on 12/1/14.
//
//

#import <UIKit/UIKit.h>

@interface DealsTableCell : UITableViewCell {
    
    CGFloat xPointTitle;
    CGFloat xPointDetails;
}


@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *storeIcon;
@property (weak, nonatomic) IBOutlet UILabel *store;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UIImageView *likesIcon;
@property (weak, nonatomic) IBOutlet UILabel *likesCounter;
@property (weak, nonatomic) IBOutlet UILabel *expiredTag;

@end
