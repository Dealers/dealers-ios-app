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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
