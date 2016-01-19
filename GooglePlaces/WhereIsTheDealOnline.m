//
//  WhereIsTheDealOnline.m
//  Dealers
//
//  Created by Gilad Lumbroso on 5/11/15.
//
//

#import "WhereIsTheDealOnline.h"
#import "EditDealTableViewController.h"

@interface WhereIsTheDealOnline () {
    
    UIView *navBarContainer;
    UIButton *dismiss, *next;
    PaddedTextField *urlField;
    NSString *finalLink;
    NSMutableArray *imagesSources;
    int downloadCounter, failureCounter;
    WhatIsTheDeal1Online *nextView;
    MBProgressHUD *downloadingImages;
}

@end

@implementation WhereIsTheDealOnline

@synthesize appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self updateButtons];
    [self setNavBarContent];
    [self setNavBarConstraints];
    [self configureExplanationView];
    [self setProgressBar];
    [self manageURL];
    
    if ([self.cameFrom isEqualToString:@"Add Deal"] && !(urlField.text.length > 0)) {
        [self loadRequestFromString:@"http://google.com"];
        self.explanationView.hidden = NO;
    } else {
        self.explanationView.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForNotifications];
    if ([self.cameFrom isEqualToString:@"Add Deal"]) {
        [[self transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"Navigation Bar Shade"]];
        } completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotificationObservers];
    if ([self.cameFrom isEqualToString:@"Add Deal"]) {
        [[self transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        } completion:nil];
    }
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(putClipboardURLIfValid:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardAppearing:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)removeNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    if (url && url.scheme && url.host) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:urlRequest];
    } else {
        NSString *new = [NSString stringWithFormat:@"http://%@", urlString];
        NSURL *newUrl = [NSURL URLWithString:new];
        if (newUrl && newUrl.scheme && newUrl.host) {
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:newUrl];
            [self.webView loadRequest:urlRequest];
        } else {
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }
}

- (void)manageURL
{
    if ([self.cameFrom isEqualToString:@"Add Deal"]) {
        self.screenName = @"Add Deal - Where Is The Deal Online Screen";
//        [self putClipboardURLIfValid:YES];
    } else {
        self.screenName = @"Edit Deal - Where Is The Deal Online Screen";
        if (self.urlToLoad.length > 0) {
            [self loadRequestFromString:self.urlToLoad];
        } else {
            NSLog(@"Unvalid URL :(");
        }
    }
}


- (void)putClipboardURLIfValid:(BOOL)andGO
{
    NSString *clipboardURL = [self checkClipboardForValidURL];
    if (clipboardURL) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ([clipboardURL isEqualToString:[ud objectForKey:@"clipboardURL"]]) {
            return;
        } else {
            [ud setObject:clipboardURL forKey:@"clipboardURL"];
        }
        urlField.text = clipboardURL;
        if (andGO) {
            [self loadRequestFromString:urlField.text];
        }
    }
}

- (void)keyboardAppearing:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.explanationView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.explanationView.hidden = YES;
                     }];
}

