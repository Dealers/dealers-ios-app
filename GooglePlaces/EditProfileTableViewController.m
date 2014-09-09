//
//  EditProfileTableViewController.m
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/18/14.
//
//

#import "EditProfileTableViewController.h"

@interface EditProfileTableViewController ()

@end

@implementation EditProfileTableViewController

@synthesize appDelegate;

- (void)dismiss:(id)sender
{
    
}

- (void)saveChanges
{
    
}

- (void)initialize
{
    self.appDelegate = [[UIApplication sharedApplication]delegate];
    self.didChangeProfile = NO;
    self.datePickerIsShowing = NO;
    
    if (appDelegate.dealerClass.photo) {
        userHaveProfilePic = YES;
    } else {
        userHaveProfilePic = NO;
    }
    
    [self signUpForKeyboardNotifications];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Edit Profile";
    
    [self initialize];
    
    [self setSaveButton];
    [self setProfilePicSection];
    [self setKnownValues];
}


#pragma mark - Setting the view and sections

- (void)setSaveButton
{
    UIImage *saveImage = [[UIImage imageNamed:@"Save Button"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithImage:saveImage style:UIBarButtonItemStyleBordered target:self action:@selector(saveChanges)];
    [save setImageInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
    
    self.navigationItem.rightBarButtonItem = save;
}

- (void)setProfilePicSection
{
    if (userHaveProfilePic) {
        [self.profilePicButton setImage:[appDelegate.dealerClass.photo copy] forState:UIControlStateNormal];
    } else {
        [self.profilePicButton setImage:[UIImage imageNamed:@"Profile Pic Placeholder"] forState:UIControlStateNormal];
    }
    self.profilePicButton.layer.cornerRadius = self.profilePicButton.frame.size.width / 2;
    self.profilePicButton.layer.masksToBounds = YES;
}

- (void)setKnownValues
{
    self.name.text = [appDelegate.dealerClass.fullName mutableCopy];
    self.about.text = [appDelegate.dealerClass.about mutableCopy];
    self.location.text = [appDelegate.dealerClass.location mutableCopy];
    self.email.text = [appDelegate.dealerClass.email mutableCopy];
    
    [self setDateOfBirthLabel];
    
    if (appDelegate.dealerClass.gender) {
        self.gender.text = appDelegate.dealerClass.gender;
        self.gender.textColor = [UIColor blackColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view

#define dateOfBirthSection 1
#define dateOfBirthRow 1
#define dateOfBirthCellHeight 162
#define genderActionSheetTag 2


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.section == dateOfBirthSection && indexPath.row == dateOfBirthRow) {
        
        height = self.datePickerIsShowing ? dateOfBirthCellHeight : 0.0;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == dateOfBirthSection && indexPath.row == 0) {
        if (self.datePickerIsShowing) {
            [self hideDatePickerCell];
        } else {
            [self showDatePickerCell];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self performSelector:@selector(dateChanged:) withObject:self.datePicker];
            [self.view endEditing:YES];
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        UIActionSheet *genderOptions = [[UIActionSheet alloc]
                                        initWithTitle:@"What is your gender?"
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles:@"Unspecified", @"Female", @"Male", nil];
        genderOptions.tag = genderActionSheetTag;
        [genderOptions showFromTabBar:self.tabBarController.tabBar];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (self.datePickerIsShowing) {
            [self hideDatePickerCell];
        }
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        PasswordTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"passwordID"];
        [self.navigationController pushViewController:ptvc animated:YES];
    }
}

#pragma mark - Profile Picture

#define profilePicActionSheetTag 333

- (IBAction)changeProfilePic:(id)sender {
    
    UIActionSheet *actionSheet;
    
    if (userHaveProfilePic) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"Change Profile Picture"
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:@"Remove Photo"
                       otherButtonTitles:@"Take a Picture", @"From Library", nil];
    } else {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"Add Profile Picture"
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Take a Picture", @"From Library", nil];
    }
    actionSheet.tag = profilePicActionSheetTag;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    if (self.datePickerIsShowing) {
        [self hideDatePickerCell];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        
        case profilePicActionSheetTag:
            [self setProfilePicActionSheet:buttonIndex];
            break;
        
        case genderActionSheetTag:
            
            if (buttonIndex == 0) {
                self.gender.text = @"Gender";
                self.gender.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
            } else if (buttonIndex == 1) {
                self.gender.text = @"Female";
                self.gender.textColor = [UIColor blackColor];
            } else if (buttonIndex == 2) {
                self.gender.text = @"Male";
                self.gender.textColor = [UIColor blackColor];
            }
             break;
            
        default:
            break;
    }
    
}

