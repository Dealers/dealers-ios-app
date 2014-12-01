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
    
    self.title = @"Sign In";
    
    [self initialize];
    [self configureRestKit];
    [self setProgressIndicator];
}

- (void)initialize
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    loadingAnimation = [appDelegate loadingAnimationWhite];
    loadingAnimation.center = self.signInButton.center;
    [self.bottomView addSubview:loadingAnimation];
    loadingAnimation.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [self setRoundCornersToButton];
}

- (void)setRoundCornersToButton
{
    self.signInButton.layer.cornerRadius = 8.0;
    self.signInButton.layer.masksToBounds = YES;
    self.signInBackground.layer.cornerRadius = 8.0;
    self.signInBackground.layer.masksToBounds = YES;
}

- (void)downloadUesrPhoto
{
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"downloaded_image_%@.jpg", appDelegate.dealer.dealerID]];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    downloadRequest.bucket = @"dealers-app";
    downloadRequest.key = appDelegate.dealer.photoURL;
    downloadRequest.downloadingFileURL = downloadingFileURL;
    
    [[[AWSS3TransferManager defaultS3TransferManager] download:downloadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        
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
            
            self.appDelegate.dealer.photo = [NSData dataWithContentsOfFile:downloadingFilePath];
            [[NSUserDefaults standardUserDefaults] setObject:[NSData dataWithContentsOfFile:downloadingFilePath] forKey:@"photo"];
        }
        return nil;
    }];
}

- (void)startLoading
{
    [loadingAnimation startAnimating];

    [UIView animateWithDuration:0.2 animations:^{
        
        self.signInButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.signInButton.alpha = 0.5;
        loadingAnimation.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)stopLoading
{
    [loadingAnimation stopAnimating];
    
    [UIView animateWithDuration:0.2 animations:^{
        loadingAnimation.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.signInButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.signInButton.alpha = 1.0;
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
    blankEmail.labelText = @"Email is blank!";
    blankEmail.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    blankEmail.animationType = MBProgressHUDAnimationZoomIn;
    
    blankPassword = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    blankPassword.delegate = self;
    blankPassword.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    blankPassword.mode = MBProgressHUDModeCustomView;
    blankPassword.labelText = @"Password is blank!";
    blankPassword.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    blankPassword.animationType = MBProgressHUDAnimationZoomIn;
    
    noConnection = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    noConnection.delegate = self;
    noConnection.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    noConnection.mode = MBProgressHUDModeCustomView;
    noConnection.labelText = @"Can't connect the server";
    noConnection.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    noConnection.detailsLabelText = @"Check your connection";
    noConnection.detailsLabelFont = [UIFont fontWithName:@"Avenir-Light" size:15.0];
    noConnection.animationType = MBProgressHUDAnimationZoomIn;
    
    wrongEmailPassword = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    wrongEmailPassword.delegate = self;
    wrongEmailPassword.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    wrongEmailPassword.mode = MBProgressHUDModeCustomView;
    wrongEmailPassword.labelText = @"Wrong email or password";
    wrongEmailPassword.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    wrongEmailPassword.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:blankEmail];
    [self.navigationController.view addSubview:blankPassword];
    [self.view addSubview:noConnection];
    [self.view addSubview:wrongEmailPassword];
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://54.77.168.152"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    self.signInManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    self.signInManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    // other modifications to the object manager
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    // register mappings with the provider using response descriptors
    RKResponseDescriptor *dealsResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[appDelegate dealerMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/dealerlogins/"
                                                keyPath:@"results"
                                            statusCodes:statusCodes];
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addPropertyMapping: [RKAttributeMapping attributeMappingFromKeyPath:@"detail" toKeyPath:@"errorMessage"]];
    
    RKResponseDescriptor *errorResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    [self.signInManager addResponseDescriptorsFromArray:@[dealsResponseDescriptor, errorResponseDescriptor]];
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

- (void)saveUsernameAndPassword
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"DealersKeychain" accessGroup:nil];
    
    [keychain setObject:self.emailTextField.text forKey:(__bridge id)(kSecAttrAccount)];
    [keychain setObject:self.passwordTextField.text forKey:(__bridge id)(kSecValueData)];
}

- (IBAction)signIn:(id)sender {
    
    if (![self validation]) {
        
        return;
    }
    
    [self startLoading];
    
    [self.signInManager.HTTPClient setAuthorizationHeaderWithUsername:self.emailTextField.text
                                                             password:self.passwordTextField.text];
    
    [self.signInManager getObjectsAtPath:@"/dealerlogins/"
                              parameters:nil
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
                                     self.appDelegate.dealer = mappingResult.firstObject;
                                     
                                     [self saveUsernameAndPassword];
                                     [appDelegate saveUserDetailsOnDevice];
                                     
                                     if (appDelegate.dealer.photoURL.length > 1) {
                                         
                                         [self downloadUesrPhoto];
                                     }
                                     
                                     [appDelegate setTabBarController];
                                     
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     
                                     if (error.code == -1004) {
                                         
                                         // No connection to the server error
                                         [noConnection show:YES];
                                         [noConnection hide:YES afterDelay:2.0];
                                     
                                     } else if ([error.localizedDescription isEqualToString:@"Invalid username/password"]) {
                                         
                                         // Wrong email or password error
                                         [wrongEmailPassword show:YES];
                                         [wrongEmailPassword hide:YES afterDelay:1.5];
                                     
                                     } else {
                                         
                                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Couldn't sign in" message:@"Sorry for that, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                         [alert show];
                                     }
                                     
                                     [self stopLoading];
                                 }];
}


@end
