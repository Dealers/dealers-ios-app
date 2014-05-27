//
//  ProfileViewController.h
//  Dealers
//
//  Created by itzik berrebi on 11/6/13.
//
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UINavigationControllerDelegate>
{
    int GAP;
    int gap2;
    int GAPForLikeView;
    int gap2ForLikeView;
    BOOL isShortCell;
    BOOL isUpdatingNow;
    int cellNumberInScrollView;
    int cellsNumbersInFillWithImages;
    int cellNumberInScrollViewForLikeView;
    int cellsNumbersInFillWithImagesForLikeView;
    BOOL currentVC;
    bool didLoadView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *dealsView;
@property (weak, nonatomic) IBOutlet UIView *likesView;

@property (weak, nonatomic) IBOutlet UIImageView *dealerProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *dealerName;
@property (weak, nonatomic) IBOutlet UIImageView *dealerRankImage;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UIButton *dealsViewButton;
@property (weak, nonatomic) IBOutlet UIButton *likesViewButton;
- (IBAction)dealsViewButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *likesViewButtonClicked;
- (IBAction)likesViewButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
- (IBAction)returnButtonClicked:(id)sender;

@property (strong, nonatomic)  UIImage *image2;
@property (strong, nonatomic)  UIImage *image2ForLikeView;

@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;

@property (nonatomic, strong) NSMutableArray *TITLEMARRAY;
@property (nonatomic, strong) NSMutableArray *DESCRIPTIONMARRAY;
@property (nonatomic, strong) NSMutableArray *STOREMARRAY;
@property (nonatomic, strong) NSMutableArray *PRICEMARRAY;
@property (nonatomic, strong) NSMutableArray *DISCOUNTMARRAY;
@property (nonatomic, strong) NSMutableArray *EXPIREMARRAY;
@property (nonatomic, strong) NSMutableArray *LIKEMARRAY;
@property (nonatomic, strong) NSMutableArray *COMMENTMARRAY;
@property (nonatomic, strong) NSMutableArray *CLIENTMARRAY;
@property (nonatomic, strong) NSMutableArray *PHOTOIDMARRAY;
@property (nonatomic, strong) NSMutableArray *PHOTOIDMARRAYCONVERT;
@property (nonatomic, strong) NSMutableArray *FAVARRAY;
@property (nonatomic, strong) NSMutableArray *CATEGORYARRAY;
@property (nonatomic, strong) NSMutableArray *SIGNARRAY;
@property (nonatomic, strong) NSMutableArray *DEALIDARRAY;
@property (nonatomic, strong) NSMutableArray *uploadDateArray;
@property (nonatomic, strong) NSMutableArray *onlineOrLocalArray;

@property (nonatomic, strong) NSMutableArray *titleArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *descriptionArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *storeArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *priceArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *discountArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *expireArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *likesCountArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *commentsCountArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *clientidArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *photoidArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *photoidConvertedArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *categoryArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *signArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *dealidArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *uploadDateArrayForLikesView;
@property (nonatomic, strong) NSMutableArray *onlineOrLocalArrayForLikesView;

@property (nonatomic, weak) NSString *deals;
@property (nonatomic, weak) NSString *likes;
@property (strong, nonatomic) NSString *dealsUserLikes;
@property (weak, nonatomic) IBOutlet UILabel *dealsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;

@property (nonatomic, strong) NSString *dealerId;
@property (nonatomic, strong) NSString *didComeFromLikesTable;

@end
