//
//  ProfileTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/2/14.
//
//

#import "ProfileTableViewController.h"

#define DEALS_PHOTOS_NOTIFICATION @"Deals Photos In Profile Notifications"
#define NOTIFICATION_FIRST_TWO @"First Two Deals Photos In Profile Notifications"
#define PROFILE_PICTURE_NOTIFICATION @"Profile Picture Notifications"
#define NO_DEALS_TAG 54232543

#define SECTION_GAP 20.0
#define GAP 10.0
#define NO_PHOTO_BACKGROUND_HEIGHT 114.0
static NSString * const DealCellIdentifier = @"DealTableViewCell";

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Profile", nil);
    
    [self initialize];
    [self determineProfileMode];
    [self setNotificationObservers];
    [self setNavigationButtons];
    
    if (!self.dealer && self.dealerID) {
        
        [self downloadDealer];
        
    } else {
        
        [self setTopView];
        [self setLoadingDealsAnimation];
        [self setRefreshControl];
        [self downloadUploadedDeals];
        
        self.uploadedButton.selected = YES;
        self.currentDeals = self.uploadedDeals;
        self.likedButtonSelectionIndicator.alpha = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    if (appDelegate.shouldUpdateProfile) {
        [self refresh];
        appDelegate.shouldUpdateProfile = NO;
    }
    
    if (self.afterEditing) {
        [self setTopView];
        [self.tableView reloadData];
        if ([self.tableView viewWithTag:NO_DEALS_TAG]) {
            [[self.tableView viewWithTag:NO_DEALS_TAG] removeFromSuperview];
            [self noDealMessage];
        }
        self.afterEditing = NO;
    }
    
    if (self.tabBarController.tabBar.hidden == YES) {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    if ([self.profileMode isEqualToString:@"My Profile Tab"]) {
        [tracker set:kGAIScreenName value:@"My Profile Screen"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    } else {
        [tracker set:kGAIScreenName value:@"Other Profile Screen"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"Navigation Bar Shade"];
    if (self.path.length > 0) {
        [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodAny matchingPathPattern:self.path];
    }
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.uploadedDeals = [[NSMutableArray alloc]init];
    self.likedDeals = [[NSMutableArray alloc]init];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    isLoading = NO;
    isRefreshing = NO;
    self.afterEditing = NO;
}

- (void)determineProfileMode
{
    if ([[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        
        // This is the user's Profile Tab
        self.profileMode = @"My Profile Tab";
        self.dealer = appDelegate.dealer;
        
    } else if (self.appDelegate.dealer.dealerID.intValue == self.dealer.dealerID.intValue) {
        
        // This is the user's Profile view reached in another way
        self.profileMode = @"My Profile";
        
    } else {
        
        // This is another user's Profile view
        self.profileMode = @"Other Profile";
    }
    
    NSLog(@"/n Profile mode is: %@", self.profileMode);
}

- (void)setNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadPhotosInVisibleCells:)
                                                 name:DEALS_PHOTOS_NOTIFICATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(photoDownloaded:)
                                                 name:NOTIFICATION_FIRST_TWO
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadProfilePic:)
                                                 name:PROFILE_PICTURE_NOTIFICATION
                                               object:nil];
}

- (void)setNavigationButtons
{
    if ([self.profileMode isEqualToString:@"My Profile Tab"]) {
        
        UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings Button"]
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(pushSettingsView:)];
        [settings setImageInsets:UIEdgeInsetsMake(1, -5, -1, 5)];
        self.navigationItem.leftBarButtonItem = settings;
        
        UIBarButtonItem *invite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Invite Button"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pushInviteViewController:)];
        [invite setImageInsets:UIEdgeInsetsMake(1, -3, -1, 3)];
        
        UIBarButtonItem *personalize = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Personalize Button"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pushPersonalizeTableViewController:)];
//        [invite setImageInsets:UIEdgeInsetsMake(1, -3, -1, 3)];
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:invite, personalize, nil];
;

    }
}

- (void)downloadDealer
{
    [self setLoadingView];
    
    self.path = [NSString stringWithFormat:@"/dealers/%@/", self.dealerID];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:self.path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  self.dealer = mappingResult.firstObject;
                                                  
                                                  [self setTopView];
                                                  [self setLoadingDealsAnimation];
                                                  [self setRefreshControl];
                                                  [self downloadUploadedDeals];
                                                  
                                                  self.uploadedButton.selected = YES;
                                                  self.currentDeals = self.uploadedDeals;
                                                  self.likedButtonSelectionIndicator.alpha = 0;
                                                  
                                                  [self performSelector:@selector(stopLoadingAnimation) withObject:nil afterDelay:1.0];
                                                  [self stopLoadingDealsAnimation];
                                                  [self.refreshControl endRefreshing];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"Couldn't download dealer. Error: %@", error);
                                                  
                                                  [self stopLoadingAnimation];
                                                  
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedFailureReason
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                                  
                                                  [self stopLoadingDealsAnimation];
                                                  [self.refreshControl endRefreshing];
                                              }];
}

