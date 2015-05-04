//
//  NewWhereIsTheDeal.m
//  Dealers
//
//  Created by Gilad Lumbroso on 3/11/15.
//
//

#import "WhereIsTheDeal.h"

#define CLIENTID @"K5GUWBVHWMFLC4BKY04S2AT4RZWNY3VGTVI1S2X3XZBY1CHJ"
#define CLIENTSECRET @"CU5VDZCZWPKJTSHK3JH3B5CEJOZO50EKZ4VYJMGWGLICJFTO"
#define VERSION @"20140201"
static const CGFloat mapWindowMaxHeight = 152.0;
static NSString * const storeCellIdentifier = @"StoreTableViewCell";

@interface WhereIsTheDeal ()

@end

@implementation WhereIsTheDeal

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Where is the deal?", nil);
    
    [self initialize];
    [self registerForKeyboardNotifications];
    [self configureRestKit];
    [self configureMapView];
    [self configureTableViews];
    [self configureLoadingView];
    [self downloadStoresNearby];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.nearbyTableView deselectRowAtIndexPath:self.nearbyTableView.indexPathForSelectedRow animated:YES];
    [self.searchTableView deselectRowAtIndexPath:self.searchTableView.indexPathForSelectedRow animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    deviceScreenHeight = [UIScreen mainScreen].bounds.size.height;
    searchTextEmpty = YES;
    
    // If came frome Edit Deal, no need for dismiss button:
    if ([self.cameFrom isEqualToString:@"Edit Deal"]) {
        self.navigationItem.leftBarButtonItem = nil;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.screenName = @"Edit Deal - Where Is The Deal Screen";
    } else {
        self.screenName = @"Add Deal - Where Is The Deal Screen";
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrame = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    [self updateSearchTableViewInsetsForKeyboardHeight:[keyboardFrame CGRectValue].size.height];
}


#pragma mark - Downloading data

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    self.foursquareManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *storeMapping = [RKObjectMapping mappingForClass:[Store class]];
    [storeMapping addAttributeMappingsFromDictionary:@{
                                                       @"id" : @"storeID",
                                                       @"name" : @"name",
                                                       @"categories" : @"categories",
                                                       @"location.lat" : @"latitude",
                                                       @"location.lng" : @"longitude",
                                                       @"location.distance" : @"distance",
                                                       @"location.address" : @"address",
                                                       @"location.cc" : @"cc",
                                                       @"location.city" : @"city",
                                                       @"location.state" : @"state",
                                                       @"location.country" : @"country",
                                                       @"url" : @"url",
                                                       @"contact.formattedPhone" : @"phone",
                                                       @"verified" : @"verifiedByFoursquare"
                                                       }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:storeMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/v2/venues/search"
                                                keyPath:@"response.venues"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.foursquareManager addResponseDescriptor:responseDescriptor];
}

- (void)downloadStoresNearby
{
    NSString *ll = [NSString stringWithFormat:@"%f,%f", _locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude];
    NSString *clientID = CLIENTID;
    NSString *clientSecret = CLIENTSECRET;
    NSString *foursquareVersion = VERSION;
    
    NSDictionary *queryParams = @{@"ll" : ll,
                                  @"client_id" : clientID,
                                  @"client_secret" : clientSecret,
                                  @"v" : foursquareVersion,
                                  @"radius" : @"1000",
                                  @"limit" : @"50"
                                  };
    
    [self.foursquareManager getObjectsAtPath:@"/v2/venues/search"
                             parameters:queryParams
                                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                    
                                    self.storesNearby = [self filterStores:mappingResult.array]; 
                                    [self.nearbyTableView reloadData];
                                    if (self.storesNearby.count == 0) {
                                        [self errorLoadingStores: @"No stores around"];
                                    } else {
                                        [self updateNearbyTableView];
                                    }
                                }
                                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                    
                                    NSLog(@"There was an error with the loading of the stores nearby: %@", error);
                                    [self errorLoadingStores:@"Connection error"];
                                    [self performSelector:@selector(hideWhiteCoverView) withObject:nil afterDelay:0.3];
                                }];
}

