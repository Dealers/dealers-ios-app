//
//  OnlineViewController.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 2/12/14.
//
//

#import <UIKit/UIKit.h>

@interface OnlineViewController : UIViewController <UISearchBarDelegate, UINavigationControllerDelegate,UINavigationBarDelegate,UITextFieldDelegate,UIWebViewDelegate>
{
    NSTimer *timer;
    BOOL currentVC;
}
@property (weak, nonatomic) IBOutlet UITextField *UrlBar;
@property (weak, nonatomic) IBOutlet UIButton *webViewGoBack;
@property (weak, nonatomic) IBOutlet UIButton *webViewGoForward;
@property (weak, nonatomic) IBOutlet UIButton *DealitButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

- (IBAction) webViewGoBack:(id)sender;
- (IBAction) webViewGoForward:(id)sender;
- (IBAction) ReturnButton:(id)sender;
- (IBAction) DealitButton:(id)sender;

-(void) deallocOnlineView;

@end
