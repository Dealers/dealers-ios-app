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
#import "OpeningScreenViewController.h"
#import "EditProfileTableViewController.h"
#import "PushNotificationsTableViewController.h"
#import "TutorialViewController.h"
#import "ComingSoonViewController.h"
#import "PersonalizeTableViewController.h"
#import "MBProgressHUD.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface SettingsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate> {
    
    MBProgressHUD *progressIndicator, *loggingInFacebook;
}

@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UILabel *facebookConnectionIndicator;
@property (weak, nonatomic) IBOutlet UILabel *personalizeLabel;

@end
