//
//  ViewonedealViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewonedealViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL LikeOrUnlike;
    int numofpics;
    int currentpage;
    int lowestYPoint;
    int maxXPoint;
    BOOL flag;
    BOOL viewDidApear;
    int cellNumberInScrollView;
    BOOL isUpdatingNow;
    int gapDealersLikes;
    BOOL likesView;
    int offsetForIcons;
}
@property (strong,nonatomic) NSArray *DealersDataWhoLikesTheDealArray;

@property (strong,nonatomic) NSMutableArray *dealersNameArray;
@property (strong,nonatomic) NSMutableArray *dealersLocationArray;
@property (strong,nonatomic) NSMutableArray *dealersPhotoArray;
@property (strong,nonatomic) NSMutableArray *dealersPhotoDataArray;
@property (strong,nonatomic) NSMutableArray *dealersidArray;
@property (strong,nonatomic) NSMutableArray *dealsPhotosidArray;
@property (strong,nonatomic) NSMutableArray *dealsPhotosArray;



@property (strong,nonatomic) NSString *titleLabelFromMyFeeds;
@property (strong,nonatomic) NSString *storeLabelFromMyFeeds;
@property (strong,nonatomic) NSString *categoryLabelFromMyFeeds;
@property (strong,nonatomic) NSString *priceLabelFromMyFeeds;
@property (strong,nonatomic) NSString *discountLabelFromMyFeeds;
@property (strong,nonatomic) NSString *expireLabelFromMyFeeds;
@property (strong,nonatomic) NSString *descriptionLabelFromMyFeeds;
@property (strong,nonatomic) NSString *photoIdLabelFromMyFeeds;
@property (strong,nonatomic) NSString *likeLabelFromMyFeeds;
@property (strong,nonatomic) NSString *commentLabelFromMyFeeds;
@property (strong,nonatomic) NSString *clientIdLabelFromMyFeeds;
@property (strong,nonatomic) NSString *signLabelFromMyFeeds;
@property (strong,nonatomic) NSString *likeornotLabelFromMyFeeds;
@property (strong,nonatomic) NSString *dealidLabelFromMyFeeds;
@property (strong,nonatomic) NSString *localoronlineLabelFromMyFeeds;

@property (strong,nonatomic) NSString *dealerUploadDealID;
@property (strong,nonatomic) NSString *isShoetCell;

@property (strong,nonatomic) NSString *urlImage;
@property (strong,nonatomic) NSString *urlImage2;
@property (strong,nonatomic) NSString *urlImage3;
@property (strong,nonatomic) NSString *urlImage4;



@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIImageView *productimage;
@property (weak, nonatomic) IBOutlet UIImageView *clientimage;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *storelabel;
@property (weak, nonatomic) IBOutlet UILabel *categorylabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;
@property (weak, nonatomic) IBOutlet UILabel *discountlabel;
@property (weak, nonatomic) IBOutlet UILabel *expirelabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionlabel;
@property (weak, nonatomic) IBOutlet UILabel *likelabel;
@property (weak, nonatomic) IBOutlet UILabel *commentlabel;
@property (weak, nonatomic) IBOutlet UILabel *dealersNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadDateLabel;

- (IBAction)ReturnButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButton;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButtonFull;

@property (weak, nonatomic) IBOutlet UIImageView *TitleIcon;
@property (weak, nonatomic) IBOutlet UIImageView *StoreIcon;
@property (weak, nonatomic) IBOutlet UIImageView *CategoryIcon;
@property (weak, nonatomic) IBOutlet UIImageView *PriceIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ExpireIcon;
@property (weak, nonatomic) IBOutlet UIImageView *DescriptionIcon;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;

@property (weak, nonatomic) IBOutlet UIView *SecondView;

@property (weak, nonatomic) IBOutlet UIButton *LikeButton;
- (IBAction)LikeButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *CommentButton;
- (IBAction)CommentButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ShareButton;
- (IBAction)ShareButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *captureImage;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage2;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage3;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage4;

@property (strong, nonatomic)  UIImage *tempImage;
@property (strong, nonatomic)  UIImage *tempImage2;
@property (strong, nonatomic)  UIImage *tempImage3;
@property (strong, nonatomic)  UIImage *tempImage4;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *cameraScrollView;

@property (weak, nonatomic) IBOutlet UIView *ViewLikes;
@property (weak, nonatomic) IBOutlet UITableView *tableViewLikes;

- (IBAction)dealerProfileButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *likesandshareView;
@property (weak, nonatomic) IBOutlet UIImageView *likesCountImage;
@property (weak, nonatomic) IBOutlet UIImageView *shareCountImage;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *shreCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *urlSiteButton;
- (IBAction)urlSiteButtonClicked:(id)sender;

@end
