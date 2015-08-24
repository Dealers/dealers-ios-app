//
//  SignUpTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/17/14.
//
//

#import "SignUpTableViewController.h"

#define AWS_S3_BUCKET_NAME @"dealers-app"
#define PROFILE_PIC_ACTION_SHEET_TAG 333
#define GENDER_ACTION_SHEET_TAG 2
#define DATE_OF_BIRTH_ACTION_SHEET_TAG 4444

@interface SignUpTableViewController ()

@end

@implementation SignUpTableViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Sign Up", nil);
    
    [self initialize];
    [self setLoadingAnimation];
    [self setProgressIndicator];
    [self setDateOfBirthLabel];
    [self signUpForKeyboardNotifications];
}

- (void)initialize
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    appDelegate = [[UIApplication sharedApplication] delegate];
    didUploadUserData = NO;
    didPhotoFinishedUploading = NO;
    self.datePickerIsShowing = NO;
    [self.changeProfilePicButton setImage:[UIImage imageNamed:@"Change Photo Button"] forState:UIControlStateNormal];
    
    [self.privacyPolicyAgreement setTitle:NSLocalizedString(@"By signing up, you agree to the\nTerms of Service & Privacy Policy", nil) forState:UIControlStateNormal];
    [self.privacyPolicyAgreement.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.privacyPolicyAgreement.titleLabel setNumberOfLines:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.profilePicView addGestureRecognizer:tap];
    [self.changeProfilePicButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self setRoundCornersToButtons];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Sign Up Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)setLoadingAnimation
{
    [self.view layoutIfNeeded];
    loadingAnimation = [appDelegate loadingAnimationWhite];
    [self.signUpButtonBackground addSubview:loadingAnimation];
    CGPoint loadingAnimationCenter = CGPointMake(self.signUpButtonBackground.bounds.size.width / 2, self.signUpButtonBackground.bounds.size.height / 2);
    loadingAnimation.center = loadingAnimationCenter;
    [self setConstraintsForLoadingAnimation];
    loadingAnimation.transform = CGAffineTransformMakeScale(0.001, 0.001);
}

- (void)setConstraintsForLoadingAnimation
{
    [self.signUpButtonBackground addConstraint:[NSLayoutConstraint constraintWithItem:loadingAnimation
                                                                            attribute:NSLayoutAttributeCenterX
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.signUpButtonBackground
                                                                            attribute:NSLayoutAttributeCenterX
                                                                           multiplier:1.0
                                                                             constant:0]];
    
    [self.signUpButtonBackground addConstraint:[NSLayoutConstraint constraintWithItem:loadingAnimation
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.signUpButtonBackground
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1.0
                                                                             constant:0]];
}

- (void)setRoundCornersToButtons
{
    self.changeProfilePicButton.layer.cornerRadius = self.changeProfilePicButton.frame.size.width / 2;
    self.changeProfilePicButton.layer.masksToBounds = YES;
    self.signUpButton.layer.cornerRadius = 8.0;
    self.signUpButton.layer.masksToBounds = YES;
    self.signUpButtonBackground.layer.cornerRadius = 8.0;
    self.signUpButtonBackground.layer.masksToBounds = YES;
}

- (void)setProgressIndicator
{
    blankFullName = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    blankFullName.delegate = self;
    blankFullName.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    blankFullName.mode = MBProgressHUDModeCustomView;
    blankFullName.labelText = NSLocalizedString(@"Please enter your name!", nil);
    blankFullName.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    blankFullName.animationType = MBProgressHUDAnimationZoomIn;
    
    blankEmail = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    blankEmail.delegate = self;
    blankEmail.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    blankEmail.mode = MBProgressHUDModeCustomView;
    blankEmail.labelText = NSLocalizedString(@"Email is blank!", nil);
    blankEmail.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    blankEmail.animationType = MBProgressHUDAnimationZoomIn;
    
    blankPassword = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    blankPassword.delegate = self;
    blankPassword.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    blankPassword.mode = MBProgressHUDModeCustomView;
    blankPassword.labelText = NSLocalizedString(@"Password is blank!", nil);
    blankPassword.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    blankPassword.animationType = MBProgressHUDAnimationZoomIn;
    
    noConnection = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    noConnection.delegate = self;
    noConnection.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    noConnection.mode = MBProgressHUDModeCustomView;
    noConnection.labelText = NSLocalizedString(@"Can't connect the server", nil);
    noConnection.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    noConnection.detailsLabelText = NSLocalizedString(@"Check your connection", nil);
    noConnection.detailsLabelFont = [UIFont fontWithName:@"Avenir-Light" size:15.0];
    noConnection.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:blankFullName];
    [self.navigationController.view addSubview:blankEmail];
    [self.navigationController.view addSubview:blankPassword];
    [self.navigationController.view addSubview:noConnection];
}

