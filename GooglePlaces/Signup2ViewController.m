//
//  Signup2ViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 10/6/13.
//
//

#import "Signup2ViewController.h"
#import "Functions.h"
#import "MyFeedsViewController.h"
#import "KeychainItemWrapper.h"

#define AWS_S3_BUCKET_NAME @"dealers-app"

@interface Signup2ViewController ()

@end

@implementation Signup2ViewController

@synthesize appDelegate;
@synthesize fullNameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize dateOfBirthTextField;
@synthesize genderTextField;
@synthesize profilePic;
@synthesize datepick,NavBar,scroll,GenderNavBar,GenderPicker,list,LoadingImage,PurpImage,SignupButton;


-(void) BackgroundMethod {
    
    Dealer *dealer = [[Dealer alloc]init];
    
    if (!profilePic.image) {
        NSData *imageData = UIImageJPEGRepresentation(profilePic.image, 2);
        NSString *urlString = @"http://www.dealers.co.il/uploadphpFile.php";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        Photoid = returnString;
        
        dealer.photo = UIImageJPEGRepresentation(profilePic.image, 1.0);
        
    } else {

    }
    
    NSString *date;
    if ([dateOfBirthTextField.text length] == 0) {
        date = @"0";
    } else date = dateOfBirthTextField.text;
    
    NSString *gender;
    if ([genderTextField.text length] == 0) {
        gender = @"0";
    } else gender = genderTextField.text;
    
    NSString *strURL = [NSString stringWithFormat:@"http://www.dealers.co.il/phpFile.php?Name=%@&Password=%@&Email=%@&Date=%@&Gender=%@&Photoid=%@",fullNameTextField.text,passwordTextField.text,emailTextField.text,date,gender,Photoid];
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",strURL);
    
    // to execute php code
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    // Filling the information on the user:
    
    dealer.dealerID = [NSNumber numberWithInt:strResult.intValue];
    dealer.email = emailTextField.text;
    dealer.fullName = fullNameTextField.text;
    dealer.dateOfBirth = self.selectedDate;
    dealer.gender = genderTextField.text;
    dealer.photoURL = Photoid;
    
    appDelegate.dealer = dealer;
}

