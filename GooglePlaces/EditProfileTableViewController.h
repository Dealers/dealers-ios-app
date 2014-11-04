//
//  EditProfileTableViewController.h
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/18/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PasswordTableViewController.h"
#import "MBProgressHUD.h"

@interface EditProfileTableViewController : UITableViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate>
{
    BOOL userHaveProfilePic;
    MBProgressHUD *blankFullName, *blankEmail, *uploading;
}

@property AppDelegate *appDelegate;

@property Dealer *dealer;

@property (weak, nonatomic) IBOutlet UIButton *profilePicButton;

@property (weak, nonatomic) IBOutlet UITextField *fullName;
@property (weak, nonatomic) IBOutlet UITextField *about;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UILabel *dateOfBirth;
@property (weak, nonatomic) IBOutlet UILabel *gender;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UIButton *noDateButton;

@property BOOL datePickerIsShowing;
@property BOOL didCancelDate;
@property BOOL didChangeProfilePic;



- (IBAction)changeProfilePic:(id)sender;
- (IBAction)noDate:(id)sender;

@end
