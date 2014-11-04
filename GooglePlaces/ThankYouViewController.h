//
//  ThankYouViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 10/7/14.
//
//

#import <UIKit/UIKit.h>

@interface ThankYouViewController : UIViewController <UIDocumentInteractionControllerDelegate>

@property BOOL wasFacebookSelected;
@property BOOL wasWhatsAppSelected;

@property UIImage *sharedImage;

@property (retain) UIDocumentInteractionController * documentInteractionController;

@end
