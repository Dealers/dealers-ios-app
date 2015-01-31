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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Edit Profile", nil);
    
    [self initialize];
    
    [self signUpForKeyboardNotifications];
    [self setNavigationBar];
    [self setProgressIndicator];
    [self setProfilePicSection];
    [self saveOriginalValues];
    [self setKnownValues];
    [self configureRestKit];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!didUploadUserData) {
        
        appDelegate.dealer.photoURL = self.originalPhotoURL;
        appDelegate.dealer.photo = self.originalPhotoData;
        appDelegate.dealer.fullName = self.originalFullName;
        appDelegate.dealer.about = self.originalAbout;
        appDelegate.dealer.location = self.originalLocation;
        appDelegate.dealer.dateOfBirth = self.originalDateOfBirth;
        appDelegate.dealer.gender = self.originalGender;
        appDelegate.dealer.email = self.originalEmail;
        appDelegate.dealer.username = self.originalUsername;
    }
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    self.didChangeProfilePic = NO;
    self.datePickerIsShowing = NO;
    self.didChangeEmail = NO;
    
    self.editedDealer = [[Dealer alloc]init];
    
    self.delegate = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.profilePicView addGestureRecognizer:tap];
    
    didUploadUserData = NO;
    didPhotoFinishedUploading = NO;
    shouldUploadPhoto = NO;
    
    if (appDelegate.dealer.photo) {
        userHaveProfilePic = YES;
    } else {
        userHaveProfilePic = NO;
    }
}


#pragma mark - Setting the view and sections

- (void)setNavigationBar
{
    UIView *saveButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 30)];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveButton addTarget:self action:@selector(saveChanges) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setFrame:CGRectMake(8, 0, 58, 30)];
    [saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0]];
    [saveButton setBackgroundColor:[appDelegate ourPurple]];
    [saveButton.layer setCornerRadius:5.0];
    [saveButton.layer setMasksToBounds:YES];
    
    [saveButtonView addSubview:saveButton];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:saveButtonView];
    
    self.navigationItem.rightBarButtonItem = barButton;
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
    self.originalFullName = [appDelegate.dealer.fullName mutableCopy];
    self.originalEmail = [appDelegate.dealer.email mutableCopy];
    self.originalUsername = [appDelegate.dealer.username mutableCopy];
    self.originalDateOfBirth = appDelegate.dealer.dateOfBirth;

    if ([appDelegate.dealer.location isEqualToString:@"None"]) {
        self.originalLocation = @"";
    } else {
        self.originalLocation = [appDelegate.dealer.location mutableCopy];
    }
    
    if ([appDelegate.dealer.about isEqualToString:@"None"]) {
        self.originalAbout = @"";
    } else {
        self.originalAbout = [appDelegate.dealer.about mutableCopy];
    }
    
    if ([appDelegate.dealer.gender isEqualToString:@"None"]) {
        self.originalGender = @"";
    } else {
        self.originalGender = [appDelegate.dealer.gender mutableCopy];
    }
    
    if ([appDelegate.dealer.photoURL isEqualToString:@"None"]) {
        self.originalPhotoURL = @"";
    } else {
        self.originalPhotoURL = [appDelegate.dealer.photoURL mutableCopy];
    }
    
    self.originalPhotoData = [appDelegate.dealer.photo mutableCopy];
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
        
        if (![appDelegate.dealer.gender isEqualToString:NSLocalizedString(@"Unspecified", nil)]) {
            
            self.gender.text = NSLocalizedString(appDelegate.dealer.gender, nil);
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
    blankFullName.labelText = NSLocalizedString(@"Name can't be blank!", nil);
    blankFullName.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    blankFullName.animationType = MBProgressHUDAnimationZoomIn;
    
    blankEmail = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    blankEmail.delegate = self;
    blankEmail.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    blankEmail.mode = MBProgressHUDModeCustomView;
    blankEmail.labelText = NSLocalizedString(@"Email is blank!", nil);
    blankEmail.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    blankEmail.animationType = MBProgressHUDAnimationZoomIn;
    
    UIImageView *loadingAnimation = [appDelegate loadingAnimationWhite];
    [loadingAnimation startAnimating];
    
    uploading = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    uploading.delegate = self;
    uploading.customView = loadingAnimation;
    uploading.mode = MBProgressHUDModeCustomView;
    uploading.labelText = NSLocalizedString(@"Uploading", nil);
    uploading.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    uploading.animationType = MBProgressHUDAnimationZoomIn;
    
    saved = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    saved.delegate = self;
    saved.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Complete"]];
    saved.mode = MBProgressHUDModeCustomView;
    saved.labelText = NSLocalizedString(@"Saved!", nil);
    saved.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    saved.animationType = MBProgressHUDAnimationZoomIn;
    
    couldntUpload = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    couldntUpload.delegate = self;
    couldntUpload.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    couldntUpload.mode = MBProgressHUDModeCustomView;
    couldntUpload.labelText = NSLocalizedString(@"Couldn't upload the changes...", nil);
    couldntUpload.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    couldntUpload.detailsLabelText = NSLocalizedString(@"Please try again", nil);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
                                        initWithTitle:NSLocalizedString(@"What is your gender?", nil)
                                        delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                        destructiveButtonTitle:nil
                                        otherButtonTitles:NSLocalizedString(@"Unspecified", nil), NSLocalizedString(@"Female", nil), NSLocalizedString(@"Male", nil), nil];
        
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
                       initWithTitle:NSLocalizedString(@"Change Profile Picture", nil)
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                       destructiveButtonTitle:NSLocalizedString(@"Remove Photo", nil)
                       otherButtonTitles:NSLocalizedString(@"Take a Picture", nil), NSLocalizedString(@"From Library", nil), nil];
    } else {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:NSLocalizedString(@"Add Profile Picture", nil)
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                       destructiveButtonTitle:nil
                       otherButtonTitles:NSLocalizedString(@"Take a Picture", nil), NSLocalizedString(@"From Library", nil), nil];
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
                self.gender.text = NSLocalizedString(@"Gender", nil);
                self.gender.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
            } else if (buttonIndex == 1) {
                self.gender.text = NSLocalizedString(@"Female", nil);
                self.gender.textColor = [UIColor blackColor];
            } else if (buttonIndex == 2) {
                self.gender.text = NSLocalizedString(@"Male", nil);
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
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                      message:NSLocalizedString(@"Device has no camera", nil)
                                                                     delegate:nil
                                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
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
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                      message:NSLocalizedString(@"Device has no camera", nil)
                                                                     delegate:nil
                                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)keyboardWillShow {
    
    if (self.datePickerIsShowing)
        [self hideDatePickerCell];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}


