//
//  CommentsTabelCell.h
//  Dealers
//
//  Created by Gilad Lumbroso on 9/8/14.
//
//

#import <UIKit/UIKit.h>

@interface CommentsTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *dealerProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *dealerName;
@property (strong, nonatomic) IBOutlet UILabel *commentBody;
@property (strong, nonatomic) IBOutlet UILabel *commentDate;
@property NSDateFormatter *dateFormatter;

@end
