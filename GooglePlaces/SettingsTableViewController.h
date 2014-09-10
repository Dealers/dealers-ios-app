//
//  SettingsTableViewController.h
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/18/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "MainViewController.h"
#import "EditProfileTableViewController.h"
#import "PushNotificationsTableViewController.h"
#import "MBProgressHUD.h"

@interface SettingsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate, MBProgressHUDDelegate> {
    
    MBProgressHUD *progressIndicator;
    
}

@end
