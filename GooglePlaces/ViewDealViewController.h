//
//  ViewDealViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 3/12/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AWSiOSSDKv2/S3.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "DealTableViewCell.h"
#import "CommentTableViewCell.h"
#import "EditDealTableViewController.h"
#import "CommentsTableViewController.h"
#import "DealersTableViewController.h"
#import "ActivityTypeWhatsApp.h"
#import "Report.h"
#import "MBProgressHUD.h"
#import "GAITrackedViewController.h"

@interface ViewDealViewController : GAITrackedViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, MBProgressHUDDelegate> {
    
    BOOL shouldAddID, shouldRemoveID;
    NSInteger commentsPreviewCount;
    CGFloat headerHeight, footerHeight;
    CLLocationCoordinate2D lastCoords;
    UIColor *textGray;
    MBProgressHUD *reportSent;
}

@property AppDelegate *appDelegate;

@property id delegate;
@property NSIndexPath *dealIndexPath;

@property (strong,nonatomic) Deal *deal;
@property NSNumber *dealID;

@property UIView *whiteLoadingBackground;
@property UIImageView *loadingAnimation;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesScrollViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *imagesContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesContentViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImage1;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImage2;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImage3;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImage4;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator1;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator3;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator4;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property NSMutableArray *photosURLArray;

@property (weak, nonatomic) IBOutlet UIView *expiredTag;
@property (weak, nonatomic) IBOutlet UIView *expirationDateBackgroundWhenExpired;

@property (weak, nonatomic) IBOutlet ElasticLabel *dealTitle;
@property (weak, nonatomic) IBOutlet ElasticLabel *store;
@property (weak, nonatomic) IBOutlet UIImageView *priceIcon;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *expirationDate;
@property (weak, nonatomic) IBOutlet ElasticLabel *dealDescription;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;

@property (weak, nonatomic) IBOutlet UIImageView *dealerProfilePlaceholder;
@property (weak, nonatomic) IBOutlet UIImageView *dealerProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *dealerName;
@property (weak, nonatomic) IBOutlet UILabel *uploadDate;

@property (weak, nonatomic) IBOutlet UITableView *commentsPreviewTableView;
@property NSMutableArray *commentsForPreview;
@property UIView *tableViewHeader;
@property UIView *tableViewFooter;
@property NSMutableArray *cellsHeights;

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property UIView *locationCircle;
@property (weak, nonatomic) IBOutlet ElasticLabel *storeTitle;
@property (weak, nonatomic) IBOutlet ElasticLabel *storeAddress;
@property (weak, nonatomic) IBOutlet UITextView *storeWebsite;
@property (weak, nonatomic) IBOutlet UITextView *storePhone;
@property (weak, nonatomic) IBOutlet UIButton *wazeButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesScrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceImagesTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpacePriceDiscountConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacePriceIconCategoryIconConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceCategoryIconExpirationDateIconConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expirationDateIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceExpirationDateIconDescriptionIconConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceBasicDetailsLikesConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceDescriptionLabelLikeIconConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likesIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceLikesIconDealerProfilePicConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsPreviewTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceStoreAddressStoreWebsiteIconConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeWebsiteIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceStoreWebsiteIconStorePhoneIconConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storePhoneIconHeightConstraint;

@property NSDateFormatter *dateFormatter;
@property UIImage *sharedImage;

@property UIButton *likeBarButton;
@property UIButton *likeBarButtonSelected;
@property UIButton *commentBarButton;
@property UIButton *shareBarButton;
@property NSNumber *likeCounter;
@property NSNumber *shareCounter;

@property (retain) UIDocumentInteractionController * documentInteractionController;

@property BOOL isDealLikedByUser;
@property BOOL afterEditing;
@property BOOL didChangesInComments;

@end
