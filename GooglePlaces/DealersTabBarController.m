//
//  DealersTabBarController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/30/14.
//
//

#import "DealersTabBarController.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@interface DealersTabBarController () {
    
    // UI elements:
    UIStoryboard *storyboard;
    UIButton *blackBackground;
    UIView *optionsContainer;
    UIView *containerPointer;
    UILabel *hint;
    UIButton *local;
    UIButton *localLabel;
    UIButton *online;
    UIButton *onlineLabel;
    NSLayoutConstraint *verticalSpaceContainerButton;
    
    UIActionSheet *feedbackActionSheet;
    MBProgressHUD *progressIndicator;
    BOOL onlineOrLocalPresented, feedbackViewPresenting;
}

@end

@implementation DealersTabBarController

@synthesize appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];
    [self setElements];
    [self setConstraints];
    [self setProgressIndicator];
    [self setActionSheet];
}

- (void)initialize
{
    onlineOrLocalPresented = NO;
    feedbackViewPresenting = NO;
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    appDelegate = [[UIApplication sharedApplication] delegate];
}


#pragma mark - Local or Online

- (void)addDeal:(UIButton *)addDealButton
{
    if (onlineOrLocalPresented) {
        [self hideOnlineOrLocal:addDealButton];
    } else {
        [self presentOnlineOrLocal:addDealButton];
    }
}

- (void)setElements
{
    // Add Deal button
    self.addDealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addDealButton.frame = CGRectMake(self.tabBar.center.x - 30.5,self.tabBar.center.y-30.5, 61, 61);
    [self.addDealButton setImage:[UIImage imageNamed:@"Add Deal"] forState:UIControlStateNormal];
    [self.addDealButton setImage:[UIImage imageNamed:@"Add Deal Highlighted"] forState:UIControlStateHighlighted];
    [self.addDealButton addTarget:self action:@selector(addDeal:) forControlEvents:UIControlEventTouchUpInside];
    self.addDealButton.userInteractionEnabled = YES;
    self.addDealButton.tag = 123;
    [self.view addSubview:self.addDealButton];
    
    // Black background
    blackBackground = [UIButton buttonWithType:UIButtonTypeCustom];
    blackBackground.frame = self.view.frame;
    blackBackground.backgroundColor = [UIColor blackColor];
    [blackBackground addTarget:self action:@selector(hideOnlineOrLocal:) forControlEvents:UIControlEventTouchUpInside];
    blackBackground.alpha = 0;
    blackBackground.hidden = YES;
    [self.view insertSubview:blackBackground belowSubview:self.addDealButton];
    
    // Options container
    optionsContainer = [[UIView alloc] init];
    optionsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    optionsContainer.layer.cornerRadius = 10.0;
    optionsContainer.layer.masksToBounds = YES;
    optionsContainer.backgroundColor = [UIColor whiteColor];
    optionsContainer.alpha = 0;
    optionsContainer.hidden = YES;
    optionsContainer.tintColor =[appDelegate ourPurple];
    optionsContainer.clipsToBounds = NO;
    [self.view addSubview:optionsContainer];
    
    containerPointer = [[UIView alloc] init];
    containerPointer.backgroundColor = [UIColor whiteColor];
    containerPointer.transform = CGAffineTransformRotate(containerPointer.transform, 150);
    containerPointer.translatesAutoresizingMaskIntoConstraints = NO;
    [optionsContainer addSubview:containerPointer];
    [containerPointer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[containerPointer(==20)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(containerPointer)]];
    
    [containerPointer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[containerPointer(==20)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(containerPointer)]];
    
    // Local and online buttons
    local = [UIButton buttonWithType:UIButtonTypeSystem];
    [local setImage:[UIImage imageNamed:@"Add Local Deal v2"] forState:UIControlStateNormal];
    [local addTarget:self action:@selector(startLocal:) forControlEvents:UIControlEventTouchUpInside];
    [local setTranslatesAutoresizingMaskIntoConstraints:NO];
    [optionsContainer addSubview:local];
    [local addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[local(==50)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:NSDictionaryOfVariableBindings(local)]];
    
    [local addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[local(==63)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:NSDictionaryOfVariableBindings(local)]];
    localLabel = [UIButton buttonWithType:UIButtonTypeSystem];
    [localLabel setTitle:NSLocalizedString(@"Local", nil) forState:UIControlStateNormal];
    localLabel.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:13.0];
    [localLabel addTarget:self action:@selector(startLocal:) forControlEvents:UIControlEventTouchUpInside];
    [localLabel setAdjustsImageWhenHighlighted:NO];
    [localLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [optionsContainer addSubview:localLabel];
    
    online = [UIButton buttonWithType:UIButtonTypeSystem];
    [online setImage:[UIImage imageNamed:@"Add Online Deal v2"] forState:UIControlStateNormal];
    [online addTarget:self action:@selector(startOnline:) forControlEvents:UIControlEventTouchUpInside];
    [online setTranslatesAutoresizingMaskIntoConstraints:NO];
    [optionsContainer addSubview:online];
    [online addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[online(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(online)]];
    
    [online addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[online(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(online)]];
    onlineLabel = [UIButton buttonWithType:UIButtonTypeSystem];
    [onlineLabel setTitle:NSLocalizedString(@"Online", nil) forState:UIControlStateNormal];
    onlineLabel.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:13.0];
    [onlineLabel addTarget:self action:@selector(startOnline:) forControlEvents:UIControlEventTouchUpInside];
    [onlineLabel setAdjustsImageWhenHighlighted:NO];
    [onlineLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [optionsContainer addSubview:onlineLabel];
    
    // Hint
    hint = [[UILabel alloc] init];
    hint.text = NSLocalizedString(@"Is the deal from a\nwebsite or local store?", nil);
    hint.numberOfLines = 0;
    hint.textColor = [appDelegate textGrayColor];
    hint.textAlignment = NSTextAlignmentCenter;
    hint.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    hint.translatesAutoresizingMaskIntoConstraints = NO;
    [optionsContainer addSubview:hint];
}

- (void)setConstraints
{
    verticalSpaceContainerButton = [NSLayoutConstraint constraintWithItem:optionsContainer
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.addDealButton
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:-20.0];
    [self.view addConstraint:verticalSpaceContainerButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:optionsContainer
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:containerPointer
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:optionsContainer
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:containerPointer
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:10.0]];
    
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:optionsContainer
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:online
                                                                 attribute:NSLayoutAttributeLeading
                                                                multiplier:1.0
                                                                  constant:-30.0]];
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:online
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:optionsContainer
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-40.0]];
    
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:localLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:onlineLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0]];
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:online
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:onlineLabel
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0]];
    
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:online
                                                                 attribute:NSLayoutAttributeTrailing
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:local
                                                                 attribute:NSLayoutAttributeLeading
                                                                multiplier:1.0
                                                                  constant:-40.0]];
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:local
                                                                 attribute:NSLayoutAttributeTrailing
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:optionsContainer
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:-30.0]];
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:local
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:online
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0]];
    
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:local
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:localLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:8.0]];
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:local
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:localLabel
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0]];
    
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:hint
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:online
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:-20.0]];
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:hint
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:optionsContainer
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:20.0]];
    [optionsContainer addConstraint:[NSLayoutConstraint constraintWithItem:hint
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:optionsContainer
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0]];
    
    [self.view layoutIfNeeded];
}