- (void)setTopView
{
    if (!self.topView) {
        self.topView = [[UIView alloc]init];
        self.topView.backgroundColor = [UIColor whiteColor];
    }
    
    // Dealer's info
    
    if (self.afterEditing) {
        self.profilePic.image = [appDelegate myProfilePic];
        
    } else {
        if (!self.profilePic.image) {
            
            self.profilePic = [[UIImageView alloc] init];
            
            if ([self.profileMode isEqualToString:@"My Profile Tab"]) {
                self.profilePic.image = [appDelegate myProfilePic];
                
            } else {
                if (self.dealer.photo) {
                    self.profilePic.image = [UIImage imageWithData:self.dealer.photo];
                } else {
                    self.profilePic.backgroundColor = [UIColor groupTableViewBackgroundColor];
                    [appDelegate otherProfilePic:self.dealer forTarget:nil notificationName:PROFILE_PICTURE_NOTIFICATION atIndexPath:nil];
                }
            }
        }
    }
    
    CGRect profilePicFrame = CGRectMake(0, GAP, 80.0, 80.0);
    profilePicFrame.origin.x = self.tableView.center.x - profilePicFrame.size.width / 2;
    self.profilePic.frame = profilePicFrame;
    self.profilePic.layer.cornerRadius = profilePicFrame.size.width / 2;
    self.profilePic.layer.masksToBounds = YES;
    self.profilePic.contentMode = UIViewContentModeScaleAspectFill;
    [self.topView addSubview:self.profilePic];
    
    self.profilePicPlaceholder = [[UIView alloc]initWithFrame:self.profilePic.frame];
    self.profilePicPlaceholder.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.profilePicPlaceholder.layer.cornerRadius = profilePicFrame.size.width / 2;
    self.profilePicPlaceholder.layer.masksToBounds = YES;
    [self.topView insertSubview:self.profilePicPlaceholder belowSubview:self.profilePic];
    
    lowestYPoint = CGRectGetMaxY(self.profilePic.frame) + GAP;
    
    if (!self.fullName) {
        self.fullName = [[UILabel alloc]initWithFrame:CGRectMake(0, lowestYPoint, self.tableView.frame.size.width, 22.0)];
        self.fullName.textAlignment = NSTextAlignmentCenter;
        self.fullName.font = [UIFont fontWithName:@"Avenir-Heavy" size:20.0];
        self.fullName.textColor = [appDelegate blackColor];
        [self.topView addSubview:self.fullName];
    }
    self.fullName.text = self.dealer.fullName;
    
    lowestYPoint = CGRectGetMaxY(self.fullName.frame) + GAP;
    
    if (!self.rank) {
        self.rank = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.rank setFrame:CGRectMake(0, lowestYPoint, self.tableView.frame.size.width, 22.0)];
        [[self.rank titleLabel] setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
        [self.rank addTarget:self action:@selector(scoreAndStats:) forControlEvents:UIControlEventTouchUpInside];
        self.rank.adjustsImageWhenHighlighted = NO;
        [self.topView addSubview:self.rank];
    }
    [self.rank setTitle:NSLocalizedString(self.dealer.rank, nil) forState:UIControlStateNormal];
    [self.rank sizeToFit];
    
    if (self.rankIcon) {
        [self.rankIcon removeFromSuperview];
    }
    
    self.rankIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setIconForRank:self.dealer.rank];
    self.rankIcon.adjustsImageWhenHighlighted = NO;
    [self.topView addSubview:self.rankIcon];
    
    [self setRankAndIconXValues];
    
    lowestYPoint = CGRectGetMaxY(self.rank.frame);
    
    if (self.location) {
        [self.location removeFromSuperview];
        [self.locationIcon removeFromSuperview];
    }
    
    if (self.dealer.location.length > 0 && ![self.dealer.location isEqualToString:@"None"]) {
        
        self.location = [[UILabel alloc]initWithFrame:CGRectMake(0, lowestYPoint + GAP - 4, self.tableView.frame.size.width, 18.0)];
        self.location.text = self.dealer.location;
        self.location.textAlignment = NSTextAlignmentCenter;
        self.location.font = [UIFont fontWithName:@"Avenir-Roman" size:16.0];
        [self.location sizeToFit];
        
        CGRect locationFrame = self.location.frame;
        locationFrame.origin.x = self.tableView.center.x - self.location.frame.size.width / 2 + 7;
        self.location.frame = locationFrame;
        
        self.location.textColor = [appDelegate blackColor];
        [self.topView addSubview:self.location];
        
        if (self.locationIcon) {
            [self.locationIcon removeFromSuperview];
        }
        
        self.locationIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Store Address Black Icon"]];
        self.locationIcon.frame = CGRectMake(0, 0, 14.0, 14.0);
        self.locationIcon.center = self.location.center;
        CGRect locationIconFrame = self.locationIcon.frame;
        locationIconFrame.origin.x = self.location.frame.origin.x - self.locationIcon.frame.size.width - 5;
        locationIconFrame.origin.y -= 1;
        self.locationIcon.frame = locationIconFrame;
        [self.topView addSubview:self.locationIcon];
        
        lowestYPoint = CGRectGetMaxY(self.location.frame);
        
    }
    
    if (self.about) {
        [self.about removeFromSuperview];
    }
    
    if (self.dealer.about.length > 0 && ![self.dealer.about isEqualToString:@"None"]) {
        
        if (self.about) {
            [self.about removeFromSuperview];
        }
        
        self.about = [[UITextView alloc]init];
        self.about.text = self.dealer.about;
        CGSize maxSize = CGSizeMake(self.tableView.frame.size.width - 40.0, CGFLOAT_MAX);
        self.about.textAlignment = NSTextAlignmentCenter;
        self.about.font = [UIFont fontWithName:@"Avenir-Roman" size:16.0];
        self.about.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize aboutSize = [self.about sizeThatFits:maxSize];
        self.about.frame = CGRectMake(20.0, lowestYPoint + 2.0, maxSize.width, aboutSize.height);
        self.about.textColor = [appDelegate blackColor];
        self.about.editable = NO;
        self.about.scrollEnabled = NO;
        self.about.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.topView addSubview:self.about];
        
        lowestYPoint = CGRectGetMaxY(self.about.frame);
    }
    
    lowestYPoint += GAP * 2.5;
    
    // Uploaded deals or Liked deals segmented controller
    
    //    if (self.separatorHorizontal) {
    //        [self.separatorHorizontal removeFromSuperview];
    //        [self.separatorVertical removeFromSuperview];
    //    }
    //    self.separatorHorizontal = [[UIView alloc]initWithFrame:CGRectMake(0, lowestYPoint, self.tableView.frame.size.width, 0.5)];
    //    self.separatorHorizontal.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:225.0/255.0 alpha:1.0];
    //    [self.topView addSubview:self.separatorHorizontal];
    //    self.separatorVertical = [[UIView alloc]initWithFrame:CGRectMake(self.tableView.center.x, lowestYPoint, 0.5, 48.0)];
    //    self.separatorVertical.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:225.0/255.0 alpha:1.0];
    //    [self.topView addSubview:self.separatorVertical];
    
    if (!self.uploadedButton) {
        self.uploadedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.uploadedButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:18.0]];
        [self.uploadedButton setTitleColor:[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:195.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.uploadedButton setTitleColor:[appDelegate ourPurple] forState:UIControlStateSelected];
        [self.uploadedButton setBackgroundColor:[UIColor whiteColor]];
        [self.uploadedButton addTarget:self action:@selector(showPosts) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:self.uploadedButton];
    }
    
    [self.uploadedButton setFrame:CGRectMake(0, lowestYPoint, self.tableView.frame.size.width / 2, 48.0)];
    [self.uploadedButton setTitle:NSLocalizedString(@"Posts", nil) forState:UIControlStateNormal];
    
    
    //    if (self.dealer.uploadedDeals.count > 0) {
    //        [self.uploadedButton setTitle:[NSString stringWithFormat:@"%@ Posts", [NSNumber numberWithUnsignedInteger:self.dealer.uploadedDeals.count]]
    //                             forState:UIControlStateNormal];
    //    } else {
    //        [self.uploadedButton setTitle:@"Posts" forState:UIControlStateNormal];
    //    }
    
    //    if (!self.uploadedButtonSelectionIndicator) {
    //        CGFloat uploadedX = self.uploadedButton.frame.origin.x + 20.0;
    //        CGFloat uploadedWidth = self.uploadedButton.frame.size.width - 40.0;
    //        CGFloat uploadedHeight = 4.0;
    //        CGFloat uploadedY = CGRectGetMaxY(self.uploadedButton.frame) - uploadedHeight;
    //        self.uploadedButtonSelectionIndicator = [[UIView alloc]initWithFrame:CGRectMake(uploadedX, uploadedY, uploadedWidth, uploadedHeight)];
    //        self.uploadedButtonSelectionIndicator.backgroundColor = [appDelegate ourPurple];
    //        self.uploadedButtonSelectionIndicator.layer.cornerRadius = 2.0;
    //        self.uploadedButtonSelectionIndicator.layer.masksToBounds = YES;
    //        [self.topView addSubview:self.uploadedButtonSelectionIndicator];
    //    }
    //
    //    CGRect frame = self.uploadedButtonSelectionIndicator.frame;
    //    frame.origin.y = CGRectGetMaxY(self.uploadedButton.frame) - self.uploadedButtonSelectionIndicator.frame.size.height;
    //    self.uploadedButtonSelectionIndicator.frame = frame;
    
    if (!self.likedButton) {
        self.likedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.likedButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:18.0]];
        [self.likedButton setTitleColor:[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:195.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.likedButton setTitleColor:[appDelegate ourPurple] forState:UIControlStateSelected];
        [self.likedButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.likedButton addTarget:self action:@selector(showLikes) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:self.likedButton];
    }
    
    [self.likedButton setFrame:CGRectMake(self.tableView.frame.size.width / 2, lowestYPoint, self.tableView.frame.size.width / 2, 48.0)];
    [self.likedButton setTitle:NSLocalizedString(@"Likes", nil) forState:UIControlStateNormal];
    
    //    if (self.dealer.likedDeals.count > 0) {
    //        [self.likedButton setTitle:[NSString stringWithFormat:@"%@ Likes", [NSNumber numberWithUnsignedInteger:self.dealer.likedDeals.count]]
    //                          forState:UIControlStateNormal];
    //    } else {
    //        [self.likedButton setTitle:@"Likes" forState:UIControlStateNormal];
    //    }
    
    //    if (!self.likedButtonSelectionIndicator) {
    //        CGFloat likedX = self.likedButton.frame.origin.x + 20.0;
    //        CGFloat likedHeight = 4.0;
    //        CGFloat likedWidth = self.likedButton.frame.size.width - 40.0;
    //        CGFloat likedY = CGRectGetMaxY(self.likedButton.frame) - likedHeight;
    //        self.likedButtonSelectionIndicator = [[UIView alloc]initWithFrame:CGRectMake(likedX, likedY, likedWidth, likedHeight)];
    //        self.likedButtonSelectionIndicator.backgroundColor = [appDelegate ourPurple];
    //        self.likedButtonSelectionIndicator.layer.cornerRadius = 2.0;
    //        self.likedButtonSelectionIndicator.layer.masksToBounds = YES;
    //        [self.topView addSubview:self.likedButtonSelectionIndicator];
    //    }
    //
    //    frame = self.likedButtonSelectionIndicator.frame;
    //    frame.origin.y = CGRectGetMaxY(self.likedButton.frame) - self.likedButtonSelectionIndicator.frame.size.height;
    //    self.likedButtonSelectionIndicator.frame = frame;
    
    lowestYPoint = CGRectGetMaxY(self.uploadedButton.frame);
    self.topView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, lowestYPoint);
    
    self.tableView.tableHeaderView = self.topView;
}