#pragma mark - Private Info

- (void)setDateOfBirthLabel {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
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
    
    NSDate *date = sender.date;
    
    while ([date timeIntervalSinceNow] > 0) {
        date = [date dateByAddingTimeInterval: -(31536000)];
    }
    
    [sender setDate:date animated:YES];
    
    if (!self.didCancelDate) {
        self.dateOfBirth.text = [self.dateFormatter stringFromDate:sender.date];
    }
}

- (IBAction)noDate:(id)sender {
    
    self.dateOfBirth.text = NSLocalizedString(@"Date of Birth", nil);
    self.dateOfBirth.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.didCancelDate = YES;
    [self hideDatePickerCell];
}


#pragma mark - Uploading and dismissing

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
    [RKRequestDescriptor requestDescriptorWithMapping:[appDelegate editProfileMapping]
                                          objectClass:[Dealer class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodAny];
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"DealersKeychain" accessGroup:nil];
    [keychain setObject:@"DealersKeychain" forKey:(__bridge id)kSecAttrService];
    [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];

    NSString *token = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    
    [self.editProfileManager.HTTPClient setAuthorizationHeaderWithToken:token];
    
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
    
    if ([self.dateOfBirth.text isEqualToString:NSLocalizedString(@"Date of Birth", nil)]) {
        appDelegate.dealer.dateOfBirth = nil;
    } else {
        appDelegate.dealer.dateOfBirth = self.datePicker.date;
    }
    
    if ([self.gender.text isEqualToString:NSLocalizedString(@"Gender", nil)]) {
        appDelegate.dealer.gender = NSLocalizedString(@"Unspecified", nil);
    } else {
        appDelegate.dealer.gender = [appDelegate getEnglishGender:self.gender.text];
    }
    
    if (![self.email.text isEqualToString:self.originalEmail]) {
        self.didChangeEmail = YES;
    }
    appDelegate.dealer.email = self.email.text;
    
    if (appDelegate.dealer.email.length > 30) {
        appDelegate.dealer.username = [appDelegate.dealer.email substringToIndex:30];
    } else {
        appDelegate.dealer.username = appDelegate.dealer.email;
    }
    
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
                                                                   [uploading hide:NO];
                                                                   [saved show:NO];
                                                                   [saved hide:YES afterDelay:1.5];
                                                                   [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.5];
                                                               }
                                                           }
                                                           return nil;
                                                       }];
}

- (BOOL)didProfileChange
{
    // Checking if Photo has been changed separately in self.didChangeProfilePic
    
    if (![self.fullName.text isEqualToString:self.originalFullName]) {
        
        return YES;
    }
    
    if (![self.about.text isEqualToString:self.originalAbout]) {
        
        return YES;
    }
    
    if (![self.location.text isEqualToString:self.originalLocation]) {
        
        return YES;
    }
    
    if (!([self.dateOfBirth.text isEqualToString:NSLocalizedString(@"Date of Birth", nil)] && !self.originalDateOfBirth)) {
        
        if (![self.datePicker.date isEqualToDate:self.originalDateOfBirth]) {
            
            return YES;
        }
    }
    
    if (!([self.gender.text isEqualToString:NSLocalizedString(@"Gender", nil)] && !(self.originalGender.length > 0))) {
        
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
    ProfileTableViewController *ptvc = self.delegate;
    ptvc.afterEditing = YES;
    [self.navigationController popToViewController:ptvc animated:YES];
}


@end
