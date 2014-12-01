//
//  ThankYouViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 10/7/14.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ThankYouViewController : UIViewController <UIDocumentInteractionControllerDelegate>

@property BOOL wasFacebookSelected;
@property BOOL wasWhatsAppSelected;

@property UIImage *sharedImage;

@property (retain) UIDocumentInteractionController * documentInteractionController;


- (IBAction)okay:(id)sender;

@end