- (void)setIconForRank:(NSString *)rank
{
    
    if ([rank isEqualToString:@"Viewer"]) {
        self.rankIcon.frame = CGRectMake(0, 0, 10.0, 10.0);
        [self.rankIcon setImage:[UIImage imageNamed:@"Mini Viewer Icon"] forState:UIControlStateNormal];
    } else if ([rank isEqualToString:@"Dealer"]) {
        self.rankIcon.frame = CGRectMake(0, 0, 19.0, 10.0);
        [self.rankIcon setImage:[UIImage imageNamed:@"Mini Dealer Icon"] forState:UIControlStateNormal];
    } else if ([rank isEqualToString:@"Pro Dealer"]) {
        self.rankIcon.frame = CGRectMake(0, 0, 18.0, 15.0);
        [self.rankIcon setImage:[UIImage imageNamed:@"Mini Pro Dealer Icon"] forState:UIControlStateNormal];
    } else if ([rank isEqualToString:@"Senior Dealer"]) {
        self.rankIcon.frame = CGRectMake(0, 0, 18.0, 18.0);
        [self.rankIcon setImage:[UIImage imageNamed:@"Mini Senior Dealer Icon"] forState:UIControlStateNormal];
    } else if ([rank isEqualToString:@"Master Dealer"]) {
        self.rankIcon.frame = CGRectMake(0, 0, 19.0, 18.0);
        [self.rankIcon setImage:[UIImage imageNamed:@"Mini Master Dealer Icon"] forState:UIControlStateNormal];
    }
    
}

