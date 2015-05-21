//
//  DealersTabBarController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 12/30/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "WhereIsTheDeal.h"
#import "WhereIsTheDealOnline.h"
#import "MBProgressHUD.h"

@interface DealersTabBarController : UITabBarController <MFMailComposeViewControllerDelegate, MBProgressHUDDelegate, UIActionSheetDelegate>

@property AppDelegate *appDelegate;
@property UIButton *addDealButton;

- (void)addDeal:(UIButton *)addDealButton;

@end
