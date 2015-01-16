//
//  DealsTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/1/14.
//
//

#import "DealsTableViewController.h"

#define NAME_FOR_NOTIFICATIONS @"Deals Photos Notifications"
#define NOTIFICATION_FIRST_THREE @"First Three Deals Photos Notifications"

#define DEAL_CELL_HEIGHT 214.0f
#define DEAL_CELL_HEIGHT_NO_PHOTO 159.0f

@implementation DealsTableViewController

@synthesize appDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkFeature];
    
    if ([selfViewController isEqualToString:NSLocalizedString(@"My Feed", nil)]) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dealers Logo"]];
    } else if ([selfViewController isEqualToString:NSLocalizedString(@"Explore", nil)]) {
        self.title = self.categoryFromExplore;
    }
    
    [self initialize];
    [self setNotificationObservers];
    [self setRefreshControl];
    [self configurePaginator];
    [self setLoadingView];
    
    NSLog(@"\n\n%@\n%@",[NSNumber numberWithInteger:self.paginator.perPage], [NSNumber numberWithInteger:self.paginator.objectCount]);
    
    [self.paginator loadPage:1];
    self.pageIsLoading = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (appDelegate.shouldUpdateMyFeed) {
        [self.tableView setContentOffset:CGPointMake(0, -64)];
        [self setLoadingView];
        [self refresh];
        appDelegate.shouldUpdateMyFeed = NO;
    }
}

- (void)checkFeature
{
    if ([self.navigationController.restorationIdentifier isEqualToString:@"feedNavController"]) {
        selfViewController = NSLocalizedString(@"My Feed", nil);
    } else if ([self.navigationController.restorationIdentifier isEqualToString:@"exploreNavController"]) {
        selfViewController = NSLocalizedString(@"Explore", nil);
    }
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.deals = [[NSMutableArray alloc] init];
    self.pageIsLoading = NO;
    firstPhotosCounter = 0;
}


# pragma mark - General methods

- (void)setNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadPhotosInVisibleCells:)
                                                 name:NAME_FOR_NOTIFICATIONS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(photoDownloaded:)
                                                 name:NOTIFICATION_FIRST_THREE
                                               object:nil];
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
    self.tableView.backgroundView = [[UIView alloc] init];
    
    if (self.pageIsLoading) {
        [self.paginator cancel];
        self.pageIsLoading = NO;
    }
    
    [self.paginator loadPage:1];
    self.pageIsLoading = YES;
}

- (void)configurePaginator
{
    __weak typeof(self) weakSelf = self;
    
    if (!self.paginator) {
        
        NSString *requestString;
        
        if ([selfViewController isEqualToString:NSLocalizedString(@"My Feed", nil)]) {
            
            requestString = [NSString stringWithFormat:@"/deals/?page=:currentPage&per_page=:perPage"];
            
        } else if ([selfViewController isEqualToString:NSLocalizedString(@"Explore", nil)]) {
            
            requestString = [NSString stringWithFormat:@"/deals/?page=:currentPage&per_page=:perPage&category=%@", [appDelegate getCategoryKeyForValue:self.categoryFromExplore]];
        }
        
        self.paginator = [[RKObjectManager sharedManager] paginatorWithPathPattern:requestString];
        self.paginator.perPage = 10;
        [self.paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *deals, NSUInteger page) {
            
            weakSelf.pageIsLoading = NO;
            
            if (page == 1) {
                [weakSelf.deals removeAllObjects];
            }
            
            [weakSelf.deals addObjectsFromArray:deals];
            
            if (!weakSelf.deals || weakSelf.deals.count == 0) {
                [weakSelf stopLoadingAnimation];
                [weakSelf noDealMessage];
                [weakSelf.tableView reloadData];
                weakSelf.tableView.tableFooterView = nil;
                [weakSelf.refreshControl endRefreshing];

            } else if (page == 1) {
                [weakSelf loadFirstThreePhotos];
                
            } else {
                [weakSelf.tableView reloadData];
            }
            
        } failure:^(RKPaginator *paginator, NSError *error) {
            NSLog(@"Failure: %@", error);
            [weakSelf stopLoadingAnimation];
            [weakSelf errorMessage];
            [weakSelf.refreshControl endRefreshing];
            weakSelf.pageIsLoading = NO;
            [weakSelf.paginator cancel];
        }];
    }
}

