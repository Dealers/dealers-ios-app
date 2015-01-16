//
//  ProfileTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 12/2/14.
//
//

#import <UIKit/UIKit.h>
#import <AWSiOSSDKv2/S3.h>
#import "AppDelegate.h"
#import "ViewonedealViewController.h"
#import "Deal.h"
#import "Dealer.h"
#import "DealAttrib.h"
#import "Store.h"
#import "DealsTableCell.h"
#import "DealsNoPhotoTableCell.h"
#import "SettingsTableViewController.h"
#import "InviteViewController.h"

@interface ProfileTableViewController : UITableViewController <UIScrollViewDelegate> {
    
    UIView *loadingView;
    int lowestYPoint;
    int firstPhotosCounter;
    CGFloat topViewHeight;
    BOOL isLoading;
    BOOL isRefreshing;
    BOOL didDownloadUploadedDeals;
    BOOL didDownloadLikedDeals;
    NSString *whatIsLoading;
}

@property AppDelegate *appDelegate;

@property Dealer *dealer;

@property NSNumber *dealerID;

@property NSString *profileMode;

@property NSString *path;

@property NSMutableArray *uploadedDeals;
@property NSMutableArray *likedDeals;
@property NSMutableArray *currentDeals;

@property NSString *typeOfDeals;

@property UIView *topView;
@property UIView *profilePicPlaceholder;
@property UIImageView *profilePic;
@property UILabel *fullName;
@property UILabel *location;
@property UIImageView *locationIcon;
@property UITextView *about;
@property UIButton *settings;
@property UIView *separatorHorizontal;
@property UIView *separatorVertical;
@property UIButton *follow;
@property UIButton *uploadedButton;
@property UIButton *likedButton;
@property UIView *uploadedButtonSelectionIndicator;
@property UIView *likedButtonSelectionIndicator;
@property UIImageView *loadingDealsAnimation;

@property BOOL afterEditing;


@end
