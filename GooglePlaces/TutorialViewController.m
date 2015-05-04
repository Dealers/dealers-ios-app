//
//  TutorialViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 2/1/15.
//
//

#import "TutorialViewController.h"

#define CHILD_SCREENS_COUNT 5

@interface TutorialViewController ()

@end

@implementation TutorialViewController

@synthesize appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
        
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [self.pageController.view setFrame:self.view.bounds];
    
    [self getPageControllerScrollView];
    [self setButtons];
    
    TutorialChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self.view insertSubview:self.pageController.view belowSubview:self.skipButton];
    [self.pageController didMoveToParentViewController:self];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (!self.afterSignUp) {
        [appDelegate hidePlusButton];
    }
    
    self.skipButton.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{ self.skipButton.alpha = 1.0; }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (!self.afterSignUp) {
        [appDelegate showPlusButton];
    }
}

- (void)getPageControllerScrollView
{
    for (id subview in self.pageController.view.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)subview setDelegate:self];
            break;
        }
    }
}

- (void)setButtons
{
    if (self.afterSignUp) {
        [self.skipButton setTitle:NSLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
        [self.skipButton setTintColor:[UIColor lightGrayColor]];
        
    } else {
        [self.skipButton setTitle:NSLocalizedString(@"Got it", nil) forState:UIControlStateNormal];
        self.skipButton.layer.cornerRadius = 6.0;
        self.skipButton.layer.masksToBounds = YES;
        self.skipButton.layer.borderWidth = 1.5;
        self.skipButton.layer.borderColor = [[appDelegate ourPurple] CGColor];
    }
    
    [self.gotItButton setTitle:NSLocalizedString(@"Got it", nil) forState:UIControlStateNormal];
    self.gotItButton.frame = self.skipButton.frame;
    self.gotItButton.layer.cornerRadius = 6.0;
    self.gotItButton.layer.masksToBounds = YES;
    self.gotItButton.alpha = 0;
    self.gotItButton.hidden = YES;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(TutorialChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(TutorialChildViewController *)viewController index];
    
    index++;
    
    if (index == CHILD_SCREENS_COUNT) {
        return nil;
    }
        
    return [self viewControllerAtIndex:index];
}

- (TutorialChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    TutorialChildViewController *childViewController = [[TutorialChildViewController alloc] initWithNibName:@"TutorialChildViewController" bundle:nil];
    childViewController.index = index;
    
    return childViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return CHILD_SCREENS_COUNT;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed && self.afterSignUp) {
        NSUInteger currentIndex = [[self.pageController.viewControllers lastObject] index];
        if (currentIndex == CHILD_SCREENS_COUNT - 1) {
            
            if (self.gotItButton.hidden) {
                
                self.gotItButton.hidden = NO;
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     self.skipButton.alpha = 0;
                                 }
                                 completion:^(BOOL finished) {
                                     self.skipButton.hidden = YES;
                                     [UIView animateWithDuration:0.3 animations:^{
                                         self.gotItButton.alpha = 1.0;
                                     }];
                                 }];
            }
            
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}


- (IBAction)done:(id)sender
{
    if (self.afterSignUp) {
        
        [appDelegate setTabBarController];
        [appDelegate saveUserDetailsOnDevice];
    
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
