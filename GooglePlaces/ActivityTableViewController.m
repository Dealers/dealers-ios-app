//
//  ActivityTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/11/14.
//
//

#import "ActivityTableViewController.h"

#define NAME_FOR_NOTIFICATIONS @"Notifications Photos Notifications"
static NSString * const NotificationCellIdentifier = @"NotificationTableViewCell";


@implementation ActivityTableViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Activity", nil);
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Set Invite button
    UIBarButtonItem *invite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Invite Button"]
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(pushInviteViewController:)];
    [invite setImageInsets:UIEdgeInsetsMake(1, -3, -1, 3)];
    self.navigationItem.rightBarButtonItem = invite;
    
    [self setNotificationObservers];
    [self setTableViewSettings];
    [self setRefreshControl];
    [self setDateFormatter];
    [self downloadNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [appDelegate resetBadgeCounter];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Activity Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadPhotosToView:)
                                                 name:NAME_FOR_NOTIFICATIONS
                                               object:nil];
}

- (void)setTableViewSettings
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)pushInviteViewController:(id)sender
{
    InviteViewController *ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"Invite"];
    [self.navigationController pushViewController:ivc animated:YES];
}

- (void)downloadNotifications
{
    NSString *path = [NSString stringWithFormat:@"/dealernotifications/%@/", appDelegate.dealer.dealerID];
    
    [self setLoadingView];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSLog(@"Notifications downloaded successfully!");
                                                  
                                                  self.notifications = [NSMutableArray arrayWithArray:mappingResult.array];
                                                  
                                                  [self.refreshControl endRefreshing];
                                                  
                                                  if (self.notifications.count > 0) {
                                                      [self removeDuplicates];
                                                      [self mergeNotifications];
                                                      [self.tableView reloadData];
                                                      [self stopLoadingAnimation];
                                                      
                                                  } else {
                                                      [self noNotificationsMessage];
                                                      [self stopLoadingAnimation];
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"Notifications failed to download...");
                                                  
                                                  [self.refreshControl endRefreshing];
                                                  
                                                  [self errorMessage];
                                                  [self stopLoadingAnimation];
                                              }];
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
    [self.notifications removeAllObjects];
    [self.groupedNotifications removeAllObjects];
    self.tableView.backgroundView = [[UIView alloc] init];
    
    [self downloadNotifications];
}

- (void)setLoadingView
{
    if (self.tableView.contentSize.height > 0) {
        
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x,
                                                               self.tableView.frame.origin.y,
                                                               self.tableView.contentSize.width,
                                                               self.tableView.contentSize.height)];
    } else {
        
        loadingView = [[UIView alloc] initWithFrame:self.view.frame];
    }
    
    loadingView.backgroundColor = [UIColor whiteColor];
    UIImageView *loadingAnimation = [appDelegate loadingAnimationPurple];
    loadingAnimation.tag = 43124321;
    [loadingAnimation startAnimating];
    loadingAnimation.frame = CGRectMake(self.view.center.x - 15.0, 15.0, 30.0, 30.0);
    [loadingView addSubview:loadingAnimation];
    [self.tableView addSubview:loadingView];
}

- (void)setDateFormatter
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
}

- (void)stopLoadingAnimation
{
    UIImageView *loadingAnimation = (UIImageView *)[loadingView viewWithTag:43124321];
    [loadingAnimation stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{ loadingView.alpha = 0; }];
    [loadingView removeFromSuperview];
}

- (void)noNotificationsMessage
{
    UILabel *message = [[UILabel alloc] initWithFrame:self.tableView.frame];
    message.font = [UIFont fontWithName:@"Avenir-Roman" size:18.0];
    message.textAlignment = NSTextAlignmentCenter;
    message.textColor = [appDelegate textGrayColor];
    message.alpha = 0;
    message.text = NSLocalizedString(@"You have no notifications yet!", nil);
    
    UILabel *sadSmiley = [[UILabel alloc]initWithFrame:CGRectMake(0, message.center.y - 80, self.tableView.frame.size.width, 50)];
    sadSmiley.font = [UIFont fontWithName:@"Avenir-Light" size:50.0];
    sadSmiley.textAlignment = NSTextAlignmentCenter;
    sadSmiley.textColor = [appDelegate textGrayColor];
    sadSmiley.alpha = 0;
    sadSmiley.text = @":(";
    
    self.tableView.backgroundView = message;
    [self.tableView.backgroundView addSubview:sadSmiley];
    [UIView animateWithDuration:0.3 animations:^{
        message.alpha = 1.0;
        sadSmiley.alpha = 1.0;
    }];
}

- (void)errorMessage
{
    UILabel *error = [[UILabel alloc] initWithFrame:self.tableView.frame];
    error.font = [UIFont fontWithName:@"Avenir-Roman" size:18.0];
    error.textAlignment = NSTextAlignmentCenter;
    error.textColor = [appDelegate textGrayColor];
    error.alpha = 0;
    error.text = NSLocalizedString(@"Couldn't load the notifications...", nil);
    
    UILabel *sadSmiley = [[UILabel alloc] initWithFrame:CGRectMake(0, error.center.y - 80, self.tableView.frame.size.width, 50)];
    sadSmiley.font = [UIFont fontWithName:@"Avenir-Light" size:50.0];
    sadSmiley.textAlignment = NSTextAlignmentCenter;
    sadSmiley.textColor = [appDelegate textGrayColor];
    sadSmiley.alpha = 0;
    sadSmiley.text = @":(";
    
    self.tableView.backgroundView = error;
    [self.tableView.backgroundView addSubview:sadSmiley];
    [UIView animateWithDuration:0.3 animations:^{
        error.alpha = 1.0;
        sadSmiley.alpha = 1.0;
    }];
}

