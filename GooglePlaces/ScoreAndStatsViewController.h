//
//  ScoreAndStatsViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 7/6/15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ScoreGuideViewController.h"
#import "ScoreGuide.h"
#import "ElasticLabel.h"
#import "GAITrackedViewController.h"

@interface ScoreAndStatsViewController : GAITrackedViewController

@property AppDelegate *appDelegate;
@property Dealer *dealer;
@property ScoreGuide *scoreGuide;

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingAnimation;

@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankName;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *deals;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UILabel *shares;
@property (weak, nonatomic) IBOutlet ElasticLabel *whatsNext;

@property BOOL isMyStats;

- (IBAction)scoreGuide:(id)sender;

@end
