//
//  ActivityTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 10/11/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NotificationTableCell.h"
#import "Notification.h"
#import "ViewonedealViewController.h"
#import "ProfileTableViewController.h"


@interface ActivityTableViewController : UITableViewController {
    
    UIView *loadingView;
}

@property AppDelegate *appDelegate;

@property NSMutableArray *notifications;
@property NSMutableArray *groupedNotifications;

@property UIImage *notificationPhoto;

@end
