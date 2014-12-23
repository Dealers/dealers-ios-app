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

@interface ThankYouViewController : UIViewController <UIDocumentInteractionControllerDelegate>

@property AppDelegate *appDelegate;

@property BOOL wasFacebookSelected;
@property BOOL wasWhatsAppSelected;
@property BOOL shouldDismiss;

@property UIImage *sharedImage;

@property (retain) UIDocumentInteractionController * documentInteractionController;

@property (weak, nonatomic) IBOutlet UILabel *thankYou;
@property (weak, nonatomic) IBOutlet UIButton *okButton;


- (IBAction)okay:(id)sender;

@end
