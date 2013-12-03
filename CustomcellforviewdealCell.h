//
//  CustomcellforviewdealCell.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import <UIKit/UIKit.h>

@interface CustomcellforviewdealCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *Discountlabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIImageView *LikeImageView;
@property (weak, nonatomic) IBOutlet UILabel *LikeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *CommentImageView;
@property (weak, nonatomic) IBOutlet UILabel *CommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *StoreLabel;
//@property (weak, nonatomic) IBOutlet UIButton *SavetoFav;
//@property (weak, nonatomic) IBOutlet UIButton *SavetoFavSelected;
@property (weak, nonatomic) IBOutlet NSString *YesNo;

//-(IBAction)ChangeFavButton:(id)sender;
//-(IBAction)ChangeFavSelectedButton:(id)sender;

@end
