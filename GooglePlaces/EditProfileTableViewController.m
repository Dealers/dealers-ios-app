//
//  EditProfileTableViewController.m
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/18/14.
//
//

#import "EditProfileTableViewController.h"

#define AWS_S3_BUCKET_NAME @"dealers-app"

@interface EditProfileTableViewController ()

@end

@implementation EditProfileTableViewController

@synthesize appDelegate;


- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    self.didChangeProfilePic = NO;
    self.datePickerIsShowing = NO;
    self.didChangeEmail = NO;
    
    self.editedDealer = [[Dealer alloc]init];
    
    didUploadUserData = NO;
    didPhotoFinishedUploading = NO;
    shouldUploadPhoto = NO;
    
    if (appDelegate.dealer.photo) {
        userHaveProfilePic = YES;
    } else {
        userHaveProfilePic = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Edit Profile";
    
    [self initialize];
    
    [self signUpForKeyboardNotifications];
    [self setSaveButton];
    [self setProgressIndicator];
    [self setProfilePicSection];
    [self saveOriginalValues];
    [self setKnownValues];
    [self configureRestKit];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (!didUploadUserData) {
        
        appDelegate.dealer.photoURL = self.originalPhotoURL;
        appDelegate.dealer.photo = self.originalPhotoData;
        appDelegate.dealer.fullName = self.originalFullName;
        appDelegate.dealer.about = self.originalAbout;
        appDelegate.dealer.location = self.originalLocation;
        appDelegate.dealer.dateOfBirth = self.originalDateOfBirth;
        appDelegate.dealer.gender = self.originalGender;
        appDelegate.dealer.email = self.originalEmail;
        appDelegate.dealer.username = self.originalEmail;
    }
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
        [self.profilePicButton setImage:[UIImage imageWithData:appDelegate.dealer.photo] forState:UIControlStateNormal];
    } else {
        [self.profilePicButton setImage:[UIImage imageNamed:@"Profile Pic Placeholder"] forState:UIControlStateNormal];
    }
    self.profilePicButton.layer.cornerRadius = self.profilePicButton.frame.size.width / 2;
    self.profilePicButton.layer.masksToBounds = YES;
}

- (void)saveOriginalValues
{
    self.originalPhotoURL = [appDelegate.dealer.photoURL mutableCopy];
    self.originalPhotoData = [appDelegate.dealer.photo mutableCopy];
    self.originalFullName = [appDelegate.dealer.fullName mutableCopy];
    self.originalAbout = [appDelegate.dealer.about mutableCopy];
    self.originalLocation = [appDelegate.dealer.location mutableCopy];
    self.originalDateOfBirth = appDelegate.dealer.dateOfBirth;
    self.originalGender = [appDelegate.dealer.gender mutableCopy];
    self.originalEmail = [appDelegate.dealer.email mutableCopy];
}