- (void)setRankAndIconXValues
{
    CGRect rankFrame = self.rank.frame;
    rankFrame.origin.x = self.tableView.center.x - self.rank.frame.size.width / 2 + self.rankIcon.frame.size.width / 2;
    self.rank.frame = rankFrame;
    
    self.rankIcon.center = self.rank.center;
    CGRect rankIconFrame = self.rankIcon.frame;
    rankIconFrame.origin.x = self.rank.frame.origin.x - self.rankIcon.frame.size.width - 6;
    rankIconFrame.origin.y -= 1;
    self.rankIcon.frame = rankIconFrame;
}

- (void)scoreAndStats:(id)sender
{
    ScoreAndStatsViewController *sasvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreAndStats"];
    sasvc.dealer = self.dealer;
    if ([self.profileMode isEqualToString:@"Other Profile"]) {
        sasvc.isMyStats = NO;
    } else {
        sasvc.isMyStats = YES;
    }
    [self.navigationController pushViewController:sasvc animated:YES];
}

- (void)pushSettingsView:(id)sender
{
    SettingsTableViewController *stvc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsID"];
    [self.navigationController pushViewController:stvc animated:YES];
}

- (void)showPosts
{
    if (!self.uploadedButton.selected) {
        
        self.uploadedButton.selected = YES;
        self.likedButton.selected = NO;
        self.uploadedButton.backgroundColor = [UIColor whiteColor];
        self.likedButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        if (didDownloadUploadedDeals) {
            self.currentDeals = self.uploadedDeals;
            [self.tableView reloadData];
            
        } else {
            [self setLoadingDealsAnimation];
            [self downloadUploadedDeals];
            [self.tableView reloadData];
        }
    }
    
    if ([whatIsLoading isEqualToString:@"uploaded"]) {
        self.loadingDealsAnimation.hidden = NO;
        if (didDownloadUploadedDeals) {
            [self stopLoadingDealsAnimation];
        }
    } else if ([whatIsLoading isEqualToString:@"liked"]) {
        self.loadingDealsAnimation.hidden = YES;
    }
}

