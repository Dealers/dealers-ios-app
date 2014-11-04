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

@interface ActivityTableViewController : UITableViewController

@property AppDelegate *appDelegate;

@property NSMutableArray *notifications;

@property UIImage *notificationPhoto;

@end
