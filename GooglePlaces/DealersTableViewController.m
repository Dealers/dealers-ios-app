//
//  DealersTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/16/14.
//
//

#import "DealersTableViewController.h"

#define NAME_FOR_NOTIFICATIONS @"Dealers Photos Notifications"

@interface DealersTableViewController ()

@end

@implementation DealersTableViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(self.mode, nil);
    
    [self initialize];
    [self setNotificationsObservers];
    [self determineMode];
    [self setLoadingView];
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.dealers = [[NSMutableArray alloc]init];
    self.tableView.rowHeight = 64.0;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)setNotificationsObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadPhotosInVisibleCells:)
                                                 name:NAME_FOR_NOTIFICATIONS
                                               object:nil];
}

- (void)determineMode
{
    if ([self.mode isEqualToString:@"Likers"]) {
        
        [self downloadDealers];
    }
}

- (void)downloadDealers
{
    NSString *path = [NSString stringWithFormat:@"/dealerslikeddeals/%@/", self.dealID];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
                                                  NSLog(@"Dealers were downloaded successfuly");
                                                  [self.dealers addObjectsFromArray:mappingResult.array];
                                                  [self.tableView reloadData];
                                                  [self stopLoadingAnimation];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"There was an error with loading the dealers: %@", error);
                                                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Couldn't Download Dealers", nil)
                                                                                                 message:NSLocalizedString(@"Sorry for that, please try again", nil)
                                                                                                delegate:nil
                                                                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                       otherButtonTitles:nil];
                                                  [alert show];
                                                  [self stopLoadingAnimation];
                                              }];
}

- (void)setLoadingView
{
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
    loadingAnimation.tag = 13212123;
    [loadingAnimation startAnimating];
    loadingAnimation.frame = CGRectMake(self.view.center.x - 15.0, 15.0, 30.0, 30.0);
    [loadingView addSubview:loadingAnimation];
    [self.tableView addSubview:loadingView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)stopLoadingAnimation
{
    UIImageView *loadingAnimation = (UIImageView *)[loadingView viewWithTag:13212123];
    [loadingAnimation stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{ loadingView.alpha = 0; }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)loadPhotosInVisibleCells:(NSNotification *)notification
{
    NSArray *indexPathes = [self.tableView indexPathsForVisibleRows];
    
    NSIndexPath *receivedIndexPath = [notification.userInfo objectForKey:@"indexPath"];
    
    for (int i = 0; i < indexPathes.count; i++) {
        
        if ([indexPathes[i] isEqual:receivedIndexPath]) {
            
            DealersTableCell *cell = (DealersTableCell *)[self.tableView cellForRowAtIndexPath:indexPathes[i]];
            
            cell.profilePic.image = [notification.userInfo objectForKey:@"image"];
            [UIView animateWithDuration:0.5 animations:^{ cell.profilePic.alpha = 1.0; }];
            break;
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dealers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Dealer *dealer = [self.dealers objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"DealersTableCellID";
    DealersTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealersTableCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (dealer.dealerID.intValue == self.appDelegate.dealer.dealerID.intValue) {
        cell.profilePic.alpha = 1.0;
        cell.profilePic.image = [appDelegate myProfilePic];
    } else if (!dealer.photo) {
        cell.profilePic.alpha = 0;
        if (!dealer.downloadingPhoto) {
            dealer.downloadingPhoto = YES;
            [appDelegate otherProfilePic:dealer forTarget:@"Dealers' Photos" notificationName:NAME_FOR_NOTIFICATIONS atIndexPath:indexPath];
        }
    } else {
        cell.profilePic.alpha = 1.0;
        cell.profilePic.image = [UIImage imageWithData:dealer.photo];
    }
    
    cell.fullName.text = dealer.fullName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileID"];
    ptvc.dealer = [self.dealers objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ptvc animated:YES];
}



@end
