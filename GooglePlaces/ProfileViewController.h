//
//  ProfileViewController.h
//  Dealers
//
//  Created by itzik berrebi on 11/6/13.
//
//

#import <UIKit/UIKit.h>
#import "Deal.h"
#import "AppDelegate.h"
#import "SettingsTableViewController.h"

@interface ProfileViewController : UIViewController <UINavigationControllerDelegate>
{
    int GAP;
    int gap2;
    int GAPForLikeView;
    int gap2ForLikeView;
    BOOL isShortCell;
    BOOL isUpdatingNow;
    int numberOfDealsLoadingAtATime;
    int cellNumberInScrollView;
    int cellsNumbersInFillWithImages;
    int cellNumberInScrollViewForLikeView;
    int cellsNumbersInFillWithImagesForLikeView;
    bool didLoadView;
    
    CGFloat lowestYPoint;
}

@property AppDelegate *appDelegate;

@property Dealer *dealer;

@property NSString *profileMode;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic) UIView *dealsView;
@property (nonatomic) UIView *likesView;

@property (weak, nonatomic) IBOutlet UIImageView *dealerProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *dealerName;
@property (weak, nonatomic) IBOutlet UIImageView *dealerRankImage;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;

@end