- (void)startLoading
{
    [loadingAnimation startAnimating];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.15
                     animations:^{
                         self.signUpButton.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.15 animations:^{ loadingAnimation.transform = CGAffineTransformMakeScale(1.0, 1.0); }];
                     }];
}

- (void)stopLoading
{
    [loadingAnimation startAnimating];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.15
                     animations:^{
                         loadingAnimation.transform = CGAffineTransformMakeScale(0.001, 0.001);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.15 animations:^{ self.signUpButton.alpha = 1.0; }];
                     }];
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == 4) {
        
        height = self.datePickerIsShowing ? 162.0 : 0.0;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
            
        case 0:
            [self.fullNameTextField becomeFirstResponder];
            break;
            
        case 1:
            [self.emailTextField becomeFirstResponder];
            break;
            
        case 2:
            [self.passwordTextField becomeFirstResponder];
            break;
            
        case 3:
            [self.view endEditing:YES];
            if (self.datePickerIsShowing) {
                
                [self hideDatePickerCell];
                
            } else {
                if ([self.dateOfBirthLabel.text isEqualToString:NSLocalizedString(@"Date Of Birth (optional)", nil)] || !(self.dateOfBirthLabel.text.length > 0)) {
                    
                    [self showDatePickerCell];
                    [self performSelector:@selector(dateChanged:) withObject:self.datePicker];
                    
                } else {
                    
                    UIActionSheet *expirationDateSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                                    delegate:self
                                                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                                      destructiveButtonTitle:NSLocalizedString(@"Remove Date", nil)
                                                                           otherButtonTitles:NSLocalizedString(@"Change Date", nil), nil];
                    expirationDateSheet.tag = DATE_OF_BIRTH_ACTION_SHEET_TAG;
                    [expirationDateSheet showInView:self.view];
                }
            }
            break;
            
        case 5: {
            [self.view endEditing:YES];
            UIActionSheet *genderOptions = [[UIActionSheet alloc]
                                            initWithTitle:NSLocalizedString(@"What is your gender?", nil)
                                            delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                            destructiveButtonTitle:nil
                                            otherButtonTitles:NSLocalizedString(@"Unspecified", nil), NSLocalizedString(@"Female", nil), NSLocalizedString(@"Male", nil), nil];
            genderOptions.tag = GENDER_ACTION_SHEET_TAG;
            [genderOptions showInView:self.view];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            if (self.datePickerIsShowing) {
                [self hideDatePickerCell];
            }
        }
            break;
            
            
        default:
            break;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}


#pragma mark - View elements

- (void)setDateOfBirthLabel
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.datePickerIsShowing = NO;
    self.datePicker.hidden = YES;
}

- (void)showDatePickerCell
{
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.datePicker.hidden = NO;
    
    // Need to give some time to the content size to set itself to the right size, in case the keyboard was active
    [self performSelector:@selector(setDatePickerAtTheMiddle) withObject:nil afterDelay:0.1];
    
    if (self.didCancelDate) self.datePicker.date = [NSDate date];
    
    self.didCancelDate = NO;
    self.datePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 1.0f;
        self.dateOfBirthLabel.textColor = [appDelegate ourPurple];
    }];
}

- (void)hideDatePickerCell
{
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 0.0f;
        self.dateOfBirthLabel.textColor = self.didCancelDate ? [UIColor colorWithWhite:0.8 alpha:1.0] : [UIColor blackColor];
    } completion:^(BOOL finished) {
        self.datePicker.hidden = YES;
    }];
}

- (IBAction)dateChanged:(UIDatePicker *)sender {
    
    NSDate *date = sender.date;
    
    while ([date timeIntervalSinceNow] > 0) {
        date = [date dateByAddingTimeInterval: -(31536000)];
    }
    
    [sender setDate:date animated:YES];
    
    if (!self.didCancelDate) {
        self.dateOfBirthLabel.text = [self.dateFormatter stringFromDate:sender.date];
    }
}