-(void) initialize
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    isPopping = NO;
    [scroll setScrollEnabled:NO];
    [scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(SignupButton.frame)+10+216+44)))];
    scrollOriginOffset = scroll.contentOffset;
    [self.fullNameTextField setDelegate:self];
    [self.fullNameTextField setReturnKeyType:UIReturnKeyNext];
    [self.fullNameTextField addTarget:self action:@selector(fullNameTextField) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.fullNameTextField.tag = 1;
    [self.emailTextField setDelegate:self];
    [self.emailTextField setReturnKeyType:UIReturnKeyNext];
    [self.emailTextField addTarget:self action:@selector(emailTextField) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.emailTextField.tag = 2;
    [self.passwordTextField setDelegate:self];
    [self.passwordTextField setReturnKeyType:UIReturnKeyNext];
    [self.passwordTextField addTarget:self action:@selector(passwordTextField) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.passwordTextField.tag = 3;
    [self.dateOfBirthTextField setDelegate:self];
    [self.dateOfBirthTextField setReturnKeyType:UIReturnKeyNext];
    [self.dateOfBirthTextField addTarget:self action:@selector(dateOfBirthTextField) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.dateOfBirthTextField.tag = 4;
    [self.genderTextField setDelegate:self];
    [self.genderTextField setReturnKeyType:UIReturnKeyDone];
    [self.genderTextField addTarget:self action:@selector(passwordTextField) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.genderTextField.tag = 5;
    [self.NavBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.NavBar setBarTintColor:[UIColor lightGrayColor]];
    [self.NavBar setTranslucent:YES];
    [self.GenderNavBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.GenderNavBar setBarTintColor:[UIColor lightGrayColor]];
    [self.GenderNavBar setTranslucent:YES];
    
    list = [[NSMutableArray alloc] initWithObjects:@"Gender",@"Male",@"Female", nil];
    Photoid=@"0";
    
    profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
    profilePic.layer.masksToBounds = YES;
    didUploadUserData = NO;
    didPhotoFinishedUploading = NO;
}

- (void)viewDidLoad
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.title = @"Sign Up";
    [self setElementsLocation];
    [self initialize];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    isPopping = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    isPopping = YES;
    self.app.networkActivityIndicatorVisible = NO;
}

- (void)setElementsLocation
{
    PurpImage.center = CGPointMake(PurpImage.center.x, CGRectGetMaxY(self.textFieldsFrame.frame) + 42);
    SignupButton.center = PurpImage.center;
    LoadingImage.center = PurpImage.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)StartLoading
{
    self.app.networkActivityIndicatorVisible = YES;
    [UIView animateWithDuration:0.3
                     animations:^{
                         SignupButton.alpha = 0;
                         SignupButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
                     }];
    
    LoadingImage.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"Loadingwhite.png"],
                                    [UIImage imageNamed:@"Loading5white.png"],
                                    [UIImage imageNamed:@"Loading10white.png"],
                                    [UIImage imageNamed:@"Loading15white.png"],
                                    [UIImage imageNamed:@"Loading20white.png"],
                                    [UIImage imageNamed:@"Loading25white.png"],
                                    [UIImage imageNamed:@"Loading30white.png"],
                                    [UIImage imageNamed:@"Loading35white.png"],
                                    [UIImage imageNamed:@"Loading40white.png"],
                                    [UIImage imageNamed:@"Loading45white.png"],
                                    [UIImage imageNamed:@"Loading50white.png"],
                                    [UIImage imageNamed:@"Loading55white.png"],
                                    [UIImage imageNamed:@"Loading60white.png"],
                                    [UIImage imageNamed:@"Loading65white.png"],
                                    [UIImage imageNamed:@"Loading70white.png"],
                                    [UIImage imageNamed:@"Loading75white.png"],
                                    [UIImage imageNamed:@"Loading80white.png"],
                                    [UIImage imageNamed:@"Loading85white.png"],
                                    nil];
    
    LoadingImage.animationDuration = 0.3;
    [LoadingImage startAnimating];
    LoadingImage.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3
                     animations:^{
                         LoadingImage.alpha = 1.0;
                         LoadingImage.transform = CGAffineTransformMakeScale(1,1);
                     }];
}

-(void) StopLoading
{
    self.app.networkActivityIndicatorVisible = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         LoadingImage.alpha = 0;
                         LoadingImage.transform = CGAffineTransformMakeScale(0.01, 0.01);}];
    [LoadingImage stopAnimating];
    [UIView animateWithDuration:0.3
                     animations:^{
                         SignupButton.alpha = 1.0;
                         SignupButton.transform = CGAffineTransformMakeScale(1,1);
                     }];
}

- (void)saveUserDetails
{
    self.dealer = [[Dealer alloc]init];
    
    self.dealer.email = emailTextField.text;
    self.dealer.username = emailTextField.text;
    self.dealer.userPassword = passwordTextField.text;
    self.dealer.fullName = fullNameTextField.text;
    self.dealer.dateOfBirth = self.selectedDate;
    self.dealer.gender = genderTextField.text;
    self.dealer.registerDate = [NSDate date];
    
    if (profilePic.image) {
        
        hasPhoto = YES;
        UIImage *sizedProfilPic = [appDelegate resizeImage:profilePic.image toSize:CGSizeMake(100,100)];
        self.dealer.photo = UIImageJPEGRepresentation(sizedProfilPic, 0.6);
        photoFileName = [NSString stringWithFormat:@"%@_%@.jpg", self.dealer.email, [NSDate date]];
        NSString *filePathAtS3 = [NSString stringWithFormat:@"media/Profile_Photos/%@", photoFileName];
        self.dealer.photoURL = filePathAtS3;
    
    } else {
        
        hasPhoto = NO;
    }
}