- (void)downloadDealsOld
{
    NSDictionary *parameters;
    
    if ([selfViewController isEqualToString:NSLocalizedString(@"My Feed", nil)]) {
        parameters = nil;
    } else {
        parameters = @{@"category": [appDelegate getCategoryKeyForValue:self.categoryFromExplore]};
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/deals/"
                                           parameters:parameters
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  [self.deals addObjectsFromArray:mappingResult.array];
                                                  
                                                  if (!self.deals || self.deals.count == 0) {
                                                      [self stopLoadingAnimation];
                                                      [self noDealMessage];
                                                      
                                                  } else {
                                                      [self.tableView reloadData];
                                                      [self stopLoadingAnimation];
                                                  }
                                                  
                                                  [self.refreshControl endRefreshing];
                                                  
                                                  NSLog(@"\n success! \n number of deals: %lu", (unsigned long)self.deals.count);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"There was an error with the loading of the store search: %@", error);
                                                  [self stopLoadingAnimation];
                                                  [self errorMessage];
                                                  [self.refreshControl endRefreshing];
                                              }];
}

- (void)loadFirstThreePhotos
{
    if (self.deals.count > 0) {
        
        for (int i = 0; i < self.deals.count; i++) {
            
            Deal *deal = [self.deals objectAtIndex:i];
            
            if (deal.photoURL1.length > 2 && ![deal.photoURL1 isEqualToString:@"None"]) {
                deal.downloadingPhoto = YES;
                [appDelegate downloadPhotosForDeal:deal notificationName:NOTIFICATION_FIRST_THREE atIndexPath:nil mode:nil];
            } else {
                [self photoDownloaded:nil];
            }
            
            if (i == 2) {
                // Breaking after 3 photos have been downloaded
                break;
            }
        }
        
    } else {
        
        NSLog(@"No deals in the array, so no photos...");
    }
}

- (void)photoDownloaded:(NSNotification *)notification
{
    firstPhotosCounter++;
    if (firstPhotosCounter == 3 || firstPhotosCounter == self.deals.count) {
        [self reloadTableView];
    }
}

- (void)checkIfIndexRowTooBig
{
    NSIndexPath *lastVisibleRow = self.tableView.indexPathsForVisibleRows.lastObject;
    
    if (lastVisibleRow.row > (self.deals.count - 1)) {
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }
}

