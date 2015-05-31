//
//  InviteViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 1/11/15.
//
//

#import "InviteViewController.h"

#define PASSCODE_LENGTH 4
#define APPSTORE_LINK @"https://appsto.re/il/12CB5.i"

@interface InviteViewController ()

@end

@implementation InviteViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Invite", nil);
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [self setInvitationMessageAndPasscode];
    [self setButtons];
    [self setProgressIndicator];
    [self setAddInvitationSecretButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self setInvitationIcons];
    [self setScreenName:@"Invite Screen"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"Navigation Bar Shade"];
}

- (void)setInvitationMessageAndPasscode
{
    passcode = [self generateCode];
    invitationMessage = [NSString stringWithFormat:NSLocalizedString(@"I'm sending you a passcode for Dealers, an app for sharing deals:\n%@\n\nDownload Dealers here:\n%@", nil), passcode, APPSTORE_LINK];
}

- (void)setInvitationIcons
{
    for (NSInteger i = 5; i > 0; i--) {
        
        if (i == appDelegate.dealer.invitationCounter.integerValue) {
            return;
        } else {
            UIImageView *notificationIcon = [self invitationIconForIndex:i];
            notificationIcon.image = [UIImage imageNamed:@"Empty Invitation Icon"];
        }
    }
    
    [self setNoInvitationsLeft];
}

- (void)setButtons
{
    self.noInvitationsLeft.text = NSLocalizedString(self.noInvitationsLeft.text, nil);
    
    // Text Message Button
    
    NSDictionary* attributesFirstPart = @{ NSFontAttributeName: [UIFont fontWithName:@"Avenir-Roman" size:17.0] };
    NSDictionary* attributesSecondPart = @{ NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:17.0] };

    NSString *inviteBy = NSLocalizedString(@"Invite by ", nil);
    NSString *textMessage = NSLocalizedString(@"Message", nil);
    
    NSAttributedString *attrInviteBy = [[NSAttributedString alloc] initWithString:inviteBy attributes:attributesFirstPart];
    NSAttributedString *attrTextMessage = [[NSAttributedString alloc] initWithString:textMessage attributes:attributesSecondPart];
    
    NSMutableAttributedString *textMessageButtonString = [[NSMutableAttributedString alloc] initWithAttributedString:attrInviteBy];
    [textMessageButtonString appendAttributedString:attrTextMessage];
    
    [self.textMessage setAttributedTitle:textMessageButtonString forState:UIControlStateNormal];
    [self.textMessage.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.textMessage.layer setCornerRadius:8.0];
    [self.textMessage.layer setMasksToBounds:YES];
    
    // Email Button
    
    NSString *email = NSLocalizedString(@"Email", nil);
    
    NSAttributedString *attrEmail = [[NSAttributedString alloc] initWithString:email attributes:attributesSecondPart];
    
    NSMutableAttributedString *emailButtonString = [[NSMutableAttributedString alloc] initWithAttributedString:attrInviteBy];
    [emailButtonString appendAttributedString:attrEmail];
    
    [self.emailButton setAttributedTitle:emailButtonString forState:UIControlStateNormal];
    [self.emailButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.emailButton.layer setCornerRadius:8.0];
    [self.emailButton.layer setMasksToBounds:YES];
    
    // WhatsApp Button
    
    NSString *whatsApp = NSLocalizedString(@"WhatsApp", nil);
    
    NSAttributedString *attrWhatsApp = [[NSAttributedString alloc] initWithString:whatsApp attributes:attributesSecondPart];
    
    NSMutableAttributedString *whatsAppButtonString = [[NSMutableAttributedString alloc] initWithAttributedString:attrInviteBy];
    [whatsAppButtonString appendAttributedString:attrWhatsApp];
    
    [self.whatsAppButton setAttributedTitle:whatsAppButtonString forState:UIControlStateNormal];
    [self.whatsAppButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.whatsAppButton.layer setCornerRadius:8.0];
    [self.whatsAppButton.layer setMasksToBounds:YES];
}

- (void)setNoInvitationsLeft
{
    self.textMessage.hidden = YES;
    self.emailButton.hidden = YES;
    self.whatsAppButton.hidden = YES;
    self.noInvitationsLeft.hidden = NO;
}

