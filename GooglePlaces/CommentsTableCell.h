//
//  CommentsTabelCell.h
//  Dealers
//
//  Created by Gilad Lumbroso on 9/8/14.
//
//

#import <UIKit/UIKit.h>

@interface CommentsTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *dealerProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *dealerName;
@property (weak, nonatomic) IBOutlet UILabel *commentBody;
@property (weak, nonatomic) IBOutlet UILabel *commentDate;
@property NSDateFormatter *dateFormatter;

@property (nonatomic) float requiredCellHeight;

@end