- (void)showLikes
{
    if (!self.likedButton.selected) {
        
        self.likedButton.selected = YES;
        self.uploadedButton.selected = NO;
        self.likedButton.backgroundColor = [UIColor whiteColor];
        self.uploadedButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        self.currentDeals = self.likedDeals;
        
        if (didDownloadLikedDeals) {
            [self.tableView reloadData];
            
        } else {
            [self setLoadingDealsAnimation];
            [self downloadLikedDeals];
            [self.tableView reloadData];
        }
    }
    
    if ([whatIsLoading isEqualToString:@"liked"]) {
        self.loadingDealsAnimation.hidden = NO;
        if (didDownloadLikedDeals) {
            [self stopLoadingDealsAnimation];
        }
    } else if ([whatIsLoading isEqualToString:@"uploaded"]) {
        self.loadingDealsAnimation.hidden = YES;
    }
}

- (void)setRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [appDelegate ourPurple];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)refresh
{
    isRefreshing = YES;
    didDownloadUploadedDeals = NO;
    didDownloadLikedDeals = NO;
    [self.uploadedDeals removeAllObjects];
    [self.likedDeals removeAllObjects];
    self.tableView.backgroundView = [[UIView alloc] init];
    
    if (self.uploadedButton.selected) {
        [self downloadUploadedDeals];
    } else {
        [self downloadLikedDeals];
    }
    
    if (![self.profileMode isEqualToString:@"Other Profile"]) {
        self.dealer = appDelegate.dealer;
    }
    
    [self setTopView];
    [self setSegementedButtonsState];
}

- (void)setSegementedButtonsState
{
    if (self.uploadedButton.selected) {
        self.uploadedButtonSelectionIndicator.alpha = 1.0;
        self.likedButtonSelectionIndicator.alpha = 0;
    } else {
        self.likedButtonSelectionIndicator.alpha = 1.0;
        self.uploadedButtonSelectionIndicator.alpha = 0;
    }
}

- (void)downloadUploadedDeals
{
    NSString *path = [NSString stringWithFormat:@"/uploadeddeals/%@/", self.dealer.dealerID];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  [self.uploadedDeals removeAllObjects];
                                                  [self.uploadedDeals addObjectsFromArray:mappingResult.array];
                                                  
                                                  if (!self.uploadedDeals || self.uploadedDeals.count == 0) {
                                                      [self noDealMessage];
                                                      [self stopLoadingDealsAnimation];
                                                      
                                                  } else {
                                                      [self loadFirstTwoPhotos];
                                                  }
                                                  
                                                  didDownloadUploadedDeals = YES;
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Error: %@", error);
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                                                  message:error.localizedFailureReason
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                                  [self stopLoadingDealsAnimation];
                                                  [self.refreshControl endRefreshing];
                                              }];
}

- (void)downloadLikedDeals
{
    NSString *path = [NSString stringWithFormat:@"/likeddeals/%@/", self.dealer.dealerID];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSArray *temp = mappingResult.array;
                                                  [self.likedDeals removeAllObjects];
                                                  
                                                  for (DealAttrib *dealAttrib in temp) {
                                                      [self.likedDeals insertObject:dealAttrib.deal atIndex:0];
                                                  }
                                                  
                                                  if (!self.likedDeals || self.likedDeals.count == 0) {
                                                      [self noDealMessage];
                                                      [self stopLoadingDealsAnimation];
                                                      
                                                  } else {
                                                      [self loadFirstTwoPhotos];
                                                  }
                                                  
                                                  didDownloadLikedDeals = YES;
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Error: %@", error);
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                                  [self stopLoadingDealsAnimation];
                                                  [self.refreshControl endRefreshing];
                                              }];
}

