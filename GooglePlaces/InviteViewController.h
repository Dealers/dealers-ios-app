//
//  InviteViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 1/11/15.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "Invitation.h"
#import "MBProgressHUD.h"
#import "KeychainItemWrapper.h"
#import "GAITrackedViewController.h"

@interface InviteViewController : GAITrackedViewController <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, MBProgressHUDDelegate> {
    
    NSString *invitationMessage, *passcode;
    NSInteger timesTried, secretButtonCounter, timesTriedServerUpdate;
    MBProgressHUD *invitationSent;
}

@property AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UILabel *explanationLabel;

@property BOOL popUp;

@property (weak, nonatomic) IBOutlet UIView *invitationContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *invitationIcon1;
@property (weak, nonatomic) IBOutlet UIImageView *invitationIcon2;
@property (weak, nonatomic) IBOutlet UIImageView *invitationIcon3;
@property (weak, nonatomic) IBOutlet UIImageView *invitationIcon4;
@property (weak, nonatomic) IBOutlet UIImageView *invitationIcon5;

@property (weak, nonatomic) IBOutlet UIButton *textMessage;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *whatsAppButton;

@property (weak, nonatomic) IBOutlet UILabel *noInvitationsLeft;

@property UIButton *addInvitationSecretButton;
@property (weak, nonatomic) IBOutlet UIButton *notNow;


- (IBAction)inviteWithTextMessage:(id)sender;
- (IBAction)inviteWithEmail:(id)sender;
- (IBAction)inviteWithWhatsApp:(id)sender;
- (IBAction)dismiss:(id)sender;


@end