- (IBAction)SignUpButton:(id)sender
{
    self.app = [UIApplication sharedApplication];
    
    if (([fullNameTextField.text isEqual:@""]) || ([fullNameTextField.text isEqual:@"Fullname"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"You must enter your name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else if (([emailTextField.text isEqual:@""]) || ([emailTextField.text isEqual:@"Email"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"You must enter an email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else if ([emailTextField.text rangeOfString:@"@"].location == NSNotFound) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else if (([passwordTextField.text isEqual:@""]) || ([passwordTextField.text isEqual:@"Password"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"You must enter a password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        [self StartLoading];
        [self resignFirstResponder];
        [self saveUserDetails];
        [self CleanScreen:@"all"];
        
        [self uploadData];
    }
}

- (void)uploadData
{
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
                                            
                                            NSString *errorMessage = [error localizedDescription];
                                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email already exists" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                            [alert show];
                                            [[AWSS3TransferManager defaultS3TransferManager] cancelAll];
                                            [self StopLoading];
                                        }];
    
    if (profilePic.image) {
        
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
    
    AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:[RKObjectManager sharedManager].baseURL];
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
                 
                 KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"DealersKeychain" accessGroup:nil];
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
    [appDelegate saveUserDetailsOnDevice];
    [appDelegate setTabBarController];
}


/*
 - (void)uploadDataOldVersion
 {
 dispatch_queue_t queue = dispatch_queue_create("com.MyQueueLoading", NULL);
 dispatch_async(queue, ^{
 NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/registercheck.php?var1=%@",emailTextField.text];
 NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
 NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
 
 dispatch_async(dispatch_get_main_queue(), ^{
 
 if ([DataResult isEqualToString:@"exist"]){
 [self StopLoading];
 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Email already exist." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
 [alert show];
 
 } else {
 
 dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
 dispatch_async(queue, ^{
 
 [self BackgroundMethod];
 
 dispatch_async(dispatch_get_main_queue(), ^{
 
 NSLog(@"usrid=%@",appDelegate.dealer.dealerID);
 
 if (([appDelegate.dealer.dealerID isEqualToString:@"0"]) || (appDelegate.dealer.dealerID == nil) || ([appDelegate.dealer.dealerID isEqualToString:@""])) {
 registerAgain = YES;
 [self StopLoading];
 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Register fail, please try again." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
 [alert show];
 
 } else if ([appDelegate.dealer.dealerID rangeOfString:@"fail"].location == NSNotFound) {
 
 if (!isPopping) {
 self.app.networkActivityIndicatorVisible = NO;
 
 KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"DealersKeychain" accessGroup:nil];
 [keychain setObject:emailTextField.text forKey:(__bridge id)(kSecAttrAccount)];
 [keychain setObject:passwordTextField.text forKey:(__bridge id)(kSecValueData)];
 
 [appDelegate setTabBarController];
 }
 
 } else {
 registerAgain = YES;
 [self StopLoading];
 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Register fail, please try again" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
 [alert show];
 }
 });
 });
 }
 });
 });
 }
 */

- (IBAction)AddphotoButton:(id)sender
{
    UIActionSheet *actionSheet;
    if (!profilePic.image) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"Please Choose"
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Camera", @"Library", nil];
        
    } else {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"Please Choose"
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:@"Remove Photo"
                       otherButtonTitles:@"Camera", @"Library", nil];
    }
    [actionSheet showInView:self.view];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    profilePic.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)CleanScreen:(NSString*)string
{
    [UIView animateWithDuration:0.5 animations:^{GenderPicker.center = CGPointMake(160, 2*([[UIScreen mainScreen] bounds].size.height));
        GenderNavBar.center = CGPointMake(160, 2*([[UIScreen mainScreen] bounds].size.height));
        datepick.center = CGPointMake(160, 2*([[UIScreen mainScreen] bounds].size.height));
        NavBar.center = CGPointMake(160, 2*([[UIScreen mainScreen] bounds].size.height));
    }];
    [scroll setScrollEnabled:NO];
    
    if (![string isEqualToString:@"text"]) {
        [fullNameTextField resignFirstResponder];
        [emailTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
    }
}

-(void) ShowDatePicker {
    [self CleanScreen:@"DatePicker"];
    float navHeight = self.view.frame.size.height - NavBar.bounds.size.height/2-datepick.bounds.size.height;
    float pickerHeight = self.view.frame.size.height - datepick.bounds.size.height/2;
    [scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(SignupButton.frame)+10+216+44)))];
    [scroll setScrollEnabled:YES];
    if ([self isIphone5]==0) {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 140);}];
    } else {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 10);}];
    }
    [UIView animateWithDuration:0.5 animations:^{datepick.center = CGPointMake(160, pickerHeight);}];
    [UIView animateWithDuration:0.5 animations:^{NavBar.center = CGPointMake(160, navHeight);}];
}

