//
//  CommentsTabelCell.h
//  Dealers
//
//  Created by Gilad Lumbroso on 9/8/14.
//
//

#import <UIKit/UIKit.h>
#import "ElasticLabel.h"

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *dealerProfilePicPlaceholder;
@property (strong, nonatomic) IBOutlet UIButton *dealerProfilePic;
@property (strong, nonatomic) IBOutlet UIButton *dealerName;
@property (strong, nonatomic) IBOutlet ElasticLabel *commentBody;
@property (strong, nonatomic) IBOutlet UILabel *commentDate;
@property NSDateFormatter *dateFormatter;

@end
