//
//  PasswordTableViewController.h
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/20/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PasswordTableViewController : UITableViewController

@property AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *passwordCurrent;
@property (weak, nonatomic) IBOutlet UITextField *passwordNew;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewAgain;


@end