-(void) HideDatePicker {
    [self CleanScreen:@"DatePicker"];
    self.selectedDate = [datepick date];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.dateOfBirthTextField.text = [self.dateFormatter stringFromDate:self.selectedDate];
    
    [self performSelector:@selector(GenderButton:) withObject:nil];
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    [self CleanScreen:@"text"];
    [scroll setScrollEnabled:YES ];
    [scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(SignupButton.frame)+10+216+44)))];
    float shouldScrollTo = CGRectGetMinY(fullNameTextField.frame) - self.navigationController.navigationBar.frame.size.height - 40;
    if ([self isIphone5]==0) {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, shouldScrollTo);}];
    } else {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 10);}];
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    switch (textField.tag) {
        case 1:
            [emailTextField becomeFirstResponder];
            break;
        case 2:
            [passwordTextField becomeFirstResponder];
            break;
        case 3:
            [textField resignFirstResponder];
            [self ShowDatePicker];
            break;
        default:
            break;
    }
    return NO;
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)GenderButton:(id)sender {
    [self CleanScreen:@"GenderPicker"];
    float navHeight = self.view.frame.size.height - GenderNavBar.bounds.size.height/2-GenderPicker.bounds.size.height;
    float pickerHeight = self.view.frame.size.height - GenderPicker.bounds.size.height/2;
    [scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(SignupButton.frame)+10+216+44)))];
    if ([self isIphone5]==0) {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 140);}];
    } else {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 10);}];
    }
    [UIView animateWithDuration:0.5 animations:^{GenderPicker.center = CGPointMake(160, pickerHeight);}];
    [UIView animateWithDuration:0.5 animations:^{GenderNavBar.center = CGPointMake(160, navHeight);}];
    [scroll setScrollEnabled:YES];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (!profilePic.image)
    {
        if (buttonIndex == 0) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        if (buttonIndex == 1) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
        }
    } else {
        if (buttonIndex == 1) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing=YES;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        if (buttonIndex==2) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing=YES;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
        if (buttonIndex == 0) {
            profilePic.image = nil;
        }
    }
    
}

- (IBAction)GenderDoneButton:(id)sender
{
    [self CleanScreen:@"GenderPicker"];
    [scroll setScrollEnabled:NO];
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = scrollOriginOffset;}];
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([[list objectAtIndex:row] isEqualToString:@"Gender"]) {
        genderTextField.text = nil;
    } else {
        genderTextField.text = [list objectAtIndex:row];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [list count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [list objectAtIndex:row];
}

- (IBAction)tapGesturePressed:(id)sender {
    [fullNameTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [self CleanScreen:@"GenderPicker"];
    [scroll setScrollEnabled:NO];
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = scrollOriginOffset;}];
}



-(int) isIphone5 {
    if ([[UIScreen mainScreen] bounds].size.height == 568) return 1;
    return 0;
}

@end
