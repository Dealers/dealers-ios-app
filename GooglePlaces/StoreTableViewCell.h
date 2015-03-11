//
//  StoresNearbyCell.h
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 9/1/14.
//
//

#import <UIKit/UIKit.h>

@interface StoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *categoryIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
