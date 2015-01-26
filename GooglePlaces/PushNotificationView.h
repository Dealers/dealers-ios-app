//
//  PushNotification.h
//  Dealers
//
//  Created by Gilad Lumbroso on 1/25/15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ViewonedealViewController.h"
#import "DealersTabBarController.h"

@interface PushNotificationView : UINavigationBar

@property AppDelegate *appDelegate;
@property UIWindow *containerWindow;
@property UIImageView *notificationPhoto;
@property UILabel *message;
@property UIButton *hideNotificationButton;
@property NSNumber *objectID; // What is the id of the object that is the issue of the notification.
@property NSString *action; // What should be done? (options: deal, dealer, or else...)
@property Deal *deal;

- (PushNotificationView *)initWithDelegate:(UIWindow *)delegate;
- (PushNotificationView *)initWithFrame:(CGRect)frame;
- (void)presentNotification;

@end
