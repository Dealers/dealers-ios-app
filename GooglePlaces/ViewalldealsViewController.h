//
//  ViewalldealsViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewalldealsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UINavigationBarDelegate>
{
    IBOutlet UITextField *field;
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,retain) UITextField *field;

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

- (IBAction)Adddeal:(id)sender;
- (IBAction)morebutton:(id)sender;
- (IBAction)profilebutton:(id)sender;
- (IBAction)explorebutton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *TapBar;
@property (weak, nonatomic) IBOutlet UIButton *AddDealButton;
@property (weak, nonatomic) IBOutlet UIButton *MyFeedButton;
@property (weak, nonatomic) IBOutlet UIButton *ExploreButton;
@property (weak, nonatomic) IBOutlet UIButton *ProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *MoreButton;
@property (weak, nonatomic) IBOutlet UILabel *MyFeedText;
@property (weak, nonatomic) IBOutlet UILabel *ExploreText;
@property (weak, nonatomic) IBOutlet UILabel *ProfileText;
@property (weak, nonatomic) IBOutlet UILabel *MoreText;

@property (retain, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIImageView *DealersTitle;
@property (weak, nonatomic) IBOutlet UIView *CoveView;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingImage;

@property (weak, nonatomic) IBOutlet UIImageView *exploreImage;
@property (weak, nonatomic) IBOutlet UIImageView *moreImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *myfeedsImage;

@property (weak, nonatomic) IBOutlet UIView *BlueButtonsView;
@property (weak, nonatomic) IBOutlet UIButton *LocalButton;
@property (weak, nonatomic) IBOutlet UIButton *OnlineButton;
@property (weak, nonatomic) IBOutlet UIButton *LockTableButton;
@property (weak, nonatomic) IBOutlet UILabel *OnlineText;
@property (weak, nonatomic) IBOutlet UILabel *LocalText;
- (IBAction)LocalButtonAction:(id)sender;
- (IBAction)OnlineButtonAction:(id)sender;
- (IBAction)UNLockButtonAction:(id)sender;



@end
