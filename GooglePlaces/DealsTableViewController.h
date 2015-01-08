//
//  DealsTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 12/1/14.
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

@interface DealsTableViewController : UITableViewController <UIScrollViewDelegate> {
    
    int firstPhotosCounter;
    NSString *selfViewController;
    UIView *loadingView;
    BOOL needToSetFooter;
}

@property AppDelegate *appDelegate;

@property NSMutableArray *deals;

@property NSString *categoryFromExplore;

@property RKPaginator *paginator;

@property UIView *footerView;
@property UIImageView *footerImageView;

@property BOOL pageIsLoading;

@end