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
static NSString * const DealCellIdentifier = @"DealTableViewCell";

#define NO_PHOTO_BACKGROUND_HEIGHT 114.0f


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
    [self configureNavigationBar];
    [self initialize];
    [self setNotificationObservers];
    [self setRefreshControl];
    [self startLocationTrack];
    [self configurePaginator];
    [self setLoadingView];
    
    NSLog(@"\n\n%@\n%@",[NSNumber numberWithInteger:self.paginator.perPage], [NSNumber numberWithInteger:self.paginator.objectCount]);
    
    [self.paginator loadPage:1];
    self.pageIsLoading = YES;
    
    [self getInvitationCounter];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (appDelegate.shouldUpdateMyFeed) {
        [self.tableView setContentOffset:CGPointMake(0, -64)];
        [self setLoadingView];
        [self refresh];
        appDelegate.shouldUpdateMyFeed = NO;
    }

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    if ([selfViewController isEqualToString:NSLocalizedString(@"My Feed", nil)]) {
        [tracker set:kGAIScreenName value:@"My Feed Screen"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    } else if ([selfViewController isEqualToString:NSLocalizedString(@"Category", nil)]) {
        [tracker set:kGAIScreenName value:@"Category Screen"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    } else if ([selfViewController isEqualToString:NSLocalizedString(@"Search", nil)]) {
        [tracker set:kGAIScreenName value:@"Search Results Screen"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
}

- (void)checkFeature
{
    if (!self.categoryFromExplore && !self.searchTermFromExplore) {
        selfViewController = NSLocalizedString(@"My Feed", nil);
    } else if (self.categoryFromExplore && !self.searchTermFromExplore) {
        selfViewController = NSLocalizedString(@"Category", nil);
    } else if (!self.categoryFromExplore && self.searchTermFromExplore) {
        selfViewController = NSLocalizedString(@"Search", nil);
    } else {
        NSLog(@"Both category and search term values are populated, undesired situation...");
        selfViewController = NSLocalizedString(@"My Feed", nil);
    }
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.deals = [[NSMutableArray alloc] init];
    self.pageIsLoading = NO;
    firstPhotosCounter = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


# pragma mark - General methods

- (void)configureNavigationBar
{
    if ([selfViewController isEqualToString:NSLocalizedString(@"My Feed", nil)]) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dealers Logo"]];
    } else if ([selfViewController isEqualToString:NSLocalizedString(@"Category", nil)]) {
        self.title = self.categoryFromExplore;
    } else if ([selfViewController isEqualToString:NSLocalizedString(@"Search", nil)]) {
        self.title = NSLocalizedString(@"Search", nil);
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

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

- (void)startLocationTrack
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)configurePaginator
{
    __weak typeof(self) weakSelf = self;
    
    if (!self.paginator) {
        NSString *requestString;
        if ([selfViewController isEqualToString:NSLocalizedString(@"My Feed", nil)]) {
            requestString = [NSString stringWithFormat:@"/my_feeds/?page=:currentPage&per_page=:perPage"];
        } else if ([selfViewController isEqualToString:NSLocalizedString(@"Category", nil)]) {
            NSString *categoryKey = [appDelegate getCategoryKeyForValue:self.categoryFromExplore];
            requestString = [NSString stringWithFormat:@"/category_deals/?page=:currentPage&per_page=:perPage&category=%@", categoryKey];
        } else if ([selfViewController isEqualToString:NSLocalizedString(@"Search", nil)]) {
            requestString = [NSString stringWithFormat:@"/dealsearch/?page=:currentPage&per_page=:perPage&search=%@", self.searchTermFromExplore];
            requestString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        if (self.locationManager.location.coordinate.latitude && self.locationManager.location.coordinate.longitude) {
            NSString *locationParameters = [NSString stringWithFormat:@"&ll=%f,%f",
                                            self.locationManager.location.coordinate.latitude,
                                            self.locationManager.location.coordinate.longitude];
            requestString = [requestString stringByAppendingString:locationParameters];
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
            [weakSelf.tableView reloadData];
            [weakSelf.refreshControl endRefreshing];
            weakSelf.pageIsLoading = NO;
            [weakSelf.paginator cancel];
        }];
    }
}

- (void)dummyDeals
{
    self.deals = [[NSMutableArray alloc] init];
    Deal *deal = [[Deal alloc] init];
    
    deal.title = @"Great deal now at Zara with great accessories and stuff";
    deal.price = @(15);
    deal.currency = @"DO";
    deal.expiration = [NSDate date];
    deal.store.name = @"Zara, Raanana";
    deal.photoURL1 = @"jdsfjkdsf;";
    
    [self.deals addObject:deal];
    
    deal = [[Deal alloc] init];
    deal.title = @"Wow come see what I found here";
    deal.price = @(266);
    deal.currency = @"SH";
    deal.expiration = [NSDate date];
    deal.store.name = @"Shekem Electric";
    deal.photoURL1 = @"jdsfjkdsf;";
    
    [self.deals addObject:deal];
    
    deal = [[Deal alloc] init];
    deal.title = @"1+1 on al hamburgers at McDonalds... Yam Yam!";
    deal.expiration = [NSDate date];
    deal.store.name = @"McDonalds, Kiryat Mozkin Krayot";
    deal.photoURL1 = @"jdsfjkdsf;";
    
    [self.deals addObject:deal];
    
    deal = [[Deal alloc] init];
    deal.title = @"Awesome shoes at nike store";
    deal.price = @(15);
    deal.currency = @"SH";
    deal.expiration = [NSDate date];
    deal.store.name = @"Nike";
    deal.photoURL1 = @"jdsfjkdsf;";
    
    [self.deals addObject:deal];
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
}

- (void)stopLoadingAnimation
{
    UIImageView *loadingAnimation = (UIImageView *)[loadingView viewWithTag:13212];
    [loadingAnimation stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{ loadingView.alpha = 0; }];
}

- (void)noDealMessage
{
    UILabel *error = [[UILabel alloc]initWithFrame:self.tableView.frame];
    error.font = [UIFont fontWithName:@"Avenir-Roman" size:18.0];
    error.textAlignment = NSTextAlignmentCenter;
    error.textColor = [appDelegate textGrayColor];
    error.alpha = 0;
    
    if ([selfViewController isEqualToString:NSLocalizedString(@"Search", nil)]) {
        error.text = NSLocalizedString(@"No deals found", nil);
    } else {
        error.text = NSLocalizedString(@"There are no deals at this moment!", nil);
    }
    
    UILabel *sadSmiley = [[UILabel alloc]initWithFrame:CGRectMake(0, error.center.y - 80, self.tableView.frame.size.width, 50)];
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    NSTimeInterval howRecent = [location.timestamp timeIntervalSinceNow];
    if (fabs(howRecent) < 60.0) {
        // If the event is recent, do something with it.
        [self.locationManager stopMonitoringSignificantLocationChanges];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deals.count;
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
    Deal *deal = self.deals[indexPath.row];
    
    [self prepareDeal:deal];
    [self checkIfHasImageForCell:cell deal:deal indexPath:indexPath];
    [self checkIfDealExpiredForCell:cell deal:deal];
    [self setBasicDetailsForCell:cell deal:deal];
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
            [appDelegate downloadPhotosForDeal:deal notificationName:NAME_FOR_NOTIFICATIONS atIndexPath:indexPath mode:nil];
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

- (void)setBasicDetailsForCell:(DealTableViewCell *)cell deal:(Deal *)deal
{
    cell.title.text = deal.title;
    cell.store.text = deal.store.name;
    if ([deal.type isEqualToString:@"Online"]) {
        cell.storeIcon.image = [UIImage imageNamed:@"Online Icon Gray"];
    } else {
        cell.storeIcon.image = [UIImage imageNamed:@"Local Icon Gray"];
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
    NSInteger lastDeal = self.deals.count - 1;
    if (indexPath.row == lastDeal && !self.pageIsLoading) {
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
    Deal *deal = [self.deals objectAtIndex:indexPath.row];
    vdvc.deal = deal;
    vdvc.delegate = self;
    vdvc.dealIndexPath = indexPath;
    
    [self.navigationController pushViewController:vdvc animated:YES];
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
        
        self.footerImageView = [[UIImageView alloc] init];
        self.footerImageView.frame = CGRectMake(self.tableView.center.x - 13.0, 12.0, 24.0, 34.0);
        self.footerImageView.image = [UIImage imageNamed:@"Bottom Logo"];
        self.footerImageView.alpha = 0.6;
        needToSetFooter = NO;
        [self.footerView addSubview:self.footerImageView];
    }
    
    return self.footerView;
}

- (void)getInvitationCounter
{
    NSString *path = [NSString stringWithFormat:@"/dealers/%@/", appDelegate.dealer.dealerID];
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  Dealer *dealer = mappingResult.firstObject;
                                                  NSNumber *counter = dealer.invitationCounter;
                                                  appDelegate.dealer.invitationCounter = counter;
                                                  [[NSUserDefaults standardUserDefaults] setObject:counter forKey:@"invitationCounter"];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Couldn't fetch dealer invitation counter");
                                              }];
}


@end
