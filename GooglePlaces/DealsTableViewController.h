//
//  DealsTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 12/1/14.
//
//

#import <UIKit/UIKit.h>
#import <AWSiOSSDKv2/S3.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "ViewDealViewController.h"
#import "Deal.h"
#import "Dealer.h"
#import "DealAttrib.h"
#import "Store.h"
#import "DealsTableCell.h"
#import "DealTableViewCell.h"
#import "DealsNoPhotoTableCell.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface DealsTableViewController : UITableViewController <UIScrollViewDelegate, CLLocationManagerDelegate> {
    
    int firstPhotosCounter;
    NSString *selfViewController;
    UIView *loadingView;
    BOOL needToSetFooter;
}

@property AppDelegate *appDelegate;

@property NSMutableArray *deals;

@property CLLocationManager *locationManager;

@property NSString *categoryFromExplore;
@property NSString *searchTermFromExplore;
@property NSNumber *weeklyDealsID;
@property NSString *recommendedDealsTitle;

@property RKPaginator *paginator;

@property UIView *footerView;
@property UIImageView *footerImageView;

@property BOOL pageIsLoading;

@end
