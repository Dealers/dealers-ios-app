//
//  DealersTableCell.h
//  Dealers
//
//  Created by Gilad Lumbroso on 12/16/14.
//
//

#import <UIKit/UIKit.h>

@interface DealersTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *profilePicPlaceholder;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *fullName;

@end
