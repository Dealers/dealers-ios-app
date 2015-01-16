//
//  ActivityTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/11/14.
//
//

#import "ActivityTableViewController.h"

#define S3_PHOTOS_ADDRESS @"https://s3-eu-west-1.amazonaws.com/dealers-app/"

#define NAME_FOR_NOTIFICATIONS @"Notifications Photos Notifications"

@interface ActivityTableViewController ()

@end

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
    [invite setImageInsets:UIEdgeInsetsMake(1, -5, -1, 5)];
    self.navigationItem.rightBarButtonItem = invite;
    
    [self setNotificationObservers];
    [self setTableViewSettings];
    [self setRefreshControl];
    [self downloadNotifications];
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

- (void)stopLoadingAnimation
{
    UIImageView *loadingAnimation = (UIImageView *)[loadingView viewWithTag:43124321];
    [loadingAnimation stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{ loadingView.alpha = 0; }];
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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
                
                NotificationTableCell *cell = (NotificationTableCell *)[self.tableView cellForRowAtIndexPath:indexPathes[i]];
                
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
        
        BOOL breakForLoop;
        
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
            
            if (!self.groupedNotifications) {
                self.groupedNotifications = [[NSMutableArray alloc] init];
            }
            
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"NotificationCell";
    NotificationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTableCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Notification *notification;
    id object = [self.groupedNotifications objectAtIndex:indexPath.row];

    if ([object isMemberOfClass:[Notification class]]) {
        notification = object;
        cell.label.text = [NotificationTableCell notificationStringForObject:notification];
    } else {
        NSMutableArray *notificationGroup = object;
        cell.label.text = [NotificationTableCell notificationStringForObject:notificationGroup];
        notification = [notificationGroup firstObject];
    }
    
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
    
    [cell.notificationImage setTag:indexPath.row];
    [cell.notificationImage addTarget:self action:@selector(notificationDealerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self.groupedNotifications objectAtIndex:indexPath.row];
    Notification *notification;
    
    if ([object isMemberOfClass:[Notification class]]) {
        notification = object;
    } else {
        NSMutableArray *notificationsGroup = object;
        notification = notificationsGroup.firstObject;
    }
    
    ViewonedealViewController *vodvc = [self.storyboard instantiateViewControllerWithIdentifier:@"viewdeal"];
    vodvc.dealID = notification.dealID;
    [self.navigationController pushViewController:vodvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}


@end
