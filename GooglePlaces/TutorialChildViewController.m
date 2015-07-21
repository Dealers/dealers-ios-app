//
//  TutorialChildViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 2/1/15.
//
//

#import "TutorialChildViewController.h"

@interface TutorialChildViewController ()

@end

@implementation TutorialChildViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    switch (self.index) {
        case 0:
            self.view.backgroundColor = [UIColor colorWithRed:79.0/250.0 green:195.0/250.0 blue:247.0/250.0 alpha:1.0];
            self.iPhoneImage.image = [UIImage imageNamed:@"Tutorial Feed"];
            self.featureIcon.image = [UIImage imageNamed:@"Tutorial Feed Icon"];
            self.explanation.text = NSLocalizedString(@"Find in your feed great deals that were shared by people like you", nil);
            self.screenName = @"Tutorial Feed Screen";
            break;
        case 1:
            self.view.backgroundColor = [UIColor colorWithRed:129.0/250.0 green:216.0/250.0 blue:132.0/250.0 alpha:1.0];
            self.iPhoneImage.image = [UIImage imageNamed:@"Personalize.png"];
            self.featureIcon.image = [UIImage imageNamed:@"Tutorial Personalize Icon"];
            self.explanation.text = NSLocalizedString(@"Personalize your feed by choosing your interests in your profile", nil);
            self.screenName = @"Tutorial Personalize Screen";
            break;
        case 2:
            self.view.backgroundColor = [UIColor colorWithRed:255.0/250.0 green:212.0/250.0 blue:40.0/250.0 alpha:1.0];
            self.iPhoneImage.image = [UIImage imageNamed:@"Add_Deal.png"];
            self.featureIcon.image = [UIImage imageNamed:@"Tutorial Add Deal Icon"];
            self.explanation.text = NSLocalizedString(@"Post deals that you find, and contirbute back to the community", nil);
            self.screenName = @"Tutorial Add Deal Screen";
            break;
        case 3:
            self.view.backgroundColor = [UIColor colorWithRed:255.0/250.0 green:115.0/250.0 blue:123.0/250.0 alpha:1.0];
            self.iPhoneImage.image = [UIImage imageNamed:NSLocalizedString(@"Score Screenshot", nil)];
            self.featureIcon.image = [UIImage imageNamed:@"Tutorial Score Icon"];
            self.explanation.text = NSLocalizedString(@"Gain points and move up in the ranks to have more influence", nil);
            self.screenName = @"Tutorial Score Screen";
            break;
        case 4:
            self.view.backgroundColor = [UIColor colorWithRed:190.0/250.0 green:158.0/250.0 blue:131.0/250.0 alpha:1.0];
            self.iPhoneImage.image = [UIImage imageNamed:@"Tutorial Likes"];
            self.featureIcon.image = [UIImage imageNamed:@"Tutorial Likes Icon"];
            self.explanation.text = NSLocalizedString(@"Like, comment and share deals, so others will know what's good", nil);
            self.screenName = @"Tutorial Likes Screen";
            break;
            
        default:
            break;
    }
}

@end
