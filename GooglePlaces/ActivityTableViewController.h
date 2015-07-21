//
//  ActivityTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 10/11/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NotificationTableViewCell.h"
#import "Notification.h"
#import "DealsTableViewController.h"
#import "ViewDealViewController.h"
#import "ProfileTableViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface ActivityTableViewController : UITableViewController {
    
    UIView *loadingView;
    NSInteger timesTriedUpdateDevice;
}

@property AppDelegate *appDelegate;

@property NSMutableArray *notifications;
@property NSMutableArray *groupedNotifications;

@property UIImage *notificationPhoto;

@property NSDateFormatter *dateFormatter;

- (void)refresh;


@end
