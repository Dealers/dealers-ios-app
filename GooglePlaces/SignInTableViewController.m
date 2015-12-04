//
//  SignInTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 11/27/14.
//
//

#import "SignInTableViewController.h"

@implementation SignInTableViewController

@synthesize appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Sign In", nil);
    
    [self initialize];
    [self setLoadingAnimation];
    [self setProgressIndicator];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.emailTextField becomeFirstResponder];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Sign In Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)initialize
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [self setRoundCornersToButton];
}

- (void)setLoadingAnimation
{
    [self.view layoutIfNeeded];
    loadingAnimation = [appDelegate loadingAnimationWhite];
    [self.signInBackground addSubview:loadingAnimation];
    CGPoint loadingAnimationCenter = CGPointMake(self.signInBackground.bounds.size.width / 2, self.signInBackground.bounds.size.height / 2);
    loadingAnimation.center = loadingAnimationCenter;
    loadingAnimation.transform = CGAffineTransformMakeScale(0.001, 0.001);
}

- (void)setRoundCornersToButton
{
    self.signInButton.layer.cornerRadius = 8.0;
    self.signInButton.layer.masksToBounds = YES;
    self.signInBackground.layer.cornerRadius = 8.0;
    self.signInBackground.layer.masksToBounds = YES;
}

- (void)startLoading
{
    [loadingAnimation startAnimating];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.15
                     animations:^{
                         self.signInButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.15
                                          animations:^{
                                              loadingAnimation.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }];
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
                         [UIView animateWithDuration:0.15
                                          animations:^{
                                              self.signInButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }];
                     }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        [self.emailTextField becomeFirstResponder];
        
    } else {
        
        [self.passwordTextField becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
        
        return NO;
        
    } else {
        
        [self performSelector:@selector(signIn:) withObject:nil];
        [self.passwordTextField resignFirstResponder];
        
        return YES;
    }
}

- (void)setProgressIndicator
{
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
    
    wrongEmailPassword = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    wrongEmailPassword.delegate = self;
    wrongEmailPassword.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    wrongEmailPassword.mode = MBProgressHUDModeCustomView;
    wrongEmailPassword.labelText = NSLocalizedString(@"Wrong email or password", nil);
    wrongEmailPassword.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    wrongEmailPassword.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:blankEmail];
    [self.navigationController.view addSubview:blankPassword];
    [self.view addSubview:noConnection];
    [self.view addSubview:wrongEmailPassword];
}

- (BOOL)validation
{
    if (self.emailTextField.text.length == 0) {
        
        [blankEmail show:YES];
        [blankEmail hide:YES afterDelay:1.5];
        
        return NO;
        
    } else if (self.passwordTextField.text.length == 0) {
        
        [blankPassword show:YES];
        [blankPassword hide:YES afterDelay:1.5];
        
        return NO;
    }
    return YES;
}

- (IBAction)signIn:(id)sender {
    
    if (![self validation]) {
        
        return;
    }
    
    [self startLoading];
    
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:self.emailTextField.text
                                                                          password:self.passwordTextField.text];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/dealerlogins/"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  self.appDelegate.dealer = mappingResult.firstObject;
                                                  
                                                  if (appDelegate.dealer.photoURL.length > 2 && ![appDelegate.dealer.photoURL isEqualToString:@"None"]) {
                                                      hasPhoto = YES;
                                                      [self downloadUesrPhoto];
                                                  }
                                                  
                                                  [self getToken];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  Error *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                                                  NSLog(@"%@", [errors messagesString]);
                                                  
                                                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Couldn't sign in...", nil)
                                                                                                 message:[NSString stringWithFormat:@"\n%@", [errors messagesString]]
                                                                                                delegate:nil
                                                                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                       otherButtonTitles:nil];
                                                  [alert show];
                                                  
                                                  [self stopLoading];
                                              }];
}

- (void)downloadUesrPhoto
{
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"downloaded_image_%@.jpg", appDelegate.dealer.dealerID]];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    downloadRequest.bucket = @"dealers-app";
    downloadRequest.key = appDelegate.dealer.photoURL;
    downloadRequest.downloadingFileURL = downloadingFileURL;
    
    [[[AWSS3TransferManager defaultS3TransferManager] download:downloadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
                                                                                           withBlock:^id(AWSTask *task) {
                                                                                               
                                                                                               if (task.error){
                                                                                                   if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                                                                       switch (task.error.code) {
                                                                                                           case AWSS3TransferManagerErrorCancelled:
                                                                                                           case AWSS3TransferManagerErrorPaused:
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
                                                                                                   
                                                                                                   didPhotoFinishedDownloading = YES;
                                                                                                   appDelegate.dealer.photo = [NSData dataWithContentsOfFile:downloadingFilePath];
                                                                                                   [self enterDealers];
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
                 
                 didDownloadUserData = YES;
                 
                 if (!hasPhoto) {
                     [self enterDealers];
                 } else if (didPhotoFinishedDownloading) {
                     [self enterDealers];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 NSLog(@"\n\nFailed to fetch token. Error: %@", error.localizedDescription);
             }];
}

- (void)enterDealers
{
    [appDelegate intercomSuccessfulLogin];
    [appDelegate setTabBarController];
    [appDelegate saveUserDetailsOnDevice];
}


@end
