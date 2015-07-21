//
//  NewRankViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 7/7/15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ScoreAndStatsViewController.h"
#import "ElasticLabel.h"
#import "GAITrackedViewController.h"

@interface NewRankViewController : GAITrackedViewController

@property AppDelegate *appDelegate;
@property UINavigationController *navControllerDelegate;

@property NSString *rank;

@property (weak, nonatomic) IBOutlet UIImageView *rankIcon;
@property (weak, nonatomic) IBOutlet ElasticLabel *rankLabel;
@property (weak, nonatomic) IBOutlet ElasticLabel *secondaryCongrats;
@property (weak, nonatomic) IBOutlet UIButton *goToStats;
@property (weak, nonatomic) IBOutlet UIButton *facebookShare;
@property (weak, nonatomic) IBOutlet UIButton *whatsAppShare;
@property (weak, nonatomic) IBOutlet UIButton *dismiss;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankBottomConstraint;


- (IBAction)goToStats:(id)sender;
- (IBAction)shareWithFacebook:(id)sender;
- (IBAction)shareWithWhatsApp:(id)sender;
- (IBAction)dismiss:(id)sender;

@end
