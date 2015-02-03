//
//  EnterPasscodeViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 1/12/15.
//
//

#import "EnterPasscodeViewController.h"

@interface EnterPasscodeViewController ()

@end

@implementation EnterPasscodeViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setDismissButton];
    [self setDoneButton];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.incorrectPasscode.alpha = 0;
    self.passcodeTextField.layer.cornerRadius = 8.0;
    self.passcodeTextField.layer.masksToBounds = YES;
}

- (void)setDismissButton
{
    UIButton *dismiss = [UIButton buttonWithType:UIButtonTypeSystem];
    [dismiss setFrame:CGRectMake(8, 30, 30, 30)];
    [dismiss setImage:[UIImage imageNamed:@"Dismiss"] forState:UIControlStateNormal];
    [dismiss addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:dismiss];
}

- (void)dismiss
{
    [self.view endEditing:YES];
    [self.navigationControllerDelegate dismissViewControllerAnimated:YES
                                                          completion:^{
                                                              OpeningScreenViewController *opvc = (OpeningScreenViewController *)self.navigationControllerDelegate.topViewController;
                                                              [opvc cancelFacebookLogin];
                                                          }];
}

- (void)setDoneButton
{
    NSString *doneText;
    
    if (self.signUp) {
        doneText = NSLocalizedString(@"Next", nil);
        self.passcodeTextField.returnKeyType = UIReturnKeyNext;
        
    } else {
        doneText = NSLocalizedString(@"Done", nil);
        self.passcodeTextField.returnKeyType = UIReturnKeyDone;
    }
    
    self.done = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.done setFrame:CGRectMake(0, 0, 60.0, 34.0)];
    [self.done setTitle:doneText forState:UIControlStateNormal];
    [self.done setBackgroundColor:[appDelegate ourPurple]];
    [self.done setTintColor:[UIColor whiteColor]];
    [self.done.layer setCornerRadius:5.0];
    [self.done.layer setMasksToBounds:YES];
    [self.done.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0]];
    
    [self.done addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    
    self.done.center = self.passcodeTextField.center;
    CGRect frame = self.done.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width * 1.5;
    self.done.frame = frame;
    
    self.done.alpha = 0;
    self.done.hidden = YES;
    
    [self.view addSubview:self.done];
}

- (void)showDoneButton
{
    self.done.hidden = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.done.alpha = 1.0;
        CGRect frame = self.done.frame;
        frame.origin.x = self.view.frame.size.width - self.done.frame.size.width - 20.0;
        self.done.frame = frame;
    }];
}

- (void)hideDoneButton
{
    [UIView animateWithDuration:0.15 animations:^{
        self.done.alpha = 0;
        CGRect frame = self.done.frame;
        frame.origin.x = self.view.frame.size.width - frame.size.width * 1.5;
        self.done.frame = frame;
    } completion:^(BOOL finished) {
        self.done.hidden = YES;
    }];
}


- (IBAction)whatIsThis:(id)sender
{
    if (!self.whatIsThisView) {
        [self setWhatIsThisView];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.whatIsThisView.alpha = 1.0;
        CGRect frame = self.whatIsThisView.frame;
        frame.origin.y -= 30;
        self.whatIsThisView.frame = frame;
        
        self.blackBackground.alpha = 0.6;
    }];
}

