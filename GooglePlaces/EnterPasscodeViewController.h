//
//  EnterPasscodeViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 1/12/15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "OpeningScreen.h"
#import "SignUpTableViewController.h"
#import "Invitation.h"

@interface EnterPasscodeViewController : UIViewController <UITextFieldDelegate> {
    
    NSInteger deleteAttempt;
}

@property AppDelegate *appDelegate;

@property UINavigationController *navigationControllerDelegate;
@property BOOL signUp;
@property BOOL facebook;

@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *incorrectPasscode;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property UIImageView *checkmark;

@property UIBarButtonItem *barDone;
@property UIButton *done;

@property (weak, nonatomic) IBOutlet UIButton *whatIsThis;
@property UIView *whatIsThisView;
@property UIButton *blackBackground;


- (IBAction)whatIsThis:(id)sender;


@end
