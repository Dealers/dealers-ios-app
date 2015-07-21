//
//  ScoreAndStatsViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 7/6/15.
//
//

#import "ScoreAndStatsViewController.h"

@interface ScoreAndStatsViewController ()

@end

@implementation ScoreAndStatsViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialize];
    [self presentLoadingView];
    [self downloadStats];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"Navigation Bar Shade"];
}

- (void)initialize
{
    if (self.isMyStats) {
        self.title = [NSString stringWithFormat:NSLocalizedString(@"My Stats", nil)];
    } else {
        self.title = self.dealer.fullName;
    }
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self setScreenName:@"Score & Stats Screen"];
    self.whatsNext.hidden = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

- (void)presentLoadingView
{
    self.loadingAnimation.animationImages = [appDelegate loadingAnimationPurpleImages];
    self.loadingAnimation.animationDuration = 0.3;
    [self.loadingAnimation startAnimating];
    self.loadingView.hidden = NO;
    self.loadingView.alpha = 1.0;
    [self.view bringSubviewToFront:self.loadingView];
}

- (void)hideLoadingView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loadingAnimation.transform = CGAffineTransformMakeScale(0.001, 0.001);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              self.loadingView.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              [self.view sendSubviewToBack:self.loadingView];
                                              self.loadingView.hidden = YES;
                                              self.loadingAnimation.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }];
                     }];
}

- (void)presentWhatsNext
{
    self.whatsNext.hidden = NO;
    self.whatsNext.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.whatsNext.alpha = 1.0;
    }];
}

- (void)downloadStats
{
    NSString *path = [NSString stringWithFormat:@"/dealers/%@/", self.dealer.dealerID];
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSLog(@"Dealer downloaded successfully!");
                                                  self.dealer = mappingResult.firstObject;
                                                  if (self.isMyStats) {
                                                      appDelegate.dealer = self.dealer;
                                                      appDelegate.dealer.photo = [appDelegate loadProfilePic];
                                                      [appDelegate saveUserDetailsOnDevice];
                                                      [self downloadScoreGuide];
                                                  }
                                                  [self setStatsIntoViews];
                                                  [self hideLoadingView];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"Dealer failed to download.");
                                                  [self hideLoadingView];
                                              }];
}

- (void)downloadScoreGuide
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/score_tables/"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSLog(@"Score guide downloaded successfully!");
                                                  self.scoreGuide = mappingResult.firstObject;
                                                  [self fillWhatsNextTextView:self.dealer.rank];
                                                  [self.view layoutIfNeeded];
                                                  [self presentWhatsNext];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"Score guide failed to download.");
                                              }];
}

- (void)setStatsIntoViews
{
    [self.rankImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@ Icon", self.dealer.rank]]];
    self.rankName.text = NSLocalizedString(self.dealer.rank, nil);
    self.score.text = self.dealer.score.stringValue;
    self.deals.text = [[NSNumber numberWithUnsignedInteger:self.dealer.uploadedDeals.count] stringValue];
    self.likes.text = self.dealer.totalLikes.stringValue;
    self.shares.text = self.dealer.totalShares.stringValue;
}

- (void)fillWhatsNextTextView:(NSString *)rank
{
    NSString *text;
    NSInteger left, likesAndShares;
    NSInteger score = self.dealer.score.integerValue;
    if ([rank isEqualToString:@"Viewer"]) {
        if (self.scoreGuide.dealer.integerValue == 0) {
            text = NSLocalizedString(@"All you have to do to become a Dealer is upload one deal.", nil);
        } else {
            left = self.scoreGuide.dealer.integerValue - score;
            text = [NSString stringWithFormat:NSLocalizedString(@"To become a Dealer upload one deal and gain %ld more points.", nil), left];
        }
    } else if ([rank isEqualToString:@"Dealer"]) {
        left = self.scoreGuide.proDealer.integerValue - score;
        text = [NSString stringWithFormat:NSLocalizedString(@"To become a Pro Dealer, gain %ld more points.", nil), left];
    } else if ([rank isEqualToString:@"Pro Dealer"]) {
        left = self.scoreGuide.seniorDealer.integerValue - score;
        likesAndShares = 100 - (self.dealer.totalLikes.integerValue + self.dealer.totalShares.integerValue);
        text = [NSString stringWithFormat:NSLocalizedString(@"To become a Senior Dealer, gain %ld more likes & shares and %ld more points.", nil), likesAndShares, left];
    } else if ([rank isEqualToString:@"Senior Dealer"]) {
        left = self.scoreGuide.masterDealer.integerValue - score;
        likesAndShares = 200 - (self.dealer.totalLikes.integerValue + self.dealer.totalShares.integerValue);
        text = [NSString stringWithFormat:NSLocalizedString(@"To become a Master Dealer, gain %ld more likes & shares and %ld more points.", nil), likesAndShares, left];
    } else if ([rank isEqualToString:@"Master Dealer"]) {
        text = NSLocalizedString(@"You're on top :)", nil);
    }
    [self.whatsNext setText:text];
}

- (IBAction)scoreGuide:(id)sender {

    ScoreGuideViewController *sgvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreGuide"];
    [self.navigationController pushViewController:sgvc animated:YES];
}


@end