- (void)loadPhotosToView:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    if ([[info objectForKey:@"target"] isEqualToString:@"Notification Dealer's Photo"]) {
        
        NSArray *indexPathes = [self.tableView indexPathsForVisibleRows];
        
        NSIndexPath *receivedIndexPath = [info objectForKey:@"indexPath"];
        
        for (int i = 0; i < indexPathes.count; i++) {
            
            if ([indexPathes[i] isEqual:receivedIndexPath]) {
                
                NotificationTableViewCell *cell = (NotificationTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPathes[i]];
                
                [cell.notificationImage setImage:[info objectForKey:@"image"] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.3 animations:^{ cell.notificationImage.alpha = 1.0; }];
                break;
            }
        }
    }
}

- (void)notificationDealerButtonTapped:(id)sender {
    
    UIButton *notificationImageButton = sender;
    Notification *notification = [self.notifications objectAtIndex:notificationImageButton.tag];
    ProfileTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileID"];
    ptvc.dealer = notification.dealer;
    [self.navigationController pushViewController:ptvc animated:YES];
}

- (void)removeDuplicates
{
    for (Notification *notification in self.notifications) {
        
        BOOL breakForLoop = NO;
        
        if (notification.noDuplicates) {
            continue;
        }
        
        for (Notification *otherNotification in self.notifications) {
            
            if ([notification isEqual:otherNotification]) {
                continue;
            }
            
            if ([notification.dealer.dealerID isEqual:otherNotification.dealer.dealerID]
                && [notification.dealID isEqual:otherNotification.dealID]
                && [notification.type isEqualToString:otherNotification.type]
                && ![notification.type isEqualToString:@"Edit"]) {
                
                [self.notifications removeObject:notification];
                [self removeDuplicates];
                breakForLoop = YES;
                break;
            }
        }
        
        if (breakForLoop) {
            break;
        }
        
        notification.noDuplicates = YES;
    }
}

- (void)mergeNotifications
{
    self.groupedNotifications = [[NSMutableArray alloc] init];

    for (Notification *notification in self.notifications) {
        
        if (notification.grouped) {
            continue;
        }
        
        NSMutableArray *notificationsGroup;
        
        for (Notification *otherNotification in self.notifications) {
            
            if ([notification isEqual:otherNotification] || otherNotification.grouped) {
                continue;
            }
            
            if ([notification.type isEqualToString:otherNotification.type]
                && [notification.dealID isEqual:otherNotification.dealID]
                && ![notification.type isEqualToString:@"Edit"]) {
                
                otherNotification.grouped = YES;
                
                if (!notificationsGroup) {
                    notificationsGroup = [[NSMutableArray alloc] initWithObjects:notification, otherNotification, nil];
                    
                } else {
                    [notificationsGroup addObject:otherNotification];
                }
            }
        }
        
        if (notificationsGroup) {
            [self.groupedNotifications addObject:notificationsGroup];
            
        } else {
            [self.groupedNotifications addObject:notification];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.groupedNotifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self notificationCellForIndexPath:indexPath];
}

- (NotificationTableViewCell *)notificationCellForIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NotificationCellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(NotificationTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.groupedNotifications objectAtIndex:indexPath.row];
    [self setNotificationMessageForCell:cell object:object];
    Notification *notification = [self convertObjectIntoNotification:object];
    [self setDealerImageForCell:cell notification:notification indexPath:indexPath];
    [self setDealerProfileLinkForCell:cell indexPath:indexPath];
    [self setUploadDateForCell:cell notification:notification];
}

- (void)setNotificationMessageForCell:(NotificationTableViewCell *)cell object:(id)object
{
    cell.message.text = [NotificationTableViewCell notificationStringForObject:object];
}

- (Notification *)convertObjectIntoNotification:(id)object
{
    if ([object isMemberOfClass:[Notification class]]) {
        return (Notification *)object;
    } else {
        return (Notification *)[(NSMutableArray *)object firstObject];
    }
}

- (void)setDealerImageForCell:(NotificationTableViewCell *)cell notification:(Notification *)notification indexPath:indexPath
{
    if (!notification.dealer.photo) {
        cell.notificationImage.alpha = 0;
        if (!notification.dealer.downloadingPhoto) {
            notification.dealer.downloadingPhoto = YES;
            [appDelegate otherProfilePic:notification.dealer forTarget:@"Notification Dealer's Photo" notificationName:NAME_FOR_NOTIFICATIONS atIndexPath:indexPath];
        }
    } else {
        cell.notificationImage.alpha = 1.0;
        [cell.notificationImage setImage:[UIImage imageWithData:notification.dealer.photo] forState:UIControlStateNormal];
    }
}

- (void)setDealerProfileLinkForCell:(NotificationTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell.notificationImage setTag:indexPath.row];
    [cell.notificationImage addTarget:self action:@selector(notificationDealerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUploadDateForCell:(NotificationTableViewCell *)cell notification:(Notification *)notification
{
    cell.date.text = [self.dateFormatter stringFromDate:notification.date];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self heightForCellAtIndexPath:indexPath];
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NotificationTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:NotificationCellIdentifier];
        if (!sizingCell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:nil options:nil];
            sizingCell = [nib objectAtIndex:0];
        }
    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self.groupedNotifications objectAtIndex:indexPath.row];
    Notification *notification = [self convertObjectIntoNotification:object];
    ViewDealViewController *vdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewDealID"];
    vdvc.dealID = notification.dealID;
    [self.navigationController pushViewController:vdvc animated:YES];
}


@end