- (void)setDatePickerAtTheMiddle
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)noDate {
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.dateOfBirthLabel.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.dateOfBirthLabel.text = NSLocalizedString(@"Date Of Birth (optional)", nil) ;
                         self.dateOfBirthLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
                         self.didCancelDate = YES;
                         //    [self hideDatePickerCell];
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.dateOfBirthLabel.alpha = 1.0;
                                          }];
                     }];
}


#pragma mark - Signing up

- (IBAction)signUp:(id)sender
{
    
    if (!(self.fullNameTextField.text.length > 0)) {
        
        [blankFullName show:YES];
        [blankFullName hide:YES afterDelay:1.5];
        
    } else if (!(self.emailTextField.text.length > 0)) {
        
        [blankEmail show:YES];
        [blankEmail hide:YES afterDelay:1.5];
        
    } else if (!(self.passwordTextField.text.length > 0)) {
        
        [blankPassword show:YES];
        [blankPassword hide:YES afterDelay:1.5];
        
    } else {
        
        [self startLoading];
        [self.view endEditing:YES];
        [self saveUserDetails];
        [self uploadData];
        [appDelegate logButtonPress:@"Sign up with email"];
    }
}

- (IBAction)privacyPolicy:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.dealers-app.com/PrivacyPage.htm"]];
}

- (IBAction)changeProfilePic:(id)sender {
    
    UIActionSheet *actionSheet;
    
    if (hasPhoto) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:NSLocalizedString(@"Change Profile Picture", nil)
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                       destructiveButtonTitle:NSLocalizedString(@"Remove Photo", nil)
                       otherButtonTitles: NSLocalizedString(@"Take a Picture", nil), NSLocalizedString(@"From Library", nil), nil];
    } else {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:NSLocalizedString(@"Add Profile Picture", nil)
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                       destructiveButtonTitle:nil
                       otherButtonTitles:NSLocalizedString(@"Take a Picture", nil), NSLocalizedString(@"From Library", nil), nil];
    }
    actionSheet.tag = PROFILE_PIC_ACTION_SHEET_TAG;
    [actionSheet showInView:self.view];
    
    if (self.datePickerIsShowing) {
        [self hideDatePickerCell];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self.changeProfilePicButton setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
    hasPhoto = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.fullNameTextField]) {
        [self.emailTextField becomeFirstResponder];
    } else if ([textField isEqual:self.emailTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordTextField]) {
        [textField resignFirstResponder];
        [self showDatePickerCell];
        [self performSelector:@selector(dateChanged:) withObject:self.datePicker];
    }
    
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
            
        case PROFILE_PIC_ACTION_SHEET_TAG:
            
            [self setProfilePicActionSheet:buttonIndex];
            break;
            
        case GENDER_ACTION_SHEET_TAG:
            
            if (buttonIndex == 0) {
                self.genderLabel.text = NSLocalizedString(@"Gender (optional)", nil);
                self.genderLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
            } else if (buttonIndex == 1) {
                self.genderLabel.text = NSLocalizedString(@"Female", nil);
                self.genderLabel.textColor = [UIColor blackColor];
            } else if (buttonIndex == 2) {
                self.genderLabel.text = NSLocalizedString(@"Male", nil);
                self.genderLabel.textColor = [UIColor blackColor];
            }
            break;
            
        case DATE_OF_BIRTH_ACTION_SHEET_TAG:
            
            if (buttonIndex == 0) {
                
                [self noDate];
                
            } else if (buttonIndex == 1) {
                
                [self showDatePickerCell];
            }
            break;
            
        default:
            break;
    }
}