- (void)setNavBarContent
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0)];
    self.navigationItem.titleView = titleView;
    navBarContainer = [[UIView alloc] init];
    navBarContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [titleView addSubview:navBarContainer];
    NSLog(@"%f", self.navigationController.navigationBar.bounds.size.width);
    [navBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:navBarContainer
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:self.navigationController.navigationBar.bounds.size.width]];
    
    [navBarContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[navBarContainer(==44)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(navBarContainer)]];
    
    [titleView addConstraint:[NSLayoutConstraint constraintWithItem:navBarContainer
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:titleView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [titleView addConstraint:[NSLayoutConstraint constraintWithItem:navBarContainer
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:titleView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:8.0]];
    
    urlField = [[PaddedTextField alloc] init];
    urlField.placeholder = NSLocalizedString(@"Type address", nil);
    urlField.layer.cornerRadius = 5.0;
    urlField.layer.masksToBounds = YES;
    urlField.font = [UIFont fontWithName:@"Avenir-Roman" size:14.0];
    urlField.textAlignment = NSTextAlignmentLeft;
    urlField.keyboardType = UIKeyboardTypeURL;
    urlField.returnKeyType = UIReturnKeyGo;
    urlField.autocorrectionType = UITextAutocorrectionTypeNo;
    urlField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    urlField.clearButtonMode = UITextFieldViewModeWhileEditing;
    urlField.delegate = self;
    [urlField setTranslatesAutoresizingMaskIntoConstraints:NO];
    if ([self.cameFrom isEqualToString:@"Add Deal"]) {
        urlField.backgroundColor = [UIColor whiteColor];
    } else {
        urlField.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    [navBarContainer addSubview:urlField];
    [urlField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[urlField(==30)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(urlField)]];
    
    if (![self.cameFrom isEqualToString:@"View Deal"]) {
        next = [UIButton buttonWithType:UIButtonTypeSystem];
        [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        [next setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
        [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [next.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0]];
        [next setBackgroundColor:[appDelegate ourPurple]];
        [next.layer setCornerRadius:5.0];
        [next.layer setMasksToBounds:YES];
        [next setTranslatesAutoresizingMaskIntoConstraints:NO];
        [navBarContainer addSubview:next];
        [next addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[next(==58)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(next)]];
        
        [next addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[next(==30)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(next)]];
        if ([self.cameFrom isEqualToString:@"Edit Deal"]) {
            [next setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        }
        [self disableNext];
    }
    
    if (![self.cameFrom isEqualToString:@"Edit Deal"]) {
        dismiss = [UIButton buttonWithType:UIButtonTypeSystem];
        [dismiss setImage:[UIImage imageNamed:@"Dismiss"] forState:UIControlStateNormal];
        [dismiss addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [dismiss setTranslatesAutoresizingMaskIntoConstraints:NO];
        [navBarContainer addSubview:dismiss];
        [dismiss addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[dismiss(==38)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(dismiss)]];
        
        [dismiss addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dismiss(==44)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(dismiss)]];

    }
}

- (void)setNavBarConstraints
{
    if (![self.cameFrom isEqualToString:@"Edit Deal"]) {
        [navBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:navBarContainer
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:dismiss
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:0]];
        [navBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:navBarContainer
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:dismiss
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0]];
    }
    
    [navBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:navBarContainer
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:urlField
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0
                                                                 constant:-38.0]];
    
    if ([self.cameFrom isEqualToString:@"View Deal"]) {
        [navBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:navBarContainer
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:urlField
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0
                                                                     constant:15.0]];
    } else {
        [navBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:urlField
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:next
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:-8.0]];
        [navBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:next
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:navBarContainer
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0
                                                                     constant:-10.0]];
        [navBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:navBarContainer
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:next
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0]];
    }
    
    [navBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:navBarContainer
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:urlField
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:0]];
    
    
    [self.view layoutIfNeeded];
}

- (void)configureExplanationView
{
    if ([self.cameFrom isEqualToString:@"Add Deal"]) {
        self.explanationLabel.text = NSLocalizedString(@"Go to the deal's page at the store URL (Amazon.com, Ebay.com), and then tap Next.", nil);
        self.tipLabel.text = NSLocalizedString(@"Tip: Copy a valid URL, and it will be pasted automatically in the address field.", nil);
    } else {
        self.explanationLabel.hidden = YES;
        self.tipLabel.hidden = YES;
    }
}

- (NSString *)checkClipboardForValidURL
{
    NSString *copied = [UIPasteboard generalPasteboard].string;
    BOOL ssl = NO;
    NSRange range;
    if ([copied rangeOfString:@"http://"].location != NSNotFound) {
        range = [copied rangeOfString:@"http://"];
    } else if ([copied rangeOfString:@"https://"].location != NSNotFound) {
        range = [copied rangeOfString:@"https://"];
        ssl = YES;
    } else {
        return nil;
    }
    NSString *polishedURL = [copied substringFromIndex:range.location];
    if ([polishedURL rangeOfString:@" "].location != NSNotFound) {
        polishedURL = [polishedURL substringToIndex:[copied rangeOfString:@" "].location];
    }
    // Checking if there is are more than 1 address for some reason
    NSUInteger count = 0, length = [polishedURL length];
    range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        if (ssl) {
            range = [polishedURL rangeOfString:@"https://" options:0 range:range];
        } else {
            range = [polishedURL rangeOfString:@"http://" options:0 range:range];
        }
        if (range.location != NSNotFound) {
            if (count > 0) {
                return nil;
            }
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++;
        }
    }
    return polishedURL;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *text = textField.text;
    [self loadRequestFromString:text];
    [textField resignFirstResponder];
    [downloadingImages hide:YES];
    return NO;
}

- (void)next:(UIButton *)sender
{
    self.website = [[Store alloc] init];
    if (finalLink.length > 0) {
        self.website.url = finalLink;
        self.website.name = [self extractWebsiteName];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Not a valid URL", nil)
                                                        message:NSLocalizedString(@"Go to the deal's page so others will have the link.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.cameFrom isEqualToString:@"Add Deal"]) {
        [self moveNext];
    
    } else if ([self.cameFrom isEqualToString:@"Edit Deal"]) {
        [self updateDealWebsite];
    }
}

- (void)moveNext
{
    if (self.cashedInstance) {
        nextView = self.cashedInstance;
        if (!nextView.selectedImage) {
            [self downloadImages];
        } else {
            [self pushNextView];
        }
    } else {
        nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"WhatIsTheDeal1Online"];
        [self downloadImages];
    }
    nextView.store = self.website;
}