- (void)setProfilePicActionSheet:(NSInteger)buttonIndex
{
    if (userHaveProfilePic) {
        
        if (buttonIndex == 0) { // Remove Photo:
            
            [self.profilePicButton setImage:[UIImage imageNamed:@"Profile Pic Placeholder"] forState:UIControlStateNormal];
            userHaveProfilePic = NO;
            self.didChangeProfile = YES;
        }
        if (buttonIndex == 1) { // Take a Picture:
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
            } else {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:@"Device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                [myAlertView show];
            }
        }
        if (buttonIndex == 2) { // From Library:
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
        }
        
    } else {
        
        if (buttonIndex == 0) { // Take a Picture:
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
            } else {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:@"Device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                [myAlertView show];
            }
        }
        if (buttonIndex == 1) { // From Library:
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing=YES;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.profilePicButton setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
    userHaveProfilePic = YES;
    self.didChangeProfile = YES;
}


#pragma mark - Basic Info

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow {
    
    if (self.datePickerIsShowing)
        [self hideDatePickerCell];
}

/*
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}
*/

#pragma mark - Private Info

- (void)setDateOfBirthLabel {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *today = [NSDate date];
    [self.datePicker setMaximumDate:today];
    
    if (appDelegate.dealerClass.dateOfBirth) {
        
        NSDate *defaultDate = [appDelegate.dealerClass.dateOfBirth copy];
        [self.datePicker setDate:defaultDate];
        self.dateOfBirth.text = [self.dateFormatter stringFromDate:defaultDate];
    }
    
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    self.datePickerIsShowing = NO;
    self.datePicker.hidden = YES;
    self.noDateButton.hidden = YES;
}

- (void)showDatePickerCell
{
    self.datePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.datePicker.hidden = NO;
    self.noDateButton.hidden = NO;
    
    if (self.didCancelDate) self.datePicker.date = [NSDate date];
    
    self.didCancelDate = NO;
    self.datePicker.alpha = 0.0f;
    self.noDateButton.alpha = 0.0f;
    self.didChangeProfile = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 1.0f;
        self.noDateButton.alpha = 1.0f;
        self.dateOfBirth.textColor = [UIColor colorWithRed:150.0/250.0 green:0/250.0 blue:180.0/250.0 alpha:1.0];
    }];
}

- (void)hideDatePickerCell
{
    self.datePickerIsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 0.0f;
        self.noDateButton.alpha = 0.0f;
        self.dateOfBirth.textColor = self.didCancelDate ? [UIColor colorWithWhite:0.8 alpha:1.0] : [UIColor blackColor];
    } completion:^(BOOL finished) {
        self.datePicker.hidden = YES;
        self.noDateButton.hidden = YES;
    }];
}

- (IBAction)dateChanged:(UIDatePicker *)sender {
    
    if (!self.didCancelDate) {
        self.dateOfBirth.text = [self.dateFormatter stringFromDate:sender.date];
    }
}

- (IBAction)noDate:(id)sender {

    self.dateOfBirth.text = @"Date Of Birth";
    self.dateOfBirth.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.didCancelDate = YES;
    [self hideDatePickerCell];
}

@end
