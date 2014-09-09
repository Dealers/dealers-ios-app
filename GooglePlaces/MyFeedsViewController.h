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
    int numberOfDealsLoadingAtATime;
    int cellNumberInScrollView;
    int cellsNumbersInFillWithImages;
    BOOL isShortCell;
    BOOL isUpdatingNow;
    BOOL myFeedsFirstTime;
    BOOL refreshing;
    
    NSString *selfViewController;
}

@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)  UIImage *image;

@property (weak, nonatomic) IBOutlet UIImageView *DealersTitle;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingImage;
@property (weak, nonatomic) UIImageView *loadingIconLoadNewDeals;

@property (nonatomic, strong) NSMutableArray *dealsArray;
@property (nonatomic, strong) NSMutableArray *dealPhotosArray;

@property (strong, nonatomic) NSString *dealsUserLikes;

@property (nonatomic) NSString *categoryFromExplore;

@property NSDateFormatter *dateFormatter;

@end
