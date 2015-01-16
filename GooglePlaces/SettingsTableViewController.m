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
#define AWS_S3_BUCKET_NAME @"dealers-app"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

@synthesize appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Settings", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    [self setProgressIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    if ([appDelegate isFacebookConnected]) {
        
        self.facebookConnectionIndicator.text = NSLocalizedString(@"Connected", nil);
        self.facebookConnectionIndicator.textColor = [UIColor blackColor];
        
    } else {
        
        self.facebookConnectionIndicator.text = NSLocalizedString(@"Not Connected", nil);
        self.facebookConnectionIndicator.textColor = [UIColor lightGrayColor];
    }
}

- (void)setProgressIndicator
{
    progressIndicator = [[MBProgressHUD alloc]initWithView:self.tabBarController.view];
    progressIndicator.delegate = self;
    progressIndicator.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Complete"]];
    progressIndicator.mode = MBProgressHUDModeCustomView;
    progressIndicator.labelText = NSLocalizedString(@"Email Sent", nil);
    progressIndicator.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    progressIndicator.animationType = MBProgressHUDAnimationZoomIn;
    
    UIImageView *customView = [appDelegate loadingAnimationWhite];
    [customView startAnimating];
    
    loggingInFacebook = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    loggingInFacebook.delegate = self;
    loggingInFacebook.customView = customView;
    loggingInFacebook.mode = MBProgressHUDModeCustomView;
    loggingInFacebook.labelText = NSLocalizedString(@"Connecting", nil);
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
                
                if (![appDelegate isFacebookConnected]) {
                    
                    // Connect Facebook
                    UIActionSheet *confirmConnection = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Do you want to connect Facebook?", nil)
                                                                                   delegate:self
                                                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                                     destructiveButtonTitle:nil
                                                                          otherButtonTitles:NSLocalizedString(@"Connect Facebook", nil), nil];
                    
                    confirmConnection.tag = confirmConnectTag;
                    [confirmConnection showFromTabBar:self.tabBarController.tabBar];
                    
                } else {
                    
                    // Disconnect Facebook
                    UIActionSheet *confirmDisconnection = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Do you want to disconnect Facebook?", nil)
                                                                                     delegate:self
                                                                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                                       destructiveButtonTitle:NSLocalizedString(@"Disconnect", nil)
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
    
    [loggingInFacebook show:YES];
    
    if (!error) {
        
        // In case that there's not any error, then check if the session opened or closed.
        
        if ([appDelegate isFacebookConnected]) {
            
            self.facebookConnectionIndicator.text = NSLocalizedString(@"Connected", nil);
            self.facebookConnectionIndicator.textColor = [UIColor blackColor];
            
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, gender, birthday, picture.type(large), location, email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      
                                      if (!error) {
                                          
                                          [loggingInFacebook hide:YES];
                                          appDelegate.dealer = [appDelegate updateDealer:appDelegate.dealer withFacebookInfo:(FBGraphObject *)result withPhoto:YES];
                                          
                                          if (appDelegate.dealer.photoURL.length > 1 && ![appDelegate.dealer.photoURL isEqualToString:@"None"]) {
                                              // If the dealer already has a photo, don't use Facebook's profile pic and get him in. If else, use it.
                                              [self updateProfileView];
                                          } else {
                                              [self uploadPhoto];
                                          }
                                          
                                      } else {
                                          
                                          NSLog(@"%@", [error localizedDescription]);
                                          [loggingInFacebook hide:YES];
                                      }
                                  }];
            
        } else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            
            // A session was closed or the login was failed or canceled. Update the UI accordingly.
            [loggingInFacebook hide:YES];
        }
        
    } else {
        
        // In case an error has occured, then just log the error and update the UI accordingly.
        NSLog(@"Error: %@", [error localizedDescription]);
        [loggingInFacebook hide:YES];
    }
}

- (void)uploadPhoto
{
    NSString *photoFileName = [NSString stringWithFormat:@"%@_%@.jpg", appDelegate.dealer.email, [NSDate date]];
    NSString *filePathAtS3 = [NSString stringWithFormat:@"media/Profile_Photos/%@", photoFileName];
    appDelegate.dealer.photoURL = filePathAtS3;
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    NSString *key = appDelegate.dealer.photoURL;
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:photoFileName];
    [appDelegate.dealer.photo writeToFile:filePath atomically:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.bucket = AWS_S3_BUCKET_NAME;
    uploadRequest.key = key;
    uploadRequest.body = fileURL;
    
    [[transferManager upload:uploadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor]
                                                       withBlock:^id(BFTask *task) {
                                                           if (task.error) {
                                                               if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                                   switch (task.error.code) {
                                                                           
                                                                       case AWSS3TransferManagerErrorCancelled:
                                                                           NSLog(@"Profile photo upload cancelled");
                                                                           break;
                                                                           
                                                                       case AWSS3TransferManagerErrorPaused:
                                                                           NSLog(@"Profile photo upload paused");
                                                                           break;
                                                                           
                                                                       default:
                                                                           NSLog(@"Error: %@", task.error);
                                                                           break;
                                                                   }
                                                               } else {
                                                                   // Unknown error.
                                                                   NSLog(@"Error: %@", task.error);
                                                               }
                                                           }
                                                           
                                                           if (task.result) {
                                                               
                                                               NSLog(@"Profile photo uploaded successfuly!");
                                                               
                                                               [self updateProfileView];
                                                           }
                                                           return nil;
                                                       }];
}

- (void)updateProfileView
{
    ProfileTableViewController *ptvc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    ptvc.afterEditing = YES;
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
    csvc.title = NSLocalizedString(@"Push Notifications", nil);
    csvc.messageContent = NSLocalizedString(@"Here you will be able to determine in which cases you will be notified regarding your activity at Dealers.", nil);
    [self.navigationController pushViewController:csvc animated:YES];
}

- (void)logOut
{
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"openingScreenID"];
    
    CGRect screenShotRect = self.view.bounds;
    screenShotRect.origin.y = self.view.bounds.origin.y - 15;
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, YES, 0.0);
    [self.tabBarController.view drawViewHierarchyInRect:screenShotRect afterScreenUpdates:NO];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [appDelegate deletePseudoUser];
    appDelegate.dealer = nil;
    [appDelegate removeUserDetailsFromDevice];
    
    if ([appDelegate isFacebookConnected]) {
        
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    
    appDelegate.Animate_first = @"notfirst";
    appDelegate.screenShot = screenShot;
    appDelegate.window.rootViewController = nc;
}


#pragma mark - Email methods

- (void)sendReportProblem
{
    NSString *emailTitle = NSLocalizedString(@"Support", nil);
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@dealers-app.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    mc.view.tintColor = [appDelegate ourPurple];
    
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email Error", nil)
                                                            message:NSLocalizedString(@"Unable to send email. please try again", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
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
    NSString *emailTitle = NSLocalizedString(@"Feedback", nil);
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"ideas@dealers-app.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    mc.view.tintColor = [appDelegate ourPurple];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == confirmDisconnectTag) {
        
        if (buttonIndex == 0) {
            [[FBSession activeSession] closeAndClearTokenInformation];
            self.facebookConnectionIndicator.text = NSLocalizedString(@"Not Connected", nil);
            self.facebookConnectionIndicator.textColor = [UIColor lightGrayColor];
        }
        
    } else if (actionSheet.tag == confirmConnectTag) {
        
        if (buttonIndex == 0) {
            
            [appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"user_friends", @"email", @"user_birthday", @"user_location"] allowLoginUI:YES];
        }
    }
}

@end
