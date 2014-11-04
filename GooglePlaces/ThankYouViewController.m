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

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.wasWhatsAppSelected) {
        
        [self whatsAppShare];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device should have WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
