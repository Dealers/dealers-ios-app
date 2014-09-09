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

@interface EditProfileTableViewController : UITableViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    BOOL userHaveProfilePic;
    
}

@property AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UIButton *profilePicButton;

@property (weak, nonatomic) IBOutlet UITextField *name;
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
@property BOOL didChangeProfile;



- (IBAction)changeProfilePic:(id)sender;
- (IBAction)noDate:(id)sender;

@end