- (void)updateDealWebsite
{
    EditDealTableViewController *edtvc = (EditDealTableViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    edtvc.store = self.website;
    edtvc.dealStore.text = self.website.name;
    edtvc.didChangeOriginalDeal = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushNextView
{
    if (nextView) {
        if (![self.navigationController.topViewController isEqual:nextView]) {
            nextView.images = self.images;
            [self.navigationController pushViewController:nextView animated:YES];
        } else {
            NSLog(@"The view controller instance was already pushed!");
        }
    } else {
        NSLog(@"No view to push :(");
    }
}

- (NSString *)extractWebsiteName
{
    NSURL *url = [NSURL URLWithString:finalLink];
    NSString *name = [url host];
    if ([[name substringToIndex:2] isEqualToString:@"m."]) {
        name = [name substringFromIndex:2];
    } else if ([[name substringToIndex:4] isEqualToString:@"www."]) {
        name = [name substringFromIndex:4];
    } else if ([[name substringToIndex:6] isEqualToString:@"touch."]) {
        name = [name substringFromIndex:6];
    }
    return name;
}

- (void)validation:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    if (!(url && url.scheme && url.host)) {
        [self disableNext];
        finalLink = nil;
    } else {
        [self enableNext];
        finalLink = urlString;
    }
}

- (void)enableNext
{
    if (!next.enabled) {
        [UIView animateWithDuration:0.3 animations:^{ next.alpha = 1.0; }];
        next.enabled = YES;
    }
}

- (void)disableNext
{
    if (next.enabled) {
        [UIView animateWithDuration:0.3 animations:^{ next.alpha = 0.25; }];
        next.enabled = NO;
    }
}

- (void)dismiss:(UIButton *)sender
{
    appDelegate.addDealState = NO;
    [self dismissViewControllerAnimated:YES completion:^{
        [appDelegate exitAddDealState];
    }];
}

- (void)setProgressBar
{
    UIImageView *loadingAnimation = [appDelegate loadingAnimationWhite];
    [loadingAnimation startAnimating];
    
    downloadingImages = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    downloadingImages.delegate = self;
    downloadingImages.customView = loadingAnimation;
    downloadingImages.mode = MBProgressHUDModeCustomView;
    downloadingImages.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.view addSubview:downloadingImages];
}


#pragma mark - Web view

- (void)updateButtons
{
    self.forward.enabled = self.webView.canGoForward;
    self.back.enabled = self.webView.canGoBack;
}

- (void)downloadImages
{
    downloadCounter = 0;
    failureCounter = 0;
    NSString *script = @"var names = []; var a = document.getElementsByTagName(\"IMG\");for (var i=0, len=a.length; i<len; i++){names.push(document.images[i].src);}String(names);";
    NSString *urls = [self.webView stringByEvaluatingJavaScriptFromString:script];
    imagesSources = (NSMutableArray *)[urls componentsSeparatedByString:@","];
    self.images = [[NSMutableArray alloc] init];
    [downloadingImages show:YES];
    for (NSString *source in imagesSources) {
        if ([imagesSources indexOfObject:source] == 150) {
            break;
        }
        NSLog(@"%@", source);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:source]];
        AFImageRequestOperation *operation;
        operation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                         imageProcessingBlock:nil
                                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                          downloadCounter++;
                                                                          NSLog(@"%@", request.description);
                                                                          [self addImage:image];
                                                                          [self continueIfDone];
                                                                      }
                                                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                          NSLog(@"%@", [error localizedDescription]);
                                                                          downloadCounter++;
                                                                          failureCounter++;
                                                                          if (failureCounter == imagesSources.count || failureCounter == 150) {
                                                                              [downloadingImages hide:YES];
                                                                              if (error.code != -10) {
                                                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Couldn't download images", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                                  [alert show];
                                                                              }
                                                                          }
                                                                          [self continueIfDone];
                                                                      }];
        [operation start];
    }
}

- (void)continueIfDone
{
    if (downloadCounter == imagesSources.count || downloadCounter == 150) {
        [downloadingImages hide:YES];
        if ([nextView isEqual:self.cashedInstance] && !nextView.selectedImage) {
            [nextView insertImageInImageView:self.images.firstObject];
        }
        [self pushNextView];
    }
}

- (void)addImage:(UIImage *)image
{
    if (image.size.width >= 80.0 && image.size.height >= 50.0) {
        [self.images addObject:image];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    NSString *pageURL = self.webView.request.URL.absoluteString;
    if (pageURL) {
        urlField.text = pageURL;
        [self validation:pageURL];
    } else {
        finalLink = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [self presentErrorAlert:error];
}

- (void)presentErrorAlert:(NSError *)error
{
    if (error.code != NSURLErrorCancelled) { // Error with code -999
        [self disableNext];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


@end