- (void)reloadTableView
{
    [self.tableView reloadData];
    [self stopLoadingAnimation];
    [self.refreshControl endRefreshing];
    if (![self.paginator hasNextPage] && self.deals.count > 0) {
        self.tableView.tableFooterView = [self setFooterView];
    }
    // Load photo of next deal in the array
    [self downloadNextPhotoAfterIndexPath:[NSIndexPath indexPathForRow:firstPhotosCounter - 1 inSection:0]];
    firstPhotosCounter = 0;
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
    
    
    loadingView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIImageView *loadingAnimation = [appDelegate loadingAnimationPurple];
    loadingAnimation.tag = 13212;
    [loadingAnimation startAnimating];
    loadingAnimation.frame = CGRectMake(self.view.center.x - 15.0, 15.0, 30.0, 30.0);
    [loadingView addSubview:loadingAnimation];
    [self.tableView addSubview:loadingView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)stopLoadingAnimation
{
    UIImageView *loadingAnimation = (UIImageView *)[loadingView viewWithTag:13212];
    [loadingAnimation stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{ loadingView.alpha = 0; }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)noDealMessage
{
    UILabel *error = [[UILabel alloc]initWithFrame:self.tableView.frame];
    error.font = [UIFont fontWithName:@"Avenir-Roman" size:18.0];
    error.textAlignment = NSTextAlignmentCenter;
    error.textColor = [appDelegate textGrayColor];
    error.alpha = 0;
    error.text = NSLocalizedString(@"There are no deals at this moment!", nil);
    
    UILabel *sadSmiley = [[UILabel alloc]initWithFrame:CGRectMake(0, error.center.y - 80, self.tableView.frame.size.width, 50)];
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

- (void)errorMessage
{
    UILabel *error = [[UILabel alloc]initWithFrame:self.tableView.frame];
    error.font = [UIFont fontWithName:@"Avenir-Roman" size:18.0];
    error.textAlignment = NSTextAlignmentCenter;
    error.textColor = [appDelegate textGrayColor];
    error.alpha = 0;
    error.text = NSLocalizedString(@"Couldn't load the deals...", nil);
    
    UILabel *sadSmiley = [[UILabel alloc]initWithFrame:CGRectMake(0, error.center.y - 80, self.tableView.frame.size.width, 50)];
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

- (void)loadPhotosInVisibleCells:(NSNotification *)notification
{
    NSArray *indexPathes = [self.tableView indexPathsForVisibleRows];
    
    NSIndexPath *receivedIndexPath = [notification.userInfo objectForKey:@"indexPath"];
    
    for (int i = 0; i < indexPathes.count; i++) {
        
        if ([indexPathes[i] isEqual:receivedIndexPath]) {
            
            DealsTableCell *cell = (DealsTableCell *)[self.tableView cellForRowAtIndexPath:indexPathes[i]];
            
            cell.photo.image = [notification.userInfo objectForKey:@"image"];
            [UIView animateWithDuration:0.5 animations:^{ cell.photo.alpha = 1.0; }];
            break;
        }
    }
    
    // Load photo of next deal in the array
    [self downloadNextPhotoAfterIndexPath:receivedIndexPath];
}

- (void)downloadNextPhotoAfterIndexPath:(NSIndexPath *)indexPath
{
    for (NSInteger i = indexPath.row + 1; i < self.deals.count; i++) {
        
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        Deal *nextDeal = [self.deals objectAtIndex:nextIndexPath.row];
        
        if (nextDeal.photoURL1.length > 2 && ![nextDeal.photoURL1 isEqualToString:@"None"]) {
            if (!nextDeal.photo1 && !nextDeal.downloadingPhoto) {
                nextDeal.downloadingPhoto = YES;
                [appDelegate downloadPhotosForDeal:nextDeal notificationName:NAME_FOR_NOTIFICATIONS atIndexPath:nextIndexPath mode:nil];
                break;
            }
        } else {
            continue;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentSize.height > 0) {
        int nextPageTriggerPoint = self.tableView.contentSize.height / 1.5;
        int contentOffset = self.tableView.contentOffset.y + self.tableView.frame.size.height;
        if (contentOffset > nextPageTriggerPoint) {
            
            if (!self.pageIsLoading) {
                
                if ([self.paginator hasNextPage] ) {
                    
                    [self.paginator loadNextPage];
                    self.pageIsLoading = YES;
                    self.tableView.tableFooterView = [self setFooterView];
                    needToSetFooter = YES;
                    
                } else {
                    
                    if (needToSetFooter) {
                        self.tableView.tableFooterView = [self setFooterView];
                    }
                }
            }
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Deal *deal = [self.deals objectAtIndex:indexPath.row];
    
    if (!deal.photoSum) {
        deal.photoSum = [appDelegate setPhotoSum:deal];
    }
    
    if (deal.currency.length == 2) {
        deal.currency = [appDelegate getCurrencySign:deal.currency];
    }
    
    if (deal.discountType.length == 2) {
        deal.discountType = [appDelegate getDiscountType:deal.discountType];
    }
    
    if (deal.photoURL1.length > 2 && ![deal.photoURL1 isEqualToString:@"None"]) {
        
        static NSString *cellIdentifier = @"DealsTableCellID";
        DealsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealsTableCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        // Downloading deal's photo (if haven't been downloaded already)
        
        if (!deal.photo1) {
            cell.photo.alpha = 0;
            if (!deal.downloadingPhoto) {
                deal.downloadingPhoto = YES;
                [appDelegate downloadPhotosForDeal:deal notificationName:NAME_FOR_NOTIFICATIONS atIndexPath:indexPath mode:nil];
            }
        } else {
            cell.photo.alpha = 1.0;
            cell.photo.image = deal.photo1;
        }
        
        // Checking if the deal expired
        
        NSDate *today = [NSDate date];
        NSDate *expirationDate = deal.expiration;
        
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&today interval:nil forDate:today];
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&expirationDate interval:nil forDate:expirationDate];
        
        if ([today compare:expirationDate] == NSOrderedDescending) {
            cell.expiredTag.hidden = NO;
        }
        
        // Loading the deal's details to the cell
        
        cell.title.text = deal.title;
        cell.store.text = deal.store.name;
        
        if (deal.dealAttrib.dealersThatLiked.count > 0) {
            cell.likesCounter.hidden = NO;
            cell.likesIcon.hidden = NO;
            cell.likesCounter.text = [NSNumber numberWithUnsignedInteger:deal.dealAttrib.dealersThatLiked.count].stringValue;
        } else {
            cell.likesCounter.hidden = YES;
            cell.likesIcon.hidden = YES;
        }
        
        if (deal.price.floatValue > 0) {
            cell.price.hidden = NO;
            cell.price.text = [deal.currency stringByAppendingString:deal.price.stringValue];
        } else {
            cell.price.hidden = YES;
        }
        
        if (deal.discountValue.floatValue > 0) {
            cell.discount.hidden = NO;
            if ([deal.discountType isEqualToString:@"%"]) {
                cell.discount.text = [deal.discountValue.stringValue stringByAppendingString:deal.discountType];
            } else if ([deal.discountType isEqualToString:@"lastPrice"]){
                NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
                NSString *lastPriceDiscount = [deal.currency stringByAppendingString:deal.discountValue.stringValue];
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:lastPriceDiscount attributes:attributes];
                cell.discount.attributedText = attrText;
            }
        } else {
            cell.discount.hidden = YES;
        }
        
        return cell;
        
    } else {
        
        static NSString *cellIdentifier = @"DealsNoPhotoTableCellID";
        DealsNoPhotoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealsNoPhotoTableCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        // Setting random background image to cell
        
        if (!deal.photoURL1) {
            int random = arc4random_uniform(4);
            deal.photoURL1 = [NSNumber numberWithInt:random].stringValue;
        }
        cell.backgroundWithColor.backgroundColor = [DealsNoPhotoTableCell randomBackgroundColors:deal.photoURL1];
        
        // Loading the deal's details to the cell
        
        cell.title.text = deal.title;
        cell.store.text = deal.store.name;
        
        if (deal.dealAttrib.dealersThatLiked.count > 0) {
            cell.likesCounter.hidden = NO;
            cell.likesIcon.hidden = NO;
            cell.likesCounter.text = [NSNumber numberWithUnsignedInteger:deal.dealAttrib.dealersThatLiked.count].stringValue;
        } else {
            cell.likesCounter.hidden = YES;
            cell.likesIcon.hidden = YES;
        }
        
        if (deal.price.floatValue > 0) {
            cell.price.hidden = NO;
            cell.price.text = [deal.currency stringByAppendingString:deal.price.stringValue];
        } else {
            cell.price.hidden = YES;
        }
        
        if (deal.discountValue.floatValue > 0) {
            cell.discount.hidden = NO;
            if ([deal.discountType isEqualToString:@"%"]) {
                cell.discount.text = [deal.discountValue.stringValue stringByAppendingString:deal.discountType];
            } else if ([deal.discountType isEqualToString:@"lastPrice"]){
                NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
                NSString *lastPriceDiscount = [deal.currency stringByAppendingString:deal.discountValue.stringValue];
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:lastPriceDiscount attributes:attributes];
                cell.discount.attributedText = attrText;
            }
        } else {
            cell.discount.hidden = YES;
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Deal *deal = [self.deals objectAtIndex:indexPath.row];
    
    if (deal.photoURL1.length > 2 && ![deal.photoURL1 isEqualToString:@"None"]) {
        
        return DEAL_CELL_HEIGHT;
        
    } else {
        
        return DEAL_CELL_HEIGHT_NO_PHOTO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewonedealViewController *vodvc = [self.storyboard instantiateViewControllerWithIdentifier:@"viewdeal"];
    Deal *deal = [self.deals objectAtIndex:indexPath.row];
    vodvc.deal = deal;
    vodvc.delegate = self;
    vodvc.dealIndexPath = indexPath;
    
    [self.navigationController pushViewController:vodvc animated:YES];
}

- (UIView *)setFooterView
{
    if (!self.footerView) {
        self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 64.0)];
    }
    
    if (self.footerImageView) {
        [self.footerImageView removeFromSuperview];
    }
    
    if (self.pageIsLoading) {
        
        self.footerImageView = [appDelegate loadingAnimationPurple];
        self.footerImageView.frame = CGRectMake(self.tableView.center.x - 15.0, 15.0, 30.0, 30.0);
        [self.footerImageView startAnimating];
        [self.footerView addSubview:self.footerImageView];
        
    } else {
        
        self.footerImageView = [[UIImageView alloc]init];
        self.footerImageView.frame = CGRectMake(self.tableView.center.x - 13.0, 12.0, 24.0, 34.0);
        self.footerImageView.image = [UIImage imageNamed:@"Bottom Logo"];
        self.footerImageView.alpha = 0.6;
        needToSetFooter = NO;
        [self.footerView addSubview:self.footerImageView];
    }
    
    return self.footerView;
}

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
