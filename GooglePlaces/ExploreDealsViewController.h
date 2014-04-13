//
//  ExploreDealsViewController.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 4/12/14.
//
//

#import <UIKit/UIKit.h>

@interface ExploreDealsViewController : UIViewController

{
    int GAP;
    int gap2;
    BOOL isShortCell;
    BOOL isUpdatingNow;
    int cellNumberInScrollView;
    int cellsNumbersInFillWithImages;
    BOOL myFeedsFirstTime;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)  UIImage *image2;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;

- (IBAction)Adddeal:(id)sender;
- (IBAction)myfeedbutton:(id)sender;
- (IBAction)morebutton:(id)sender;
- (IBAction)profilebutton:(id)sender;
- (IBAction)explorebutton:(id)sender;
- (IBAction)returnButtonClicked:(id)sender;

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
@property (nonatomic, strong) NSMutableArray *uploadDateArray;
@property (nonatomic, strong) NSMutableArray *onlineOrLocalArray;

@property (nonatomic, strong) NSString *dealerId;
@property (nonatomic, strong) NSString *categoryFromExplore;
@property (strong, nonatomic) NSString *dealsUserLikes;


@end
