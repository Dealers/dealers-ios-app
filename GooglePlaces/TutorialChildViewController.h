//
//  TutorialChildViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 2/1/15.
//
//

#import <UIKit/UIKit.h>

@interface TutorialChildViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UIImageView *iPhoneImage;
@property (weak, nonatomic) IBOutlet UIView *explanationContainer;
@property (weak, nonatomic) IBOutlet UIImageView *featureIcon;
@property (weak, nonatomic) IBOutlet UILabel *explanation;

@end