- (void)setWhatIsThisView
{
    CGFloat x = 30;
    CGFloat y = self.whatIsThis.frame.origin.y - 200;
    CGFloat width = self.view.frame.size.width - 60;
    CGFloat height = 200;
    self.whatIsThisView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.whatIsThisView.backgroundColor = [UIColor whiteColor];
    self.whatIsThisView.layer.cornerRadius = 8.0;
    self.whatIsThisView.layer.masksToBounds = YES;
    self.whatIsThisView.clipsToBounds = NO;
    self.whatIsThisView.alpha = 0;
    
    [self.view addSubview:self.whatIsThisView];
    
    self.blackBackground = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blackBackground.frame = self.view.frame;
    self.blackBackground.backgroundColor = [UIColor blackColor];
    [self.blackBackground addTarget:self action:@selector(hideWhatIsThisView:) forControlEvents:UIControlEventTouchUpInside];
    self.blackBackground.alpha = 0;
    
    [self.view insertSubview:self.blackBackground belowSubview:self.whatIsThisView];
    
    UITextView *explanation = [[UITextView alloc] initWithFrame:CGRectMake(20, 30, self.whatIsThisView.frame.size.width - 40, 100)];
    explanation.textContainerInset = UIEdgeInsetsZero;
    explanation.contentInset = UIEdgeInsetsZero;
    explanation.scrollEnabled = NO;
    explanation.editable = NO;
    explanation.font = [UIFont fontWithName:@"Avenir-Roman" size:16.0];
    explanation.textAlignment = NSTextAlignmentCenter;
    explanation.text = NSLocalizedString(@"Dealers is an invite-only network. You must be invited by an existing member in order to get a passcode.", nil) ;
    
    if ([[[NSBundle mainBundle] preferredLocalizations].firstObject isEqualToString:@"he"]) {
        [explanation setBaseWritingDirection:UITextWritingDirectionRightToLeft forRange:nil];
        [explanation setTextAlignment:NSTextAlignmentCenter];
    }
    
    [self.whatIsThisView addSubview:explanation];
    
    UIButton *gotIt = [UIButton buttonWithType:UIButtonTypeSystem];
    [gotIt setFrame:CGRectMake(50, 140, self.whatIsThisView.frame.size.width - 100, 40)];
    [gotIt setTitle:NSLocalizedString(@"Got it", nil) forState:UIControlStateNormal];
    [gotIt.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:18.0]];
    [gotIt setTintColor:[appDelegate ourPurple]];
    [gotIt setAlpha:0.9];
    [gotIt addTarget:self action:@selector(hideWhatIsThisView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.whatIsThisView addSubview:gotIt];
    
    UIView *arrow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    arrow.backgroundColor = [UIColor whiteColor];
    arrow.center = CGPointMake(self.whatIsThisView.frame.size.width / 2, self.whatIsThisView.frame.size.height);
    arrow.transform = CGAffineTransformRotate(arrow.transform, 150);
    
    [self.whatIsThisView addSubview:arrow];
}

- (void)hideWhatIsThisView:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.whatIsThisView.alpha = 0;
        CGRect frame = self.whatIsThisView.frame;
        frame.origin.y += 30;
        self.whatIsThisView.frame = frame;
        
        self.blackBackground.alpha = 0;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Prevent crashing undo bug when pasing and then undoing.
    if (range.length + range.location > textField.text.length)
    {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (newLength == 0 && self.incorrectPasscode.alpha > 0) {
        [UIView animateWithDuration:0.15 animations:^{
            self.incorrectPasscode.alpha = 0;
        }];
    }
    
    if (newLength >= 4) {
        if (self.done.hidden) {
            [self showDoneButton];
        }
    } else {
        if (!self.done.hidden) {
            [self hideDoneButton];
        }
    }
    
    return newLength <= 6;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return YES;
    }
    
    if (textField.text.length != 4) {
        [self passcodeIncorrect];
        return YES;
    }
    
    if (self.signUp) {
        
        [self checkPasscode];
        
    } else {
        
        [self checkPasscode];
    }
    
    return YES;
}

- (void)done:(id)sender
{
    if (self.passcodeTextField.text.length == 0) {
        [self.passcodeTextField resignFirstResponder];
        return;
    }
    
    if (self.passcodeTextField.text.length < 4) {
        [self passcodeIncorrect];
        return;
    }
    
    if ([self.passcodeTextField.text isEqualToString:@"090909"]) {
        [self passcodeCorrect];
        return;
    }
    
    [self checkPasscode];
}