- (void)presentOnlineOrLocal:(UIButton *)button
{
    [self.view layoutIfNeeded];
    verticalSpaceContainerButton.constant = -30.0;
    blackBackground.hidden = NO;
    optionsContainer.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.addDealButton.transform = CGAffineTransformRotate(self.addDealButton.transform, degreesToRadians(45));
                         blackBackground.alpha = 0.6;
                         optionsContainer.alpha = 1.0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         onlineOrLocalPresented = YES;
                     }];
}

- (void)hideOnlineOrLocal:(UIButton *)button
{
    [self.view layoutIfNeeded];
    verticalSpaceContainerButton.constant = -20.0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.addDealButton.transform = CGAffineTransformRotate(self.addDealButton.transform, degreesToRadians(-45));
                         blackBackground.alpha = 0;
                         optionsContainer.alpha = 0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         blackBackground.hidden = YES;
                         optionsContainer.hidden = YES;
                         onlineOrLocalPresented = NO;
                     }];
}

- (void)startLocal:(UIButton *)button
{
    appDelegate.addDealState = YES;
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"addDealNavController"];
    WhereIsTheDeal *tvc = [storyboard instantiateViewControllerWithIdentifier:@"WhereIsTheDeal"];
    tvc.cameFrom = @"Add Deal";
    [navigationController setViewControllers:@[tvc]];
    [self presentViewController:navigationController animated:YES completion:^{ [self hideOnlineOrLocal:button]; } ];
}

- (void)startOnline:(UIButton *)button
{
    appDelegate.addDealState = YES;
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"addDealNavController"];
    WhereIsTheDealOnline *witdo = [storyboard instantiateViewControllerWithIdentifier:@"WhereIsTheDealOnline"];
    witdo.cameFrom = @"Add Deal";
    [navigationController setViewControllers:@[witdo]];
    [self presentViewController:navigationController animated:YES completion:^{ [self hideOnlineOrLocal:button]; }];
}


#pragma mark - Feedback Shake

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake )
    {
        if (!feedbackViewPresenting && self.selectedViewController.isViewLoaded && self.selectedViewController.view.window) {
            [feedbackActionSheet showInView:self.view];
            feedbackViewPresenting = YES;
        }
    }
}

- (void)setActionSheet
{
    feedbackActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"Send Feedback!", nil), nil];
}

- (void)sendFeedback
{
    NSString *emailTitle = @"Feedback!";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"ideas@dealers-app.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    mc.view.tintColor = [UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:1.0];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        case MFMailComposeResultSent:   {
            [progressIndicator show:YES];
            [progressIndicator hide:YES afterDelay:2.5];
            
            break;
        }
        case MFMailComposeResultFailed: {
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email Error" message:@"Unable to send email. please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    feedbackViewPresenting = NO;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self sendFeedback];
    } else {
        feedbackViewPresenting = NO;
    }
}

- (void)setProgressIndicator
{
    progressIndicator = [[MBProgressHUD alloc]initWithView:self.view];
    progressIndicator.delegate = self;
    progressIndicator.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Complete"]];
    progressIndicator.mode = MBProgressHUDModeCustomView;
    progressIndicator.labelText = NSLocalizedString(@"Email Sent", nil);
    progressIndicator.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    progressIndicator.detailsLabelText = NSLocalizedString(@"Thanks!", nil);
    progressIndicator.detailsLabelFont = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    progressIndicator.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.view addSubview:progressIndicator];
}


@end