- (void)setKnownValues
{
    self.fullName.text = [appDelegate.dealer.fullName mutableCopy];
    self.email.text = [appDelegate.dealer.email mutableCopy];
    
    if (appDelegate.dealer.location.length > 0 && ![appDelegate.dealer.location isEqualToString:@"None"]) {
        self.location.text = [appDelegate.dealer.location mutableCopy];
    }
    
    if (appDelegate.dealer.about.length > 0 && ![appDelegate.dealer.about isEqualToString:@"None"]) {
        self.about.text = [appDelegate.dealer.about mutableCopy];
    }
    
    [self setDateOfBirthLabel];
    
    if (appDelegate.dealer.gender) {
        
        if (![appDelegate.dealer.gender isEqualToString:@"Unspecified"]) {
            
            self.gender.text = appDelegate.dealer.gender;
            self.gender.textColor = [UIColor blackColor];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProgressIndicator
{
    
    blankFullName = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    blankFullName.delegate = self;
    blankFullName.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    blankFullName.mode = MBProgressHUDModeCustomView;
    blankFullName.labelText = @"Name can't be blank!";
    blankFullName.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    blankFullName.animationType = MBProgressHUDAnimationZoomIn;
    
    blankEmail = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    blankEmail.delegate = self;
    blankEmail.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    blankEmail.mode = MBProgressHUDModeCustomView;
    blankEmail.labelText = @"Email can't be blank!";
    blankEmail.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    blankEmail.animationType = MBProgressHUDAnimationZoomIn;
    
    UIImageView *loadingAnimation = [appDelegate loadingAnimationWhite];
    [loadingAnimation startAnimating];
    
    uploading = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    uploading.delegate = self;
    uploading.customView = loadingAnimation;
    uploading.mode = MBProgressHUDModeCustomView;
    uploading.labelText = @"Uploading";
    uploading.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    uploading.animationType = MBProgressHUDAnimationZoomIn;
    
    saved = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    saved.delegate = self;
    saved.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Complete"]];
    saved.mode = MBProgressHUDModeCustomView;
    saved.labelText = @"  Saved!  ";
    saved.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    saved.animationType = MBProgressHUDAnimationZoomIn;
    
    couldntUpload = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    couldntUpload.delegate = self;
    couldntUpload.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    couldntUpload.mode = MBProgressHUDModeCustomView;
    couldntUpload.labelText = @"Couldn't upload the changes...";
    couldntUpload.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    couldntUpload.detailsLabelText = @"Please try again";
    couldntUpload.detailsLabelFont = [UIFont fontWithName:@"Avenir-Light" size:15.0];
    couldntUpload.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:blankFullName];
    [self.navigationController.view addSubview:blankEmail];
    [self.navigationController.view addSubview:uploading];
    [self.navigationController.view addSubview:saved];
    [self.navigationController.view addSubview:couldntUpload];
}


#pragma mark - Table view

#define dateOfBirthSection 1
#define dateOfBirthRow 1
#define dateOfBirthCellHeight 162
#define genderActionSheetTag 2


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
            self.didChangeProfilePic = YES;
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
    self.didChangeProfilePic = YES;
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


#pragma mark - Private Info

- (void)setDateOfBirthLabel {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *today = [NSDate date];
    [self.datePicker setMaximumDate:today];
    
    if (appDelegate.dealer.dateOfBirth) {
        
        NSDate *defaultDate = [appDelegate.dealer.dateOfBirth copy];
        [self.datePicker setDate:defaultDate];
        self.dateOfBirth.text = [self.dateFormatter stringFromDate:defaultDate];
        self.dateOfBirth.textColor = [UIColor blackColor];
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
    
    self.dateOfBirth.text = @"Date of Birth";
    self.dateOfBirth.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.didCancelDate = YES;
    [self hideDatePickerCell];
}


#pragma mark - Uploading and dismissing

- (RKObjectMapping *)editProfileMapping
{
    RKObjectMapping *editProfileMapping = [RKObjectMapping requestMapping];
    [editProfileMapping addAttributeMappingsFromDictionary: @{
                                                              @"email" : @"email",
                                                              @"fullName" : @"full_name",
                                                              @"dateOfBirth" : @"date_of_birth",
                                                              @"gender" : @"gender",
                                                              @"about" : @"about",
                                                              @"location" : @"location",
                                                              @"username" : @"user.username",
                                                              @"photoURL" : @"photo"
                                                              }];
    return editProfileMapping;
}

- (void)configureRestKit
{
    NSURL *baseURL = [NSURL URLWithString:@"http://54.77.168.152"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    self.editProfileManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    self.editProfileManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *editProfileResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[appDelegate dealerMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:statusCodes];
    
    RKRequestDescriptor *editProfileRequestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:[self editProfileMapping]
                                          objectClass:[Dealer class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodAny];
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"DealersKeychain" accessGroup:nil];
    [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];

    NSString *username = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    self.password = [keychain objectForKey:(__bridge id)(kSecValueData)];
    
    [self.editProfileManager.HTTPClient setAuthorizationHeaderWithUsername:username password:self.password];
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addPropertyMapping: [RKAttributeMapping attributeMappingFromKeyPath:@"detail" toKeyPath:@"errorMessage"]];
    
    [self.editProfileManager addResponseDescriptorsFromArray:@[editProfileResponseDescriptor]];
    [self.editProfileManager addRequestDescriptor:editProfileRequestDescriptor];
}

- (void)saveChanges
{
    if (!(self.fullName.text.length > 0)) {
        
        [blankFullName show:YES];
        [blankFullName hide:YES afterDelay:1.5];
        return;
        
    } else if (!(self.email.text.length > 0)) {
        
        [blankEmail show:YES];
        [blankEmail hide:YES afterDelay:1.5];
        return;
    }
    
    if (![self didProfileChange] && !self.didChangeProfilePic) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // Set the new values in the dealer object
    
    appDelegate.dealer.fullName = self.fullName.text;
    appDelegate.dealer.about = self.about.text;
    appDelegate.dealer.location = self.location.text;
    
    if ([self.dateOfBirth.text isEqualToString:@"Date of Birth"]) {
        appDelegate.dealer.dateOfBirth = nil;
    } else {
        appDelegate.dealer.dateOfBirth = self.datePicker.date;
    }
    
    if ([self.gender.text isEqualToString:@"Gender"]) {
        appDelegate.dealer.gender = @"Unspecified";
    } else {
        appDelegate.dealer.gender = self.gender.text;
    }
    
    if (![self.email.text isEqualToString:self.originalEmail]) {
        self.didChangeEmail = YES;
    }
    appDelegate.dealer.email = self.email.text;
    appDelegate.dealer.username = self.email.text;
    
    if (self.didChangeProfilePic) {
        if (userHaveProfilePic) {
            photoFileName = [NSString stringWithFormat:@"%@_%@.jpg", appDelegate.dealer.email, [NSDate date]];
            appDelegate.dealer.photoURL = [NSString stringWithFormat:@"media/Profile_Photos/%@", photoFileName];
            shouldUploadPhoto = YES;
            [self uploadPhoto:self.profilePicButton.imageView.image];
        } else {
            appDelegate.dealer.photoURL = @"";
            appDelegate.dealer.photo = nil;
        }
    }
    
    [uploading show:YES];
    
    [self uploadChanges];
}

- (void)uploadChanges
{
    NSString *path = [NSString stringWithFormat:@"/dealers/%@/", appDelegate.dealer.dealerID];
    
    [self.editProfileManager patchObject:appDelegate.dealer
                                    path:path
                              parameters:nil
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     
                                     NSLog(@"Profile was edited successfuly!");
                                     
                                     didUploadUserData = YES;
                                     
                                     
                                     if (shouldUploadPhoto) {
                                         if (didPhotoFinishedUploading) {
                                             [uploading hide:NO];
                                             [saved show:NO];
                                             [saved hide:YES afterDelay:1.5];
                                             [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.5];
                                         }
                                     } else {
                                         [appDelegate saveUserDetailsOnDevice];
                                         if (self.didChangeEmail) [self updateUsername];
                                         [uploading hide:NO];
                                         [saved show:NO];
                                         [saved hide:YES afterDelay:1.5];
                                         [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.5];
                                     }
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     
                                     [uploading hide:NO];
                                     [couldntUpload show:NO];
                                     [couldntUpload hide:YES afterDelay:2.0];
                                     [[AWSS3TransferManager defaultS3TransferManager] cancelAll];
                                 }];
}

- (void)uploadPhoto:(UIImage *)image
{
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    NSString *key = self.appDelegate.dealer.photoURL;
    UIImage *sizedProfilPic = [appDelegate resizeImage:image toSize:CGSizeMake(100,100)];
    appDelegate.dealer.photo = UIImageJPEGRepresentation(sizedProfilPic, 0.6);
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
                                                               didPhotoFinishedUploading = YES;
                                                               if (didUploadUserData) {
                                                                   [appDelegate saveUserDetailsOnDevice];
                                                                   if (self.didChangeEmail) [self updateUsername];
                                                                   [uploading hide:NO];
                                                                   [saved show:NO];
                                                                   [saved hide:YES afterDelay:1.5];
                                                                   [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.5];
                                                               }
                                                           }
                                                           return nil;
                                                       }];
}

