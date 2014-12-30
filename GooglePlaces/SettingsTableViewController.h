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
#import "ComingSoonViewController.h"
#import "MBProgressHUD.h"

@interface SettingsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate> {
    
    MBProgressHUD *progressIndicator, *loggingInFacebook;
}

@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UILabel *facebookConnectionIndicator;

@property RKObjectManager *updateFromFacebookManager;

@end