- (void)downloadStoresSearched:(NSString *)text
{
    NSString *ll = [NSString stringWithFormat:@"%f,%f", _locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude];
    NSString *clientID = CLIENTID;
    NSString *clientSecret = CLIENTSECRET;
    NSString *foursquareVersion = VERSION;
    
    NSDictionary *queryParams = @{@"ll" : ll,
                                  @"client_id" : clientID,
                                  @"client_secret" : clientSecret,
                                  @"v" : foursquareVersion,
                                  @"radius" : @"80000",
                                  @"intent" : @"browse",
                                  @"query" : text,
                                  @"limit" : @"50"
                                  };
    
    [self.foursquareManager getObjectsAtPath:@"/v2/venues/search"
                             parameters:queryParams
                                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                    
                                    self.storesSearched = [self filterStores:mappingResult.array];
                                    [self.searchTableView reloadData];
                                }
                                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                    NSLog(@"There was an error with the loading of the store search: %@", error);
                                }];
}

- (NSMutableArray *)filterStores:(NSArray *)storesArray
{
    NSMutableArray *filteredStores = [[NSMutableArray alloc] init];
    for (Store *store in storesArray) {
        if (store.categories.count > 0) {
            NSDictionary *categoryIdArray = [store.categories objectAtIndex:0];
            if ([StoreCategoriesOrganizer checkIfCategoryExists:categoryIdArray[@"id"]]) {
                [filteredStores addObject:store];
            }
        }
    }
    return filteredStores;
}

- (void)errorLoadingStores:(NSString *)error
{
    UILabel *noStoresLabel = [[UILabel alloc] initWithFrame:self.nearbyTableView.frame];
    noStoresLabel.backgroundColor = [UIColor whiteColor];
    noStoresLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20.0];
    noStoresLabel.textAlignment = NSTextAlignmentCenter;
    noStoresLabel.textColor = [UIColor lightGrayColor];
    noStoresLabel.tag = 4321;
    
    if ([error isEqualToString:@"No stores around"]) {
        noStoresLabel.text = NSLocalizedString(@"No stores were found around you", nil);
    } else if ([error isEqualToString:@"Connection error"]) {
        noStoresLabel.text = NSLocalizedString(@"Can't connect to the server", nil);
    }
    
    UILabel *sadSmiley = [[UILabel alloc]initWithFrame:CGRectMake(0, noStoresLabel.center.y - 80, self.nearbyTableView.bounds.size.width, 50)];
    sadSmiley.backgroundColor = [UIColor clearColor];
    sadSmiley.font = [UIFont fontWithName:@"Avenir-Light" size:50.0];
    sadSmiley.textAlignment = NSTextAlignmentCenter;
    sadSmiley.textColor = [UIColor lightGrayColor];
    sadSmiley.tag = 4322;
    
    sadSmiley.text = @":(";
    
    UIButton *tryAgain = [UIButton buttonWithType:UIButtonTypeSystem];
    [tryAgain setFrame:CGRectMake(noStoresLabel.center.x - 50, noStoresLabel.center.y + 30, 100, 20)];
    [tryAgain setBackgroundColor:[UIColor clearColor]];
    tryAgain.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20.0];
    [tryAgain addTarget:self action:@selector(tryAgain) forControlEvents:UIControlEventTouchUpInside];
    tryAgain.tag = 4323;
    
    [tryAgain setTitle:NSLocalizedString(@"Try Again", nil) forState:UIControlStateNormal];
    
    [self.scrollView insertSubview:noStoresLabel belowSubview:self.loadingView];
    [self.scrollView insertSubview:sadSmiley belowSubview:self.loadingView];
    [self.scrollView insertSubview:tryAgain belowSubview:self.loadingView];
}

