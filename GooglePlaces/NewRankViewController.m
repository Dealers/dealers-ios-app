//
//  NewRankViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 7/7/15.
//
//

#import "NewRankViewController.h"

@interface NewRankViewController ()

@end

@implementation NewRankViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.screenName = @"New Rank";
    self.rankIcon.alpha = 0;
    [self fillInformationInViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController) {
        self.title = NSLocalizedString(@"Congratulations!", nil);
        self.dismiss.hidden = YES;
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        self.dismiss.hidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController) {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
    [self animateRankIcon];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)fillInformationInViews
{
    if ([self.rank isEqualToString:@"Viewer"]) {
        NSLog(@"Can't be. This view should be presented only when advancing to a higher rank.");
    } else if ([self.rank isEqualToString:@"Dealer"]) {
        [self.rankIcon setImage:[UIImage imageNamed:@"Dealer Icon"]];
        if ([appDelegate.dealer.gender isEqualToString:@"Male"]) {
            self.rankLabel.text = NSLocalizedString(@"You are officially a Dealer! ", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"You just started helping people find better deals. Keep it going! ", nil);
        } else if ([appDelegate.dealer.gender isEqualToString:@"Female"]) {
            self.rankLabel.text = NSLocalizedString(@"You are officially a Dealer!  ", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"You just started helping people find better deals. Keep it going!  ", nil);
        } else {
            self.rankLabel.text = NSLocalizedString(@"You are officially a Dealer!", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"You just started helping people find better deals. Keep it going!", nil);
        }
    } else if ([self.rank isEqualToString:@"Pro Dealer"]) {
        [self.rankIcon setImage:[UIImage imageNamed:@"Pro Dealer Icon"]];
        if ([appDelegate.dealer.gender isEqualToString:@"Male"]) {
            self.rankLabel.text = NSLocalizedString(@"You are now a Pro Dealer! ", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"You are not a beginner anymore, you have already helped many people shop better. ", nil);
        } else if ([appDelegate.dealer.gender isEqualToString:@"Female"]) {
            self.rankLabel.text = NSLocalizedString(@"You are now a Pro Dealer!  ", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"You are not a beginner anymore, you have already helped many people shop better.  ", nil);
        } else {
            self.rankLabel.text = NSLocalizedString(@"You are now a Pro Dealer!", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"You are not a beginner anymore, you have already helped many people shop better.", nil);
        }
    } else if ([self.rank isEqualToString:@"Senior Dealer"]) {
        [self.rankIcon setImage:[UIImage imageNamed:@"Senior Dealer Icon"]];
        if ([appDelegate.dealer.gender isEqualToString:@"Male"]) {
            self.rankLabel.text = NSLocalizedString(@"You are now a Senior Dealer! ", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"You're not only active, you also share information that people find super valuable. Way to go! ", nil);
        } else if ([appDelegate.dealer.gender isEqualToString:@"Female"]) {
            self.rankLabel.text = NSLocalizedString(@"You are now a Senior Dealer!  ", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"You're not only active, you also share information that people find super valuable. Way to go!  ", nil);
        } else {
            self.rankLabel.text = NSLocalizedString(@"You are now a Senior Dealer!", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"You're not only active, you also share information that people find super valuable. Way to go!", nil);
        }
    } else if ([self.rank isEqualToString:@"Master Dealer"]) {
        [self.rankIcon setImage:[UIImage imageNamed:@"Master Dealer Icon"]];
        if ([appDelegate.dealer.gender isEqualToString:@"Male"]) {
            self.rankLabel.text = NSLocalizedString(@"You are a Master Dealer! ", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"Your contribution to this community is epic. We want to thank you on behalf of all the people at Dealers! ", nil);
        } else if ([appDelegate.dealer.gender isEqualToString:@"Female"]) {
            self.rankLabel.text = NSLocalizedString(@"You are a Master Dealer!  ", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"Your contribution to this community is epic. We want to thank you on behalf of all the people at Dealers!  ", nil);
        } else {
            self.rankLabel.text = NSLocalizedString(@"You are a Master Dealer!", nil);
            self.secondaryCongrats.text = NSLocalizedString(@"Your contribution to this community is epic. We want to thank you on behalf of all the people at Dealers!", nil);
        }
    }
}

- (void)animateRankIcon
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.rankIcon.alpha = 1.0;
                     }
                     completion:nil];
    
    self.rankTopConstraint.constant = 12.0;
    self.rankBottomConstraint.constant = 28.0;
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (IBAction)goToStats:(id)sender {
    
    if (self.navigationController) {
        ScoreAndStatsViewController *sasvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreAndStats"];
        sasvc.dealer = appDelegate.dealer;
        sasvc.isMyStats = YES;
        [self.navigationController pushViewController:sasvc animated:YES];
    } else {
        [self.navControllerDelegate dismissViewControllerAnimated:YES completion:^{
            ScoreAndStatsViewController *sasvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreAndStats"];
            sasvc.dealer = appDelegate.dealer;
            sasvc.isMyStats = YES;
            [self.navControllerDelegate pushViewController:sasvc animated:YES];
        }];
    }
}

- (IBAction)shareWithFacebook:(id)sender {
    
}

- (IBAction)shareWithWhatsApp:(id)sender {
}

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
