//
//  ThankYouViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/7/14.
//
//

#import "ThankYouViewController.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setThankYouMessage];
    [self setOkButton];
    self.screenName = @"Add Deal - Thank You Screen";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    self.shouldDismiss = YES;
    
    if (self.wasFacebookSelected) {
        
        [self facebookShare];
        self.shouldDismiss = NO;
        [appDelegate logButtonPress:@"Shared the deal with Facebook"];
    }
    
    if (self.wasWhatsAppSelected) {
        
        [self whatsAppShare];
        self.shouldDismiss = NO;
        [appDelegate logButtonPress:@"Shared the deal with WhatsApp"];
    }
    
    if (self.shouldDismiss) {
        [self performSelector:@selector(okay:) withObject:nil afterDelay:3.0];
    }
}

- (void)appWillResignActive:(NSNotification *)notification
{
    [self performSelector:@selector(okay:) withObject:nil afterDelay:1.0];
}

- (void)setThankYouMessage
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.thankYou.text = [NSString stringWithFormat:NSLocalizedString(@"Thank You\n%@!", nil), appDelegate.dealer.fullName];
}

- (void)setOkButton
{
    self.okButton.layer.cornerRadius = self.okButton.frame.size.width / 2;
    self.okButton.layer.masksToBounds = YES;
    self.okButton.layer.borderColor = [[UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:0.9] CGColor];
    self.okButton.layer.borderWidth = 2.0;
}

- (void)facebookShare
{
    FBRequest *request = [FBRequest requestForUploadPhoto:self.sharedImage];
    FBRequestConnection *requestConnection = [[FBRequestConnection alloc]init];
    
    [requestConnection addRequest:request
                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    
                    if (!error) {
                        
                        NSLog(@"Image uploaded to facebook successfuly!");
                        
                    } else {
                        
                        NSLog(@"Image didn't uploaded... Check out what's wrong");
                    }
                }];
    [requestConnection start];
}

- (void)whatsAppShare
{
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]){
        
        UIImage     * iconImage = self.sharedImage;
        NSString    * savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.wai"];
        
        [UIImageJPEGRepresentation(iconImage, 1.0) writeToFile:savePath atomically:YES];
        
        _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
        _documentInteractionController.UTI = @"net.whatsapp.image";
        _documentInteractionController.delegate = self;
        
        [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
        
        
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WhatsApp not installed.", nil)
                                                         message:NSLocalizedString(@"Your device should have WhatsApp installed.", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)okay:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
