//
//  PasswordTableViewController.m
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/20/14.
//
//

#import "PasswordTableViewController.h"

@interface PasswordTableViewController ()

@end

@implementation PasswordTableViewController

@synthesize appDelegate;

- (void)done
{
    if ([self.passwordCurrent.text length] == 0) {
        UIAlertView *blank = [[UIAlertView alloc]
                              initWithTitle:@"Current password is blank!"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [blank show];
    
    } else if ([self.passwordNew.text length] == 0) {
        UIAlertView *blank = [[UIAlertView alloc]
                              initWithTitle:@"New password is blank!"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [blank show];
    } else if ([self.passwordNewAgain.text length] == 0) {
        UIAlertView *blank = [[UIAlertView alloc]
                              initWithTitle:@"New password repeat is blank!"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [blank show];
    } else if (self.passwordCurrent.text != appDelegate.dealer.userPassword) {
        UIAlertView *blank = [[UIAlertView alloc]
                              initWithTitle:@"Wrong Password"
                              message:@"Your current password was entered incorrectly"
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [blank show];
    } else if (![self.passwordNew.text isEqualToString:self.passwordNewAgain.text]) {
        UIAlertView *blank = [[UIAlertView alloc]
                              initWithTitle:@"New Passwords Doesn't Match"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [blank show];
    
    } else {
        appDelegate.dealer.userPassword = self.passwordNewAgain.text;
        // Send to the database the new password...
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    self.title = @"Change Password";
    
    UIImage *doneImage = [[UIImage imageNamed:@"Done Button"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithImage:doneImage style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    [done setImageInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
    
    self.navigationItem.rightBarButtonItem = done;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