- (void)setProfilePicActionSheet:(NSInteger)buttonIndex
{
    if (hasPhoto) {
        
        if (buttonIndex == 0) { // Remove Photo:
            
            [self.changeProfilePicButton setImage:[UIImage imageNamed:@"Change Photo Button"] forState:UIControlStateNormal];
            hasPhoto = NO;
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

- (void)saveUserDetails
{
    self.dealer = [[Dealer alloc] init];
    
    self.dealer.fullName = self.fullNameTextField.text;
    self.dealer.email = self.emailTextField.text;
    
    if (self.dealer.email.length > 30) {
        self.dealer.username = [self.dealer.email substringToIndex:30];
    } else {
        self.dealer.username = self.emailTextField.text;
    }
    
    self.dealer.userPassword = self.passwordTextField.text;
    
    if (![self.dateOfBirthLabel.text isEqualToString:NSLocalizedString(@"Date Of Birth (optional)", nil)]) {
        self.dealer.dateOfBirth = self.datePicker.date;
    }
    
    if (![self.genderLabel.text isEqualToString:NSLocalizedString(@"Gender (optional)", nil)]) {
        
        if ([NSLocalizedString(self.genderLabel.text, nil) isEqualToString:NSLocalizedString(@"Male", nil)]) {
            self.dealer.gender = @"Male";
        } else if ([NSLocalizedString(self.genderLabel.text, nil) isEqualToString:NSLocalizedString(@"Female", nil)])
            self.dealer.gender = @"Female";
    }
    
    self.dealer.registerDate = [NSDate date];
    
    if (hasPhoto) {
        
        UIImage *sizedProfilPic = [appDelegate resizeImage:self.changeProfilePicButton.imageView.image toSize:CGSizeMake(90, 90)];
        self.dealer.photo = UIImageJPEGRepresentation(sizedProfilPic, 0.6);
        photoFileName = [NSString stringWithFormat:@"%@_%f.jpg", self.dealer.email, [[NSDate date] timeIntervalSince1970]];
        NSString *filePathAtS3 = [NSString stringWithFormat:@"media/Profile_Photos/%@", photoFileName];
        self.dealer.photoURL = filePathAtS3;
    }
}

- (void)uploadData
{
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:@"ubuntu" password:@"090909deal"];
    [[RKObjectManager sharedManager] postObject:self.dealer
                                           path:@"/dealers/"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            
                                            NSLog(@"Dealer signed up successfuly!");
                                            
                                            didUploadUserData = YES;
                                            appDelegate.dealer = mappingResult.firstObject;
                                            
                                            if (!hasPhoto) {
                                                
                                                [self getToken];
                                                
                                            } else if (didPhotoFinishedUploading) {
                                                
                                                [self getToken];
                                            }
                                        }
     
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            
                                            Error *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                                            NSLog(@"%@", [errors messagesString]);
                                            
                                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Couldn't sign up...", nil)
                                                                                           message:[NSString stringWithFormat:@"\n%@", [errors messagesString]]
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                 otherButtonTitles:nil];
                                            [alert show];
                                            
                                            [[AWSS3TransferManager defaultS3TransferManager] cancelAll];
                                            [self stopLoading];
                                        }];
    
    if (self.changeProfilePicButton.imageView.image) {
        
        [self uploadPhoto];
    }
}

- (void)uploadPhoto
{
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    NSString *key = self.dealer.photoURL;
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:photoFileName];
    [self.dealer.photo writeToFile:filePath atomically:YES];
    
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
                                                                   
                                                                   appDelegate.dealer.photo = self.dealer.photo;
                                                                   [self getToken];
                                                               }
                                                           }
                                                           return nil;
                                                       }];
}

- (void)getToken
{
    NSString *username = self.appDelegate.dealer.username;
    NSString *password = self.passwordTextField.text;
    NSDictionary *parameters = @{@"username": username,
                                 @"password": password
                                 };
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[RKObjectManager sharedManager].baseURL];
    [client setAuthorizationHeaderWithUsername:username password:password];
    [client postPath:@"/dealers-token-auth/"
          parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id result) {
                 
                 NSError *error;
                 NSDictionary *tokenDictionary = [NSJSONSerialization JSONObjectWithData:result
                                                                                 options:kNilOptions
                                                                                   error:&error];
                 NSString *token = [tokenDictionary objectForKey:@"token"];
                 [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithToken:token];
                 
                 KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"DealersKeychain" accessGroup:nil];
                 [keychain setObject:@"DealersKeychain" forKey:(__bridge id)kSecAttrService];
                 [keychain setObject:token forKey:(__bridge id)(kSecAttrAccount)];
                 [keychain setObject:self.passwordTextField.text forKey:(__bridge id)(kSecValueData)];
                 
                 [self enterDealers];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 NSLog(@"\n\nFailed to fetch token. Error: %@", error.localizedDescription);
             }];
}

- (void)enterDealers
{
    // First ask the user for his favorite categories
    [appDelegate intercomSuccessfulLogin];
    PersonalizeTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Personalize"];
    ptvc.afterSignUp = YES;
    [self.navigationController pushViewController:ptvc animated:YES];
}


@end
