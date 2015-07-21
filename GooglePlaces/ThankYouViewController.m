//
//  ThankYouViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/7/14.
//
//

#import "ThankYouViewController.h"

#define S3_PHOTOS_ADDRESS @"https://s3-eu-west-1.amazonaws.com/dealers-app/"

@interface ThankYouViewController () {
    
    FBLinkShareParams *fbParams;
}

@end

@implementation ThankYouViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self translateLabels];
    [self setOkButton];
    [self setElementsForAnimation];
    
    [self performSelector:@selector(fadeInAnimationFirst) withObject:nil afterDelay:0.3];
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    fbParams = [[FBLinkShareParams alloc] init];
    self.screenName = @"Add Deal - Thank You Screen";
}

- (void)translateLabels
{
    self.thankYou.text = NSLocalizedString(@"Thank You!", nil);
    [self.facebookLabel setTitle:NSLocalizedString(@"Share with Facebook", nil) forState:UIControlStateNormal];
    [self.whatsAppLabel setTitle:NSLocalizedString(@"Share with WhatsApp", nil) forState:UIControlStateNormal];
}

- (void)setOkButton
{
    self.okButton.layer.cornerRadius = self.okButton.frame.size.width / 2;
    self.okButton.layer.masksToBounds = YES;
    self.okButton.layer.borderColor = [[UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:0.9] CGColor];
    self.okButton.layer.borderWidth = 2.0;
}

- (void)setElementsForAnimation
{
    self.checkMark.alpha = 0;
    self.thankYou.alpha = 0;
    self.shareContainer.alpha = 0;
    self.okButton.alpha = 0;
    self.verticalSpaceCheckMarkConstraint.constant = -10.0;
}

- (void)fadeInAnimationFirst
{
    [self.view layoutIfNeeded];
    self.verticalSpaceCheckMarkConstraint.constant = 0;
    [UIView animateWithDuration:0.75
                     animations:^{
                         self.checkMark.alpha = 1.0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         [self performSelector:@selector(fadeInAnimationSecond) withObject:nil afterDelay:0.15];
                     }];
}

- (void)fadeInAnimationSecond
{
    [UIView animateWithDuration:0.5 animations:^{
        self.thankYou.alpha = 1.0;
        self.shareContainer.alpha = 1.0;
        self.okButton.alpha = 1.0;
    }];
}

- (IBAction)shareViaFacebook:(id)sender
{
    [self generateLinkForChannel:@"facebook"];
}

- (IBAction)shareViaWhatsApp:(id)sender
{
    [self generateLinkForChannel:@"whats_app"];
}

- (void)generateLinkForChannel:(NSString *)channel
{
    NSString *url = [self getImageURL];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                    @"deal" : self.deal.dealID.stringValue,
                                                                                    @"$og_title" : self.deal.title,
                                                                                    @"$og_image_url" : url,
                                                                                    @"$og_description" : NSLocalizedString(@"Check out this deal at Dealers", nil)
                                                                                    }];
    Branch *branch = [Branch getInstance];
    [branch getShortURLWithParams:params andTags:@[[appDelegate currentVersion]] andChannel:channel andFeature:@"add_deal" andStage:nil andAlias:nil andCallback:^(NSString *url, NSError *error) {
        if ([channel isEqualToString:@"facebook"]) {
            [self facebookShareDialogWithLink:url];
        } else if ([channel isEqualToString:@"whats_app"]) {
            [self whatsAppShareWithLink:url];   
        }
    }];
}

- (NSString *)getImageURL
{
    if (self.deal.photoURL1.length > 2 && ![self.deal.photoURL1 isEqualToString:@"None"]) {
        return [S3_PHOTOS_ADDRESS stringByAppendingString:self.deal.photoURL1];
    } else {
        int color = self.deal.photoURL1.intValue;
        switch (color) {
            case 0:
                return [S3_PHOTOS_ADDRESS stringByAppendingString:@"media/Brand_Photos/logo_colorful_blue.png"];
                break;
            case 1:
                return [S3_PHOTOS_ADDRESS stringByAppendingString:@"media/Brand_Photos/logo_colorful_green.png"];
                break;
            case 2:
                return [S3_PHOTOS_ADDRESS stringByAppendingString:@"media/Brand_Photos/logo_colorful_red.png"];
                break;
            case 3:
                return [S3_PHOTOS_ADDRESS stringByAppendingString:@"media/Brand_Photos/logo_colorful_yellow.png"];
                break;
                
            default:
                return nil;
                break;
        }
    }
}

- (void)facebookShareDialogWithLink:(NSString *)url
{
    fbParams.link = [NSURL URLWithString:url];
    [FBDialogs presentShareDialogWithParams:fbParams
                                clientState:nil
                                    handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                        if (error) {
                                            // An error occurred, we need to handle the error
                                            // See: https://developers.facebook.com/docs/ios/errors
                                            NSLog(@"Error messaging link: %@", error.description);
                                        } else {
                                            // Success
                                            NSLog(@"result %@", results);
                                            [appDelegate logButtonPress:@"Share Add Deal Facebook"];
                                        }
                                    }];
}

- (void)whatsAppShareWithLink:(NSString *)url
{
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"Found this deal at Dealers. Check it out: %@\n%@", nil), self.deal.title, url];
    NSString *urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@", text];
    NSURL *whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([[UIApplication sharedApplication] canOpenURL:whatsappURL]) {
        [[UIApplication sharedApplication] openURL:whatsappURL];
        [appDelegate logButtonPress:@"Share Add Deal WhatsApp"];
        
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
    [appDelegate exitAddDealState];
}


/*
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
 */


@end
