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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    self.title = NSLocalizedString(@"Change Password", nil);
    
    [self setNavigationBar];
}

- (void)setNavigationBar
{
    UIView *doneButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 30)];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setFrame:CGRectMake(8, 0, 58, 30)];
    [doneButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0]];
    [doneButton setBackgroundColor:[appDelegate ourPurple]];
    [doneButton.layer setCornerRadius:5.0];
    [doneButton.layer setMasksToBounds:YES];
    
    [doneButtonView addSubview:doneButton];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:doneButtonView];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)done
{
    if ([self.passwordCurrent.text length] == 0) {
        UIAlertView *blank = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Current password is blank!", nil)
                              message:nil
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
        [blank show];
        
    } else if ([self.passwordNew.text length] == 0) {
        UIAlertView *blank = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"New password is blank!", nil)
                              message:nil
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
        [blank show];
    } else if ([self.passwordNewAgain.text length] == 0) {
        UIAlertView *blank = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"OK", nil)
                              message:nil
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
        [blank show];
    } else if (self.passwordCurrent.text != appDelegate.dealer.userPassword) {
        UIAlertView *blank = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Wrong Password", nil)
                              message:NSLocalizedString(@"Your current password was entered incorrectly", nil)
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
        [blank show];
    } else if (![self.passwordNew.text isEqualToString:self.passwordNewAgain.text]) {
        UIAlertView *blank = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"New Passwords Doesn't Match", nil)
                              message:nil
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
        [blank show];
        
    } else {
        appDelegate.dealer.userPassword = self.passwordNewAgain.text;
        // Send to the database the new password...
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