- (void)tryAgain
{
    [self showWhiteCoverView];
    [self downloadStoresNearby];
    [self updateMap];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.scrollView viewWithTag:4321].alpha = 0;
                         [self.scrollView viewWithTag:4322].alpha = 0;
                         [self.scrollView viewWithTag:4323].alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [[self.scrollView viewWithTag:4321] removeFromSuperview];
                         [[self.scrollView viewWithTag:4322] removeFromSuperview];
                         [[self.scrollView viewWithTag:4323] removeFromSuperview];
                     }
     ];
}

- (void)hideWhiteCoverView {
    [UIView animateWithDuration:0.3 animations:^{self.loadingView.alpha = 0.0;}];
    [self.loadingAnimation stopAnimating];
}

- (void)showWhiteCoverView {
    [self.loadingAnimation startAnimating];
    [UIView animateWithDuration:0.3 animations:^{self.loadingView.alpha = 1.0;}];
}


#pragma mark - Configure view elements

- (void)configureMapView
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
    lastCoords.latitude = self.locationManager.location.coordinate.latitude;
    lastCoords.longitude = self.locationManager.location.coordinate.longitude;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;     // 0.0 is min value u van provide for zooming
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = lastCoords;     // to locate to the center
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    self.mapView.showsUserLocation = YES;
    
    [self adjustMapViewPosition];
}

- (void)adjustMapViewPosition
{
    self.centerYMapViewConstraint.constant = (deviceScreenHeight - 64.0) / 2 - mapWindowMaxHeight / 2 - 44.0;
    mapOriginalPosition = self.centerYMapViewConstraint.constant;
}

- (void)configureTableViews
{
    self.nearbyTableViewMinHeight = self.view.bounds.size.height - mapWindowMaxHeight;
    self.heightNearByTableViewConstraint.constant = self.nearbyTableViewMinHeight;
    self.nearbyTableView.rowHeight = 70.0;
    self.searchTableView.rowHeight = 70.0;
    self.searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.nearbyTableView.tableFooterView = [self setFoursquareAcknowledgment];
}

- (UIView *)setFoursquareAcknowledgment
{
    UIView *foursquareAcknowledgmentView = [[UIView alloc] init];
    foursquareAcknowledgmentView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44.0);
    
    UIImageView *foursquareAcknowledgmentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Powered By Foursquare"]];
    foursquareAcknowledgmentImage.frame = CGRectMake(0, 0, 210, 35);
    foursquareAcknowledgmentImage.center = foursquareAcknowledgmentView.center;
    
    [foursquareAcknowledgmentView addSubview:foursquareAcknowledgmentImage];
    
    return foursquareAcknowledgmentView;
}

- (void)updateNearbyTableView
{
    CGFloat allCellsHeight = (self.storesNearby.count + 1) * self.nearbyTableView.rowHeight + self.nearbyTableView.tableFooterView.frame.size.height;

    if (allCellsHeight > self.nearbyTableViewMinHeight) {
        self.heightNearByTableViewConstraint.constant = allCellsHeight;
        [self.view layoutIfNeeded];
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loadingAnimation.transform = CGAffineTransformMakeScale(0.001, 0.001);
                         self.loadingMessage.alpha = 0.0;
                     }];
    
    [self performSelector:@selector(hideWhiteCoverView) withObject:nil afterDelay:0.3];
}

- (void)configureLoadingView
{
    self.loadingAnimation.animationImages = [appDelegate loadingAnimationPurpleImages];
    self.loadingAnimation.animationDuration = 0.3;
    [self.loadingAnimation startAnimating];
}


