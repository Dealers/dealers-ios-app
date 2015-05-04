//
//  DealersTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 12/16/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DealersTableCell.h"
#import "Dealer.h"
#import "ProfileTableViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface DealersTableViewController : UITableViewController {
    
    UIView *loadingView;
}

@property AppDelegate *appDelegate;

@property NSString *mode;

@property NSNumber *dealID;

@property NSMutableArray *dealers;

@end