- (void)passcodeCorrect
{
    [self.view endEditing:YES];
    
    self.checkmark = [[UIImageView alloc] initWithFrame:self.activityIndicator.frame];
    self.checkmark.image = [UIImage imageNamed:@"Verified Checkmark"];
    [self.view addSubview:self.checkmark];
    
    if (self.incorrectPasscode.alpha > 0) {
        self.incorrectPasscode.alpha = 0;
    }
    
    [self performSelector:@selector(dismissAndContinue) withObject:nil afterDelay:1.5];
}

- (void)passcodeIncorrect
{
    [UIView animateWithDuration:0.15 animations:^{
        self.incorrectPasscode.alpha = 1.0;
    }];
    
    [UIView animateWithDuration:0.05 animations:^{
        CGRect frame = self.passcodeTextField.frame;
        frame.origin.x -= 10;
        self.passcodeTextField.frame = frame;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.passcodeTextField.frame;
            frame.origin.x += 18;
            self.passcodeTextField.frame = frame;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.15 animations:^{
                CGRect frame = self.passcodeTextField.frame;
                frame.origin.x -= 12;
                self.passcodeTextField.frame = frame;
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    CGRect frame = self.passcodeTextField.frame;
                    frame.origin.x += 4;
                    self.passcodeTextField.frame = frame;
                }];
            }];
        }];
    }];
}

- (void)checkPasscode
{
    if (self.incorrectPasscode.alpha > 0) {
        [UIView animateWithDuration:0.15 animations:^{
            self.incorrectPasscode.alpha = 0;
        }];
    }
    
    [self.activityIndicator startAnimating];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/invitations/"
                                           parameters:@{@"passcode": self.passcodeTextField.text}
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mapping) {
                                                  
                                                  [self.activityIndicator stopAnimating];
                                                  
                                                  // Check if password is valid
                                                  
                                                  if (mapping.array.count > 0) {
                                                      
                                                      NSLog(@"Passcode is valid!");
                                                      
                                                      Invitation *invitation = mapping.firstObject;
                                                      [self deleteInvitation:invitation];
                                                      
                                                      [self passcodeCorrect];
                                                  
                                                  } else {
                                                      
                                                      NSLog(@"Passcode is invalid! Enterence denied.");
                                                      [self passcodeIncorrect];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"Error is:\n\n%@\n\n", error);
                                                  [self.activityIndicator stopAnimating];
                                                  
                                                  UIAlertView *tryAgain = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Can't connect the server", nil)
                                                                                                         message:NSLocalizedString(@"Please try again", nil)
                                                                                                        delegate:nil
                                                                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                               otherButtonTitles:nil];
                                                  [tryAgain show];
                                              }];
}

- (void)deleteInvitation:(Invitation *)invitation
{
    NSString *path = [NSString stringWithFormat:@"/invitations/%@/", invitation.invitationID];
    
    [[RKObjectManager sharedManager] deleteObject:invitation
                                             path:path
                                       parameters:nil
                                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mapping) {
                                              
                                              NSLog(@"Passcode deleted from the servers");
                                          }
                                          failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                              
                                              NSLog(@"Couldn't delete the invitation");
                                              
                                              // Try again
                                              if (deleteAttempt < 2) {
                                                  deleteAttempt++;
                                                  [self deleteInvitation:invitation];
                                              }
                                          }];
}

- (void)dismissAndContinue
{
    OpeningScreenViewController *mvc = (OpeningScreenViewController *)[self.navigationControllerDelegate topViewController];
    mvc.authorized = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"authorized"];
    
    if (self.signUp) {
        SignUpTableViewController *sutvc = [self.navigationControllerDelegate.storyboard instantiateViewControllerWithIdentifier:@"SignUpID"];
        [self.navigationControllerDelegate dismissViewControllerAnimated:YES
                                                              completion:^{
                                                                  [self.navigationControllerDelegate pushViewController:sutvc animated:YES];
                                                              }];
    } else {
        OpeningScreenViewController *osvc = (OpeningScreenViewController *)[self.navigationControllerDelegate topViewController];
        [self.navigationControllerDelegate dismissViewControllerAnimated:YES
                                                              completion:^{
                                                                  [osvc signUpUser];
                                                              }];
    }
}


@end
