//
//  TutorialViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 2/1/15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TutorialChildViewController.h"

@interface TutorialViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property AppDelegate *appDelegate;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic) UIPageViewController *pageController;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *gotItButton;

@property BOOL afterSignUp;
@property BOOL shouldPresentEnterButton;


- (IBAction)done:(id)sender;

@end