- (IBAction)inviteWithTextMessage:(id)sender {
    
    if (![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                               message:NSLocalizedString(@"Your device doesn't support Text Messages!", nil)
                                                              delegate:nil
                                                     cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                     otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    MFMessageComposeViewController *mc = [[MFMessageComposeViewController alloc] init];
    mc.messageComposeDelegate = self;
    [mc setBody:invitationMessage];
    mc.view.tintColor = [appDelegate ourPurple];
    
    // Present message view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
    [appDelegate logButtonPress:@"Invite by text message"];
}

- (IBAction)inviteWithEmail:(id)sender {
    
    NSString *emailTitle = NSLocalizedString(@"Dealers Invitation", nil);
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:invitationMessage isHTML:NO];
    mc.view.tintColor = [appDelegate ourPurple];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
    [appDelegate logButtonPress:@"Invite by email"];
}

- (IBAction)inviteWithWhatsApp:(id)sender {
    
    NSString *urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@", invitationMessage];
    NSURL *whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([[UIApplication sharedApplication] canOpenURL:whatsappURL]) {
        
        [[UIApplication sharedApplication] openURL:whatsappURL];
        [self performSelector:@selector(postInvitation) withObject:nil afterDelay:0.5];
        [appDelegate logButtonPress:@"Invite by WhatsApp"];
        
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WhatsApp not installed.", nil)
                                                         message:NSLocalizedString(@"Your device should have WhatsApp installed.", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
        [alert show];
    }
}

- (NSString *)generateCode {
    
    NSString *allKeys = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: PASSCODE_LENGTH];
    
    for (int i = 0; i < PASSCODE_LENGTH; i++) {
        
        [randomString appendFormat: @"%C", [allKeys characterAtIndex: arc4random_uniform([NSNumber numberWithUnsignedInteger:[allKeys length]].unsignedIntValue)]];
    }
    
    return randomString;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"SMS cancelled");
            break;
            
        case MessageComposeResultFailed:
        {
            NSLog(@"SMS sent failure.");
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SMS Error", nil)
                                                                   message:NSLocalizedString(@"Unable to send SMS. please try again", nil)
                                                                  delegate:nil
                                                         cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                         otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            [invitationSent show:YES];
            [invitationSent hide:YES afterDelay:2];
            
            [self postInvitation];
            
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
            
            [self postInvitation];
            break;
            
        case MFMailComposeResultSent:   {
            [invitationSent show:YES];
            [invitationSent hide:YES afterDelay:2];
            
            [self postInvitation];
            
            break;
        }
        case MFMailComposeResultFailed: {
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email Error", nil)
                                                            message:NSLocalizedString(@"Unable to send email. please try again", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)postInvitation
{
    Invitation *invitation = [[Invitation alloc] init];
    invitation.passcode = passcode;
    invitation.dealerID = appDelegate.dealer.dealerID;
    
    [[RKObjectManager sharedManager] postObject:invitation
                                           path:@"/invitations/"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mapping) {
                                            
                                            NSLog(@"Invitation posted successfuly!");
                                            [self performSelector:@selector(usedInvitation) withObject:nil afterDelay:0.5];
                                            
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            
                                            NSLog(@"Failed to post invitation");
                                            
                                            // Try again
                                            if (timesTried < 3) {
                                                timesTried++;
                                                [self postInvitation];
                                            
                                            } else {
                                                UIAlertView *error = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invitation Error", nil)
                                                                                                message:NSLocalizedString(@"Unable to send invitation properly. please try again. (The recipient will not be able to use the passcode)", nil)
                                                                                               delegate:self
                                                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                      otherButtonTitles:nil];
                                                [error show];
                                            }
                                        }];
}

- (void)usedInvitation
{
    UIImageView *invitationIcon;

    invitationIcon = [self invitationIconForIndex:appDelegate.dealer.invitationCounter.integerValue];
    
    UIImageView *usedInvitationIcon = [[UIImageView alloc] initWithFrame:invitationIcon.frame];
    usedInvitationIcon.image = [UIImage imageNamed:@"Empty Invitation Icon"];
    [self.invitationContainerView insertSubview:usedInvitationIcon belowSubview:invitationIcon];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         invitationIcon.transform = CGAffineTransformMakeScale(0.001, 0.001);
                     }
                     completion:^(BOOL finished) {
                         invitationIcon.image = [UIImage imageNamed:@"Empty Invitation Icon"];
                         invitationIcon.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         [usedInvitationIcon removeFromSuperview];
                     }];
    
    appDelegate.dealer.invitationCounter = @(appDelegate.dealer.invitationCounter.integerValue - 1);
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.dealer.invitationCounter forKey:@"invitationCounter"];
    [self setInvitationMessageAndPasscode];
    
    [self updateInvitationCounterAtTheServer];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"invitationCounter"]);
    
    if (appDelegate.dealer.invitationCounter.integerValue == 0) {
        [self replaceButtonsWithNoInvitationsLabel];
    }
}

