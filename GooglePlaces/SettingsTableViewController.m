//
//  SettingsTableViewController.m
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/18/14.
//
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self setProgressIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProgressIndicator
{
    progressIndicator = [[MBProgressHUD alloc]initWithView:self.tabBarController.view];
    progressIndicator.delegate = self;
    progressIndicator.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Complete"]];
    progressIndicator.mode = MBProgressHUDModeCustomView;
    progressIndicator.labelText = @"Email Sent";
    progressIndicator.labelFont = [UIFont fontWithName:@"Avenir-Light" size:19.0];
    progressIndicator.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.tabBarController.view addSubview:progressIndicator];
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
            if (indexPath.row == 1) {
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


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

#pragma mark - Navigation methods

- (void)pushEditProfileView
{
    EditProfileTableViewController *edtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"editProfileID"];
    [self.navigationController pushViewController:edtvc animated:YES];
}

- (void)pushPushNotificationsView
{
    PushNotificationsTableViewController *pntvc = [self.storyboard instantiateViewControllerWithIdentifier:@"pushNotificationsID"];
    [self.navigationController pushViewController:pntvc animated:YES];
}

- (void)logOut
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"openingScreenID"];
    
    CGRect screenShotRect = self.view.bounds;
    screenShotRect.origin.y = self.view.bounds.origin.y - 13;
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, YES, 0.0);
    [self.tabBarController.view drawViewHierarchyInRect:screenShotRect afterScreenUpdates:NO];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    appDelegate.Animate_first = @"notfirst";
    appDelegate.DealerClass = nil;
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

@end