- (void)loadFirstTwoPhotos
{
    if (self.currentDeals.count > 0) {
        
        for (int i = 0; i < self.currentDeals.count; i++) {
            
            Deal *deal = [self.currentDeals objectAtIndex:i];
            
            if (deal.photoURL1.length > 2 && ![deal.photoURL1 isEqualToString:@"None"]) {
                deal.downloadingPhoto = YES;
                [appDelegate downloadPhotosForDeal:deal notificationName:NOTIFICATION_FIRST_TWO atIndexPath:nil mode:nil];
            } else {
                [self photoDownloaded:nil];
            }
            
            if (i == 1) {
                // Breaking after 2 photos have been downloaded
                break;
            }
        }
        
    } else {
        
        NSLog(@"No deals in the array, so no photos...");
        [self.refreshControl endRefreshing];
    }
}

- (void)photoDownloaded:(NSNotification *)notification
{
    firstPhotosCounter++;
    if (firstPhotosCounter == 2 || firstPhotosCounter == self.currentDeals.count) {
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             self.loadingDealsAnimation.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         }
                         completion:^(BOOL finished) {
                             self.loadingDealsAnimation.alpha = 0;
                             [self reloadTableView];
                         }];
    }
}

- (void)reloadTableView
{
    [self.tableView reloadData];
    
    if ([self.tableView viewWithTag:NO_DEALS_TAG]) {
        [[self.tableView viewWithTag:NO_DEALS_TAG] removeFromSuperview];
    }
    
    [self stopLoadingDealsAnimation];
    
    if (isRefreshing) {
        [self.refreshControl endRefreshing];
        isRefreshing = NO;
    }
    
    // Load photo of next deal in the array
    [self downloadNextPhotoAfterIndexPath:[NSIndexPath indexPathForRow:firstPhotosCounter - 1 inSection:0]];
    firstPhotosCounter = 0;
}

- (void)setLoadingView
{
    isLoading = YES;
    
    if (self.tableView.contentSize.height > 0) {
        
        loadingView = [[UIView alloc]initWithFrame:CGRectMake(self.tableView.frame.origin.x,
                                                              self.tableView.frame.origin.y,
                                                              self.tableView.contentSize.width,
                                                              self.tableView.contentSize.height)];
    } else {
        
        loadingView = [[UIView alloc]initWithFrame:self.view.frame];
    }
    
    loadingView.backgroundColor = [UIColor whiteColor];
    UIImageView *loadingAnimation = [appDelegate loadingAnimationPurple];
    loadingAnimation.tag = 13212;
    [loadingAnimation startAnimating];
    loadingAnimation.frame = CGRectMake(self.view.center.x - 15.0, 15.0, 30.0, 30.0);
    [loadingView addSubview:loadingAnimation];
    [self.tableView addSubview:loadingView];
}

- (void)stopLoadingAnimation
{
    UIImageView *loadingAnimation = (UIImageView *)[loadingView viewWithTag:13212];
    [loadingAnimation stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{ loadingView.alpha = 0; }];
    
    isLoading = NO;
}

- (void)setLoadingDealsAnimation
{
    if (!isRefreshing && !self.loadingDealsAnimation) {
        
        self.loadingDealsAnimation = [appDelegate loadingAnimationPurple];
        CGRect loadingFrame = self.loadingDealsAnimation.frame;
        loadingFrame.origin.x = self.tableView.center.x - loadingFrame.size.width / 2;
        loadingFrame.origin.y = lowestYPoint + 15.0;
        self.loadingDealsAnimation.frame = loadingFrame;
        [self.loadingDealsAnimation startAnimating];
        [self.tableView addSubview:self.loadingDealsAnimation];
        
        if (self.uploadedButton.selected) {
            whatIsLoading = @"uploaded";
        } else {
            whatIsLoading = @"liked";
        }
    }
}


- (void)stopLoadingDealsAnimation
{
    [self.loadingDealsAnimation stopAnimating];
    self.loadingDealsAnimation.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [self.loadingDealsAnimation removeFromSuperview];
    self.loadingDealsAnimation = nil;
    whatIsLoading = nil;
}

- (void)noDealMessage
{
    if ([self.tableView viewWithTag:NO_DEALS_TAG]) {
        [[self.tableView viewWithTag:NO_DEALS_TAG] removeFromSuperview];
    }
    
    CGFloat originY = self.topView.frame.size.height + 50.0;
    UILabel *noDealsMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, originY, self.tableView.frame.size.width, 20.0)];
    [noDealsMessage setFont:[UIFont fontWithName:@"Avenir-Roman" size:18.0]];
    [noDealsMessage setTextAlignment:NSTextAlignmentCenter];
    noDealsMessage.numberOfLines = 0;
    noDealsMessage.text = NSLocalizedString(@"There are no deals at this moment!", nil);
    noDealsMessage.textColor = [appDelegate textGrayColor];
    noDealsMessage.alpha = 0;
    noDealsMessage.tag = NO_DEALS_TAG;
    
    if (isRefreshing) {
        [self.refreshControl endRefreshing];
        isRefreshing = NO;
    }
    
    [self.tableView insertSubview:noDealsMessage atIndex:0];
    
    [UIView animateWithDuration:0.3 animations:^{ noDealsMessage.alpha = 1.0; }];
}

