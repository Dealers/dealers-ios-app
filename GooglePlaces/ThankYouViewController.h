//
//  ThankYouViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 10/7/14.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "Branch.h"
#import "GAITrackedViewController.h"

@interface ThankYouViewController : GAITrackedViewController <UIDocumentInteractionControllerDelegate>

@property AppDelegate *appDelegate;

@property Deal *deal;
@property UIImage *sharedImage;

@property (retain) UIDocumentInteractionController * documentInteractionController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceCheckMarkConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark;
@property (weak, nonatomic) IBOutlet UILabel *thankYou;
@property (weak, nonatomic) IBOutlet UIView *shareContainer;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (weak, nonatomic) IBOutlet UIButton *facebookLabel;
@property (weak, nonatomic) IBOutlet UIButton *whatsAppLabel;

- (IBAction)shareViaFacebook:(id)sender;
- (IBAction)shareViaWhatsApp:(id)sender;
- (IBAction)okay:(id)sender;

@end
