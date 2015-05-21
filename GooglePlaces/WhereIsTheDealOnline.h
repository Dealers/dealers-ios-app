//
//  WhereIsTheDealOnline.h
//  Dealers
//
//  Created by Gilad Lumbroso on 5/11/15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WhatIsTheDeal1Online.h"
#import "MBProgressHUD.h"
#import "PaddedTextField.h"

@interface WhereIsTheDealOnline : UIViewController <UIWebViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate>

@property AppDelegate *appDelegate;

@property Store *website;

@property NSString *cameFrom;
@property NSString *urlToLoad;

@property (weak, nonatomic) IBOutlet UIView *explanationView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;

@property (weak, nonatomic) IBOutlet UILabel *explanationLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property NSMutableArray *images;

@property WhatIsTheDeal1Online *cashedInstance;

- (void)loadRequestFromString:(NSString*)urlString;

@end
