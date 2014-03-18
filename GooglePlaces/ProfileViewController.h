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
    BOOL isShortCell;
    int GAP;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *dealsView;
@property (weak, nonatomic) IBOutlet UIView *likesView;

@property (weak, nonatomic) IBOutlet UIImageView *dealerProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *dealerName;
@property (weak, nonatomic) IBOutlet UIImageView *dealerRankImage;
@property (weak, nonatomic) IBOutlet UILabel *dealsCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UIButton *dealsViewButton;
@property (weak, nonatomic) IBOutlet UIButton *likesViewButton;
- (IBAction)dealsViewButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *likesViewButtonClicked;
- (IBAction)likesViewButtonClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;

- (IBAction)Adddeal:(id)sender;
- (IBAction)myfeedbutton:(id)sender;
- (IBAction)morebutton:(id)sender;
- (IBAction)profilebutton:(id)sender;
- (IBAction)explorebutton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *BlueButtonsView;
@property (weak, nonatomic) IBOutlet UIButton *LocalButton;
@property (weak, nonatomic) IBOutlet UIButton *OnlineButton;
@property (weak, nonatomic) IBOutlet UIButton *LockTableButton;
@property (weak, nonatomic) IBOutlet UILabel *OnlineText;
@property (weak, nonatomic) IBOutlet UILabel *LocalText;
- (IBAction)LocalButtonAction:(id)sender;
- (IBAction)OnlineButtonAction:(id)sender;
- (IBAction)UNLockButtonAction:(id)sender;

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

@property (nonatomic, weak) NSString *deals;
@property (nonatomic, weak) NSString *likes;


@end
