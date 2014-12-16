//
//  SettingsTableViewController.m
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/18/14.
//
//

#import "SettingsTableViewController.h"
#import "KeychainItemWrapper.h"

#define confirmDisconnectTag 12341234
#define confirmConnectTag 43214321

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    [self setProgressIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    if ([self.appDelegate isFacebookConnected]) {
        
        self.facebookConnectionIndicator.text = @"Connected";
        self.facebookConnectionIndicator.textColor = [UIColor blackColor];
        
    } else {
        
        self.facebookConnectionIndicator.text = @"Not Connected";
        self.facebookConnectionIndicator.textColor = [UIColor lightGrayColor];
    }
}

- (void)setProgressIndicator
{
    progressIndicator = [[MBProgressHUD alloc]initWithView:self.tabBarController.view];
    progressIndicator.delegate = self;
    progressIndicator.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Complete"]];
    progressIndicator.mode = MBProgressHUDModeCustomView;
    progressIndicator.labelText = @"Email Sent";
    progressIndicator.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    progressIndicator.animationType = MBProgressHUDAnimationZoomIn;
    
    UIImageView *customView = [self.appDelegate loadingAnimationWhite];
    [customView startAnimating];
    
    loggingInFacebook = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    loggingInFacebook.delegate = self;
    loggingInFacebook.customView = customView;
    loggingInFacebook.mode = MBProgressHUDModeCustomView;
    loggingInFacebook.labelText = @"Logging In";
    loggingInFacebook.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    loggingInFacebook.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.tabBarController.view addSubview:progressIndicator];
    [self.tabBarController.view addSubview:loggingInFacebook];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            // Edit Profile:
            [self pushEditProfileView];
            break;
        case 1:
            // Facebook Connection:
            if (indexPath.row == 0) {
                
                if (![self.appDelegate isFacebookConnected]) {
                    
                    // Connect Facebook
                    UIActionSheet *confirmConnection = [[UIActionSheet alloc]initWithTitle:@"Do you want to connect Facebook?"
                                                                                     delegate:self
                                                                            cancelButtonTitle:@"Cancel"
                                                                       destructiveButtonTitle:nil
                                                                            otherButtonTitles:@"Connect Facebook", nil];
                    
                    confirmConnection.tag = confirmConnectTag;
                    [confirmConnection showFromTabBar:self.tabBarController.tabBar];
                    
                } else {
                    
                    // Disconnect Facebook
                    UIActionSheet *confirmDisconnection = [[UIActionSheet alloc]initWithTitle:@"Do you want to disconnect Facebook?"
                                                                                     delegate:self
                                                                            cancelButtonTitle:@"Cancel"
                                                                       destructiveButtonTitle:@"Disconnect"
                                                                            otherButtonTitles:nil];
                    
                    confirmDisconnection.tag = confirmDisconnectTag;
                    [confirmDisconnection showFromTabBar:self.tabBarController.tabBar];
                }
                
                [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
                
            } else if (indexPath.row == 1) {
                // Push Notifications:
                [self pushPushNotificationsView];
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    // Tutorial...
                    break;
                case 1:
                    // Report a Problem:
                    [self sendReportProblem];
                case 2:
                    // Send Feedback:
                    [self sendFeedback];
            }
            break;
        case 3:
            // Log Out:
            [self logOut];
            
        default:
            break;
    }
}


#pragma mark - Facebook

- (void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification
{
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    
    if (!error) {
        
        // In case that there's not any error, then check if the session opened or closed.
        
        if (sessionState == FBSessionStateOpen) {
            
            // Check if the user already exists
            [self signInWithToken];
            
            // If exists, get him in and add all the new information received by Facebook
            [self updateInfoReceivedByFacebook];
            
            // If doesn't exists, add him as a new dealer
            [self addAsNewDealer];
            
        } else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            
            // A session was closed or the login was failed or canceled. Update the UI accordingly.
        }
        
    } else {
        
        // In case an error has occured, then just log the error and update the UI accordingly.
        NSLog(@"Error: %@", [error localizedDescription]);
        [loggingInFacebook hide:YES];
    }
}

- (void)signInWithToken
{
    

}

- (void)updateInfoReceivedByFacebook
{
    
}

- (void)addAsNewDealer
{
    
}

#pragma mark - Navigation methods

- (void)pushEditProfileView
{
    EditProfileTableViewController *edtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"editProfileID"];
    [self.navigationController pushViewController:edtvc animated:YES];
}

- (void)pushPushNotificationsView
{
    ComingSoonViewController *csvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ComingSoonID"];
    csvc.title = @"Push Notifications";
    csvc.messageContent = @"Here you will be able to determine in which cases you will be notified regarding your activity at Dealers.";
    [self.navigationController pushViewController:csvc animated:YES];
}

- (void)logOut
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"openingScreenID"];
    
    CGRect screenShotRect = self.view.bounds;
    screenShotRect.origin.y = self.view.bounds.origin.y - 15;
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, YES, 0.0);
    [self.tabBarController.view drawViewHierarchyInRect:screenShotRect afterScreenUpdates:NO];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    appDelegate.dealer = nil;
    [appDelegate removeUserDetailsFromDevice];
    
    if ([self.appDelegate isFacebookConnected]) {
        
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    
    appDelegate.Animate_first = @"notfirst";
    appDelegate.screenShot = screenShot;
    appDelegate.window.rootViewController = nc;
}

#pragma mark - Email methods

- (void)sendReportProblem
{
    NSString *emailTitle = @"Support";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@dealers-app.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        case MFMailComposeResultSent:   {
            [progressIndicator show:YES];
            [progressIndicator hide:YES afterDelay:2.5];
            
            break;
        }
        case MFMailComposeResultFailed: {
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email Error" message:@"Unable to send email. please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)sendFeedback
{
    NSString *emailTitle = @"Feedback";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"ideas@dealers-app.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == confirmDisconnectTag) {
        
        if (buttonIndex == 0) {
            [[FBSession activeSession] closeAndClearTokenInformation];
            self.facebookConnectionIndicator.text = @"Not Connected";
            self.facebookConnectionIndicator.textColor = [UIColor lightGrayColor];
        }
    
    } else if (actionSheet.tag == confirmConnectTag) {
        
        if (buttonIndex == 0) {
            
            [self.appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"user_friends", @"email"] allowLoginUI:YES];
        }
    }
}

@end