- (void)loadPhotosInVisibleCells:(NSNotification *)notification
{
    if ([[notification.userInfo objectForKey:@"mode"] isEqualToString:self.profileMode]) {
        
        NSArray *indexPathes = [self.tableView indexPathsForVisibleRows];
        
        NSIndexPath *receivedIndexPath = [notification.userInfo objectForKey:@"indexPath"];
        
        for (int i = 0; i < indexPathes.count; i++) {
            
            if ([indexPathes[i] isEqual:receivedIndexPath]) {
                
                DealTableViewCell *cell = (DealTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPathes[i]];
                
                cell.photo.image = [notification.userInfo objectForKey:@"image"];
                cell.photo = [appDelegate contentModeForImageView:cell.photo];
                [UIView animateWithDuration:0.5 animations:^{ cell.photo.alpha = 1.0; }];
                break;
            }
        }
        
        // Load photo of next deal in the array
        [self downloadNextPhotoAfterIndexPath:receivedIndexPath];
    }
}

- (void)downloadNextPhotoAfterIndexPath:(NSIndexPath *)indexPath
{
    for (NSInteger i = indexPath.row + 1; i < self.currentDeals.count; i++) {
        
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        Deal *nextDeal = [self.currentDeals objectAtIndex:nextIndexPath.row];
        
        if (nextDeal.photoURL1.length > 2 && ![nextDeal.photoURL1 isEqualToString:@"None"]) {
            if (!nextDeal.photo1 && !nextDeal.downloadingPhoto) {
                nextDeal.downloadingPhoto = YES;
                [appDelegate downloadPhotosForDeal:nextDeal notificationName:DEALS_PHOTOS_NOTIFICATION atIndexPath:nextIndexPath mode:nil];
                break;
            }
        } else {
            continue;
        }
    }
}

- (void)loadProfilePic:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    if (!self.profilePic.image) {
        self.profilePic.image = [userInfo objectForKey:@"image"];
        self.profilePic.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{ self.profilePic.alpha = 1.0; }];
    }
}

- (void)pushInviteViewController:(id)sender
{
    InviteViewController *ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"Invite"];
    [self.navigationController pushViewController:ivc animated:YES];
}