- (void)replaceButtonsWithNoInvitationsLabel
{
    self.noInvitationsLeft.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.textMessage.alpha = 0;
        self.emailButton.alpha = 0;
        self.whatsAppButton.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.noInvitationsLeft.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{ self.noInvitationsLeft.alpha = 1.0; }];
    }];
}

- (UIImageView *)invitationIconForIndex:(NSInteger)counter
{
    switch (counter) {
        case 1:
            return self.invitationIcon1;
            break;
        case 2:
            return self.invitationIcon2;
            break;
        case 3:
            return self.invitationIcon3;
            break;
        case 4:
            return self.invitationIcon4;
            break;
        case 5:
            return self.invitationIcon5;
            break;
        default:
            return nil;
            break;
    }
}

- (void)setProgressIndicator
{
    invitationSent = [[MBProgressHUD alloc]initWithView:self.tabBarController.view];
    invitationSent.delegate = self;
    invitationSent.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Complete"]];
    invitationSent.mode = MBProgressHUDModeCustomView;
    invitationSent.labelText = NSLocalizedString(@"Invitation Sent", nil);
    invitationSent.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    invitationSent.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.view addSubview:invitationSent];
}

- (void)setAddInvitationSecretButton
{
    self.addInvitationSecretButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addInvitationSecretButton setFrame:CGRectMake(self.view.frame.size.width - 60, 64, 60, 60)];
    [self.addInvitationSecretButton addTarget:self action:@selector(addInvitation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.addInvitationSecretButton];
}

- (void)addInvitation
{
    secretButtonCounter++;
    NSLog(@"%@", appDelegate.dealer.invitationCounter);
    
    if (secretButtonCounter >= 4 && appDelegate.dealer.invitationCounter.integerValue < 5) {
        
        appDelegate.dealer.invitationCounter = @(appDelegate.dealer.invitationCounter.integerValue + 1);
        [[NSUserDefaults standardUserDefaults] setObject:appDelegate.dealer.invitationCounter forKey:@"invitationCounter"];
        [self updateInvitationCounterAtTheServer];
        
        UIImageView *invitationIcon = [self invitationIconForIndex:appDelegate.dealer.invitationCounter.integerValue];
        
        UIImageView *newInvitationIcon = [[UIImageView alloc] initWithFrame:invitationIcon.frame];
        newInvitationIcon.image = [UIImage imageNamed:@"Invitation Icon"];
        newInvitationIcon.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
        [self.invitationContainerView addSubview:newInvitationIcon];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             newInvitationIcon.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         }
                         completion:^(BOOL finished) {
                             invitationIcon.image = [UIImage imageNamed:@"Invitation Icon"];
                             [newInvitationIcon removeFromSuperview];
                             
                             if (!self.noInvitationsLeft.hidden) {
                                 [UIView animateWithDuration:0.3 animations:^{
                                     
                                     self.noInvitationsLeft.alpha = 0;
                                     
                                 } completion:^(BOOL finished) {
                                     self.noInvitationsLeft.hidden = YES;
                                     
                                     [UIView animateWithDuration:0.3 animations:^{
                                         self.textMessage.alpha = 1.0;
                                         self.emailButton.alpha = 1.0;
                                         self.whatsAppButton.alpha = 1.0;
                                     }];
                                 }];
                             }
                         }];
        
        secretButtonCounter = 0;
    }
}

- (void)updateInvitationCounterAtTheServer
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"DealersKeychain" accessGroup:nil];
    [keychain setObject:@"DealersKeychain" forKey:(__bridge id)kSecAttrService];
    NSString *token = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *path = [NSString stringWithFormat:@"/dealers/%@/", appDelegate.dealer.dealerID];
    NSDictionary *parameters = @{@"invitation_counter": appDelegate.dealer.invitationCounter};
        
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[RKObjectManager sharedManager].baseURL];
    [client setAuthorizationHeaderWithToken:token];
    [client patchPath:path
           parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id result) {
                 
                 NSLog(@"Invitation counter updated at the server!");
                  timesTriedServerUpdate = 0;
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 NSLog(@"Failed to update the invitation counter. Error: %@", error.localizedDescription);
                 
                 if (timesTriedServerUpdate < 2) {
                     timesTriedServerUpdate++;
                     [self updateInvitationCounterAtTheServer];
                     
                 } else {
                     timesTriedServerUpdate = 0;
                 }
             }];
}


@end
