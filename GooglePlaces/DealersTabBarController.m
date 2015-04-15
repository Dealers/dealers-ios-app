//
//  DealersTabBarController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/30/14.
//
//

#import "DealersTabBarController.h"

@interface DealersTabBarController () {
    
    MBProgressHUD *progressIndicator;
}

@property BOOL feedbackViewPresenting;

@end

@implementation DealersTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.feedbackViewPresenting = NO;
    [self setProgressIndicator];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake )
    {
        // User was shaking the device. Post a notification named "shake".
        if (!self.feedbackViewPresenting) {
            [self sendFeedback];
        }
    }
}

- (void)sendFeedback
{
    NSString *emailTitle = @"Feedback!";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"ideas@dealers-app.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    mc.view.tintColor = [UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:1.0];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
    self.feedbackViewPresenting = YES;
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        case MFMailComposeResultSent:   {
            [progressIndicator show:YES];
            [progressIndicator hide:YES afterDelay:2.5];
            
            break;
        }
        case MFMailComposeResultFailed: {
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email Error" message:@"Unable to send email. please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.feedbackViewPresenting = NO;
}

- (void)setProgressIndicator
{
    progressIndicator = [[MBProgressHUD alloc]initWithView:self.view];
    progressIndicator.delegate = self;
    progressIndicator.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Complete"]];
    progressIndicator.mode = MBProgressHUDModeCustomView;
    progressIndicator.labelText = NSLocalizedString(@"Email Sent", nil);
    progressIndicator.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    progressIndicator.detailsLabelText = NSLocalizedString(@"Thanks!", nil);
    progressIndicator.detailsLabelFont = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    progressIndicator.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.view addSubview:progressIndicator];
}


@end