#pragma mark - Table view data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.nearbyTableView]) {
        return self.storesNearby.count + 1; // +1 for the "Didn't find it?" cell
    } else {
        return self.storesSearched.count + 1; // +1 for the "Add store" cell
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreTableViewCell *cell = [self storeCellForIndexPath:indexPath tableView:tableView];
    Store *store;
    
    if ([tableView isEqual:self.nearbyTableView]) {
        if (indexPath.row == self.storesNearby.count && self.storesNearby) {
            return [self configureTrySearchCell:cell];
        } else {
            store = [self.storesNearby objectAtIndex:indexPath.row];
            return [self configureStoreCell:cell store:store];
        }
    } else {
        if (indexPath.row == self.storesSearched.count && self.storesSearched) {
            return [self configureAddStoreCell:cell];
        } else {
            store = [self.storesSearched objectAtIndex:indexPath.row];
            return [self configureStoreCell:cell store:store];
        }
    }
}

- (StoreTableViewCell *)storeCellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoreTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    return cell;
}

- (StoreTableViewCell *)configureStoreCell:(StoreTableViewCell *)cell store:(Store *)store
{
    cell.nameLabel.text = store.name;
    cell.detailLabel.text = [[store.distance stringValue] stringByAppendingString:@" m"];
    [self setStoreIconForCell:cell store:store];
    cell.textLabel.text = nil;
    
    return cell;
}

