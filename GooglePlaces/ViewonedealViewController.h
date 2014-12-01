//
//  ViewonedealViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import <AWSiOSSDKv2/S3.h>
#import "Deal.h"
#import "Dealer.h"
#import "Store.h"
#import "Comment.h"
#import "CommentsTableCell.h"
#import "EditDealTableViewController.h"
#import "Notification.h"

@interface ViewonedealViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIDocumentInteractionControllerDelegate, UIActionSheetDelegate>

{
    int currentpage;
    int lowestYPoint;
    int maxXPoint;
    CLLocationCoordinate2D lastCoords;
    UIColor *textGray;
    
    BOOL shouldAddID;
    BOOL shouldRemoveID;
}

@property AppDelegate *appDelegate;

@property (nonatomic, strong) MKMapView *mapView;

@property (strong,nonatomic) Deal *deal;

@property (strong,nonatomic) NSString *isShortCell;
@property (strong,nonatomic) NSString *isDealLikedByUser;

@property (strong,nonatomic) NSString *urlImage;
@property (strong,nonatomic) NSString *urlImage2;
@property (strong,nonatomic) NSString *urlImage3;
@property (strong,nonatomic) NSString *urlImage4;

@property (nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIImageView *dealerImage;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *storelabel;
@property (weak, nonatomic) IBOutlet UILabel *categorylabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;
@property (weak, nonatomic) IBOutlet UILabel *discountlabel;
@property (weak, nonatomic) IBOutlet UILabel *expirelabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionlabel;
@property (weak, nonatomic)  NSString *likelabel;
@property (weak, nonatomic)  NSString *commentlabel;
@property (weak, nonatomic) IBOutlet UILabel *dealersNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *StoreIcon;
@property (weak, nonatomic) IBOutlet UIImageView *CategoryIcon;
@property (weak, nonatomic) IBOutlet UIImageView *PriceIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ExpireIcon;
@property (weak, nonatomic) IBOutlet UIImageView *DescriptionIcon;

@property (weak, nonatomic) IBOutlet UIView *dealerSection;

@property NSDateFormatter *dateFormatter;

@property UIView *mapAndStoreSection;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButtonSelected;
@property (weak, nonatomic) IBOutlet UIButton *CommentButton;
@property (weak, nonatomic) IBOutlet UIButton *ShareButton;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;
@property (weak, nonatomic) IBOutlet UIButton *optionsButtonSelected;

@property NSNumber *likeCounter;
@property NSNumber *shareCounter;

- (IBAction)LikeButtonAction:(id)sender;
- (IBAction)CommentButtonAction:(id)sender;
- (IBAction)ShareButtonAction:(id)sender;
- (IBAction)optionsAction:(id)sender;

@property NSMutableArray *commentsForPreview;
@property NSNumber *commentsCount;
@property UITableView *commentsTableView;
@property (nonatomic) CommentsTableCell *cellPrototype;
@property CGFloat tableViewHeight;
@property NSInteger commentsPreviewCount;

@property (weak, nonatomic) IBOutlet UIImageView *captureImage;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoading2;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage3;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoading3;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage4;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoading4;
@property (weak, nonatomic) IBOutlet UIView *likesAndButtonsSection;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *cameraScrollView;

@property (nonatomic) UIView *commentsSection;

- (IBAction)dealerProfileButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *likesCountImage;
@property (weak, nonatomic) IBOutlet UIImageView *shareCountImage;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *shreCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *urlSiteButton;

- (IBAction)urlSiteButtonClicked:(id)sender;

@property UIImage *sharedImage;

@property (retain) UIDocumentInteractionController * documentInteractionController;

@property BOOL whatsappShouldAppear;
@property BOOL afterEditing;

- (void)whatsAppShare;

@property BOOL didChangesInComments;


@end