- (void)updateUsername
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"DealersKeychain" accessGroup:nil];
    
    [keychain setObject:self.email.text forKey:(__bridge id)(kSecAttrAccount)];
    
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:self.email.text password:self.password];
}

- (BOOL)didProfileChange
{
    // Checking if Photo has been changed separately in self.didChangeProfilePic
    
    if (![self.fullName.text isEqualToString:self.originalFullName]) {
        
        return YES;
    }
    
    if (![self.about.text isEqualToString:self.originalAbout]) {
        
        if (![appDelegate.dealer.about isEqualToString:@"None"]) {
            
            return YES;
        }
    }
    
    if (![self.location.text isEqualToString:self.originalLocation]) {
        
        if (![appDelegate.dealer.location isEqualToString:@"None"]) {
            
            return YES;
        }
    }
    
    if (!([self.dateOfBirth.text isEqualToString:@"Date of Birth"] && !self.originalDateOfBirth)) {
        
        if (![self.datePicker.date isEqualToDate:self.originalDateOfBirth]) {
            
            return YES;
        }
    }
    
    if (!([self.gender.text isEqualToString:@"Gender"] && !self.originalGender)) {
        
        if (![self.gender.text isEqualToString:self.originalGender]) {
            
            return YES;
        }
    }
    
    if (![self.email.text isEqualToString:self.originalEmail]) {
        
        return YES;
    }
    
    return NO;
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
