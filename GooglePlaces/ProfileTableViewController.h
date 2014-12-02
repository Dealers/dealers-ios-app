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

@interface ProfileTableViewController : UITableViewController {
    
    UIView *loadingView;
}

@property AppDelegate *appDelegate;

@property Dealer *dealer;

@property NSMutableArray *uploadedDeals;
@property NSMutableArray *likedDeals;

@property NSString *categoryFromExplore;


@end