- (void)pushPersonalizeTableViewController:(id)sender
{
    PersonalizeTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Personalize"];
    [self.navigationController pushViewController:ptvc animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSArray *visibleIndexPathes = self.tableView.indexPathsForVisibleRows;
    
    for (NSIndexPath *indexPath in visibleIndexPathes) {
        
        if ([[self.tableView cellForRowAtIndexPath:indexPath] isMemberOfClass:[DealTableViewCell class]]) {
            
            if (indexPath.row >= self.currentDeals.count) {
                return;
            }
              
            DealTableViewCell *cell = (DealTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            Deal *deal = [self.currentDeals objectAtIndex:indexPath.row];
            
            if (deal.photo1 && cell.photo.alpha == 0) {
                [UIView animateWithDuration:0.5 animations:^{ cell.photo.alpha = 1.0; }];
            }
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.uploadedButton.selected) {
        return self.uploadedDeals.count;
    } else {
        return self.likedDeals.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self dealCellForIndexPath:indexPath];
}

- (DealTableViewCell *)dealCellForIndexPath:(NSIndexPath *)indexPath
{
    DealTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DealCellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(DealTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Deal *deal = self.currentDeals[indexPath.row];
    
    cell.title.text = deal.title;
    cell.store.text = deal.store.name;
    if ([deal.type isEqualToString:@"Online"]) {
        cell.storeIcon.image = [UIImage imageNamed:@"Online Icon Gray"];
    } else {
        cell.storeIcon.image = [UIImage imageNamed:@"Local Icon Gray"];
    }
    
    [self prepareDeal:deal];
    [self checkIfHasImageForCell:cell deal:deal indexPath:indexPath];
    [self checkIfDealExpiredForCell:cell deal:deal];
    [self setPriceAndDiscountForCell:cell deal:deal];
    [self setLikesCounterForCell:cell deal:deal];
}

- (Deal *)prepareDeal:(Deal *)deal
{
    if (!deal.photoSum) {
        deal.photoSum = [appDelegate setPhotoSum:deal];
    }
    
    if (deal.currency.length == 2) {
        deal.currency = [appDelegate getCurrencySign:deal.currency];
    }
    
    if (deal.discountType.length == 2) {
        deal.discountType = [appDelegate getDiscountType:deal.discountType];
    }
    
    return deal;
}

- (void)checkIfHasImageForCell:(DealTableViewCell *)cell deal:(Deal *)deal indexPath:(NSIndexPath *)indexPath
{
    if (deal.photoURL1.length > 2 && ![deal.photoURL1 isEqualToString:@"None"]) {
        CGFloat imageWidth = [UIScreen mainScreen].bounds.size.width;
        cell.photoHeightConstraint.constant = imageWidth * 0.678125; // 217:320 ratio
        cell.photo.backgroundColor = [UIColor whiteColor];
        [self setImageForCell:cell deal:deal indexPath:indexPath];
    } else {
        cell.photoHeightConstraint.constant = NO_PHOTO_BACKGROUND_HEIGHT;
        cell.photo.backgroundColor = [DealTableViewCell randomBackgroundColors:deal.photoURL1];
        cell.photo.image = nil;
    }
}

- (void)setImageForCell:(DealTableViewCell *)cell deal:(Deal *)deal indexPath:(NSIndexPath *)indexPath
{
    if (!deal.photo1) {
        cell.photo.alpha = 0;
        if (!deal.downloadingPhoto) {
            deal.downloadingPhoto = YES;
            [appDelegate downloadPhotosForDeal:deal notificationName:DEALS_PHOTOS_NOTIFICATION atIndexPath:indexPath mode:nil];
        }
    } else {
        cell.photo.alpha = 1.0;
        cell.photo.image = deal.photo1;
        cell.photo = [appDelegate contentModeForImageView:cell.photo];
    }
}

- (void)checkIfDealExpiredForCell:(DealTableViewCell *)cell deal:(Deal *)deal
{
    if (deal.expiration) {
        if ([appDelegate didDealExpired:deal]) {
            cell.expiredTag.hidden = NO;
        } else {
            cell.expiredTag.hidden = YES;
        }
    } else {
        cell.expiredTag.hidden = YES;
    }
}

- (void)setPriceAndDiscountForCell:(DealTableViewCell *)cell deal:(Deal *)deal
{
    CGFloat priceDiscountHorizontalConstant = 12.0;
    
    if (deal.price.floatValue > 0) {
        cell.priceAndDiscountContainer.hidden = NO;
        cell.price.text = [deal.currency stringByAppendingString:deal.price.stringValue];
    } else {
        cell.price.text = nil;
    }
    
    if (deal.discountValue.floatValue > 0) {
        cell.discount.hidden = NO;
        if ([deal.discountType isEqualToString:@"%"]) {
            cell.discount.text = [deal.discountValue.stringValue stringByAppendingString:deal.discountType];
        } else if ([deal.discountType isEqualToString:@"lastPrice"]){
            NSDictionary *attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
            NSString *lastPriceDiscount = [deal.currency stringByAppendingString:deal.discountValue.stringValue];
            NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:lastPriceDiscount attributes:attributes];
            cell.discount.attributedText = attrText;
        }
    } else {
        cell.discount.text = nil;
    }
    
    if (!cell.price.text && !cell.discount.text) {
        cell.priceAndDiscountContainer.hidden = YES;
    } else if (cell.price.text && cell.discount.text) {
        cell.priceAndDiscountContainer.hidden = NO;
        cell.priceDiscountHorizontalConstraint.constant = priceDiscountHorizontalConstant;
    } else {
        cell.priceAndDiscountContainer.hidden = NO;
        cell.priceDiscountHorizontalConstraint.constant = 0;
    }
}

- (void)setLikesCounterForCell:(DealTableViewCell *)cell deal:(Deal *)deal
{
    if (deal.dealAttrib.dealersThatLiked.count > 0) {
        cell.likesStoreVerticalConstraint.constant = 4.0;
        cell.likesIconHeightConstraint.constant = 15.0;
        cell.likesCounterHeightConstraint.constant = 21.0;
        NSString *likes = [NSNumber numberWithUnsignedInteger:deal.dealAttrib.dealersThatLiked.count].stringValue;
        cell.likesCounter.text = [NSString stringWithFormat:NSLocalizedString(@"%@ Likes", nil), likes];
        
    } else {
        cell.likesStoreVerticalConstraint.constant = 0;
        cell.likesIconHeightConstraint.constant = 0;
        cell.likesCounterHeightConstraint.constant = 0;
        cell.likesCounter.text = nil;
    }
}

- (void)setSeparatorForLastCell:(DealTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    NSInteger lastDeal = self.currentDeals.count - 1;
    if (indexPath.row == lastDeal) {
        cell.separator.alpha = 0.25;
    } else {
        cell.separator.alpha = 1.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellAtIndexPath:indexPath];
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    static DealTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:DealCellIdentifier];
        if (!sizingCell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealTableViewCell" owner:nil options:nil];
            sizingCell = [nib objectAtIndex:0];
        }
    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewDealViewController *vdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewDealID"];
    Deal *deal;
    if (self.uploadedButton.selected) {
        deal = [self.uploadedDeals objectAtIndex:indexPath.row];
    } else {
        deal = [self.likedDeals objectAtIndex:indexPath.row];
    }
    vdvc.deal = deal;
    vdvc.delegate = self;
    vdvc.dealIndexPath = indexPath;
    
    [self.navigationController pushViewController:vdvc animated:YES];
}


@end
