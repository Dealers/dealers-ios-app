//
//  MyFeedsViewController.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 2/16/14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MyFeedsViewController : UIViewController <UINavigationBarDelegate, UINavigationControllerDelegate, UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    int GAP;
    int gap2;
    BOOL isShortCell;
    BOOL isUpdatingNow;
    int cellNumberInScrollView;
    int cellsNumbersInFillWithImages;
    BOOL myFeedsFirstTime;
}

@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *AddDealButton;
@property (weak, nonatomic) IBOutlet UIButton *MyFeedButton;
@property (weak, nonatomic) IBOutlet UIButton *ExploreButton;
@property (weak, nonatomic) IBOutlet UIButton *ProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *MoreButton;

@property (strong, nonatomic)  UIImage *image2;

@property (weak, nonatomic) IBOutlet UIImageView *TapBar;
@property (weak, nonatomic) IBOutlet UIImageView *DealersTitle;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingImage;
@property (weak, nonatomic) IBOutlet UIImageView *exploreImage;
@property (weak, nonatomic) IBOutlet UIImageView *moreImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *myfeedsImage;

@property (weak, nonatomic) IBOutlet UIButton *denyClickingOnCellsButton;

@property (weak, nonatomic) IBOutlet UILabel *OnlineText;
@property (weak, nonatomic) IBOutlet UILabel *LocalText;
@property (weak, nonatomic) IBOutlet UILabel *MyFeedText;
@property (weak, nonatomic) IBOutlet UILabel *ExploreText;
@property (weak, nonatomic) IBOutlet UILabel *ProfileText;
@property (weak, nonatomic) IBOutlet UILabel *MoreText;

@property (weak, nonatomic) IBOutlet UIView *whiteCoverView;
@property (weak, nonatomic) IBOutlet UIView *onlineOrLocalView;


- (IBAction)localButtonClicked:(id)sender;
- (IBAction)onlineButtonClicked:(id)sender;
- (IBAction)denyClickingOnCellsButtonClicked:(id)sender;
- (IBAction)addDealButtonClicked:(id)sender;
- (IBAction)morebutton:(id)sender;
- (IBAction)profilebutton:(id)sender;
- (IBAction)explorebutton:(id)sender;

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
@property (nonatomic, strong) NSMutableArray *USERSIDSARRAY;


@property (strong, nonatomic) NSString *dealsUserLikes;

@end