- (void)setStoreIconForCell:(StoreTableViewCell *)cell store:(Store *)store
{
    if (store.categories.count > 0) {
        NSDictionary *categoryDetails = [store.categories objectAtIndex:0];
        NSString *categoryID = categoryDetails[@"id"];
        if ([StoreCategoriesOrganizer checkIfCategoryExists:categoryID]) {
            UIImage *categoryIcon = [StoreCategoriesOrganizer iconForCategory:categoryID];
            cell.categoryIcon.image = categoryIcon;
        } else {
            cell.categoryIcon.image = [UIImage imageNamed:@"Other_general.png"];
        }
    } else {
        cell.categoryIcon.image = [UIImage imageNamed:@"Other_general.png"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Store *store;
    
    if ([tableView isEqual:self.nearbyTableView]) {
        if (indexPath.row == self.storesNearby.count) {
            [self.searchBar becomeFirstResponder];
            return;
        } else {
            store = [self.storesNearby objectAtIndex:indexPath.row];
        }
    } else {
        if (indexPath.row == self.storesSearched.count) {
            [self pushAddStoreView];
            return;
        } else {
            store = [self.storesSearched objectAtIndex:indexPath.row];
        }
    }
    
    if ([self.cameFrom isEqualToString:@"Edit Deal"]) {
        [self storeSelectedForEditDeal:store];
    } else if ([self.cameFrom isEqualToString:@"Add Deal"]) {
        [self storeSelectedForAddDeal:store];
    }
}

- (void)storeSelectedForAddDeal:(Store *)store
{
    WhatIsTheDeal1 *witd1vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WhatIsTheDeal1ID"];
    witd1vc.store = store;
    [self.navigationController pushViewController:witd1vc animated:YES];
}

- (void)storeSelectedForEditDeal:(Store *)store
{
    EditDealTableViewController *edtvc = (EditDealTableViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    edtvc.store = store;
    edtvc.dealStore.text = edtvc.store.name;
    edtvc.didChangeOriginalDeal = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (StoreTableViewCell *)configureTrySearchCell:(StoreTableViewCell *)cell
{
    cell.textLabel.text = NSLocalizedString(@"Didn't find it? Try Searching", nil);
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    cell.textLabel.textColor = [appDelegate ourPurple];
    cell.categoryIcon.image = [UIImage imageNamed:@"Try Search Icon"];
    cell.nameLabel.text = nil;
    cell.detailLabel.text = nil;
    return cell;
}

- (StoreTableViewCell *)configureAddStoreCell:(StoreTableViewCell *)cell
{
    cell.textLabel.text = NSLocalizedString(@"Add a new store", nil);
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    cell.textLabel.textColor = [appDelegate ourPurple];
    cell.categoryIcon.image = [UIImage imageNamed:@"Add Store Icon"];
    cell.nameLabel.text = nil;
    cell.detailLabel.text = nil;
    return cell;
}

- (void)pushAddStoreView
{
    AddStoreTableViewController *astvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddStore"];
    astvc.searchText = self.searchBar.text;
    astvc.locationManager = self.locationManager;
    [self.navigationController pushViewController:astvc animated:YES];
}


#pragma mark - Search bar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBackgroundButton.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{ self.searchBackgroundButton.alpha = 0.5; }];
    [searchBar setShowsCancelButton:YES animated:YES];
    if (searchBar.text.length > 0) {
        self.searchTableView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{ self.searchTableView.alpha = 0.85; }];
        [self downloadStoresSearched:searchBar.text];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{    
    if (searchText.length == 0) {
        [UIView animateWithDuration:0.2
                         animations:^{ self.searchTableView.alpha = 0; }
                         completion:^(BOOL finished){ self.searchTableView.hidden = YES;}
         ];
        searchTextEmpty = YES;
        
    } else {
        if (searchTextEmpty) {
            self.searchTableView.hidden = NO;
            self.searchTableView.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{ self.searchTableView.alpha = 0.85; }];
        }
        [self downloadStoresSearched:searchText];
        searchTextEmpty = NO;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.searchTableView.alpha = 0;
                         self.searchBackgroundButton.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.searchTableView.hidden = YES;
                         self.searchBackgroundButton.hidden = YES;
                     }];
    [self.nearbyTableView deselectRowAtIndexPath:self.nearbyTableView.indexPathForSelectedRow animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.searchTableView.hidden) {
        self.searchTableView.hidden = NO;
        self.searchTableView.alpha = 0;
        [self downloadStoresSearched:searchBar.text];
    } else {
        self.searchTableView.contentInset = UIEdgeInsetsZero;
        self.searchTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }
    [UIView animateWithDuration:0.2 animations:^{ self.searchTableView.alpha = 1.0; }];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (IBAction)closeSearchView:(id)sender
{
    [UIView animateWithDuration:0.2
                     animations:^{ self.searchBackgroundButton.alpha = 0.0; }
                     completion:^(BOOL finished) { self.searchBackgroundButton.hidden = YES; }
     ];
    self.searchTableView.hidden = YES;
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.nearbyTableView deselectRowAtIndexPath:self.nearbyTableView.indexPathForSelectedRow animated:YES];
}

- (void)updateSearchTableViewInsetsForKeyboardHeight:(CGFloat)height
{
    self.searchTableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
    self.searchTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, height, 0);
}


#pragma mark - Actions

- (IBAction)showMap:(id)sender
{
    [self.view layoutIfNeeded];
    self.centerYMapViewConstraint.constant = 0;
    self.verticalSpaceSearchBarScrollViewConstraint.constant = deviceScreenHeight - 65.0 - 44.0; // The substractions are for the nav bar and search bar respectively
    [UIView animateWithDuration:0.6
                     animations:^{[self.view layoutIfNeeded];}
                     completion:^(BOOL finished){[self presentCloseMapButton];}];
}

- (IBAction)hideMap:(id)sender
{
    [self.view layoutIfNeeded];
    self.centerYMapViewConstraint.constant = mapOriginalPosition;
    self.verticalSpaceSearchBarScrollViewConstraint.constant = 0;
    self.verticalSpaceHideMapButtonConstraint.constant = deviceScreenHeight - 65.0;
    [self updateMap];
    [UIView animateWithDuration:0.6
                     animations:^{
                         [self.view layoutIfNeeded];
                         self.hideMapButton.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         self.hideMapButton.alpha = 1.0;
                         self.verticalSpaceHideMapButtonConstraint.constant = -58.0;
                     }];
}
     
- (void)presentCloseMapButton
{
    self.verticalSpaceHideMapButtonConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{[self.view layoutIfNeeded];}];
}

- (void)updateMap
{
    lastCoords.latitude = self.locationManager.location.coordinate.latitude;
    lastCoords.longitude = self.locationManager.location.coordinate.longitude;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = lastCoords;
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
    
    [self adjustMapViewPosition];
}


@end
