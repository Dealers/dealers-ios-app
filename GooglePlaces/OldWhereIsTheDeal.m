//
//  TableViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/23/13.
//
//

#import "OldWhereIsTheDeal.h"
#import "WhatIsTheDeal1.h"
#import "StoreTableViewCell.h"
#import <mach/mach.h>
#import "EditDealTableViewController.h"

#define CLIENTID @"JK4EFCX00FOCQX5TKMCFDTGX2J03IAAG1NQM2SZN4G5FXG4O"
#define CLIENTSECRET @"5XLGKL4023AKUAQWUFXRGM1JT1GBEXKRY4RIAB4WIO4TH53G"
#define VERSION @"20140201"

#define barTableGap 152 // The gap between the bottom of the search bar and the top of the venues table view.
#define keyboardHeight 216

@interface OldWhereIsTheDeal ()

@end


@implementation OldWhereIsTheDeal {
    WhatIsTheDeal1 *witd1vc;
}

@synthesize foursquareManager, appDelegate;

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

- (void)setTableView {
    [self.scrollView setContentSize:((CGSizeMake(320, ([self.storesNearby count]*70+barTableGap+self.venuesTableView.tableFooterView.frame.size.height))))];
    
    self.venuesTableView.frame = CGRectMake(0, barTableGap, [[UIScreen mainScreen] bounds].size.width, ([self.storesNearby count]*70 + self.venuesTableView.tableFooterView.frame.size.height));
    self.whiteCoverView.frame = self.venuesTableInitialFrame;
    
    if ([self.storesNearby count] == 0 && loadsuc) {
        [self errorLoadingStores: @"No stores around"];
    } else if (self.venuesTableView.frame.size.height < self.venuesTableInitialFrame.size.height) {
        self.venuesTableView.frame = self.venuesTableInitialFrame;
        self.venuesTableView.backgroundColor = [UIColor whiteColor];
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loadingImage.alpha = 1.0;
                         self.loadingImage.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     }];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loadingLabel.alpha = 0.0;
                         self.loadingLabel.center = CGPointMake(self.loadingLabel.center.x,self.loadingLabel.center.y+10);
                     }];
    
    [self performSelector:@selector(hideWhiteCoverView) withObject:nil afterDelay:0.3];
}

- (void)hideWhiteCoverView {
    [UIView animateWithDuration:0.3 animations:^{self.whiteCoverView.alpha = 0.0;}];
    [self.loadingImage stopAnimating];
}

- (void)showWhiteCoverView {
    [self.loadingImage startAnimating];
    [UIView animateWithDuration:0.3 animations:^{self.whiteCoverView.alpha = 1.0;}];
}

- (void)errorLoadingStores:(NSString *)error {
    UILabel *noStoresLabel = [[UILabel alloc]initWithFrame:self.venuesTableInitialFrame];
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
    
    UILabel *sadSmiley = [[UILabel alloc]initWithFrame:CGRectMake(0, noStoresLabel.center.y - 80, 320, 50)];
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
    
    [self.scrollView insertSubview:noStoresLabel belowSubview:self.whiteCoverView];
    [self.scrollView insertSubview:sadSmiley belowSubview:self.whiteCoverView];
    [self.scrollView insertSubview:tryAgain belowSubview:self.whiteCoverView];
}

- (void)tryAgain
{
    [self showWhiteCoverView];
    [self loadStoresNearby];
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

-(void) displayLoadingIcon {
    self.loadingImage.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"loading.png"],
                                         [UIImage imageNamed:@"loading5.png"],
                                         [UIImage imageNamed:@"loading10.png"],
                                         [UIImage imageNamed:@"loading15.png"],
                                         [UIImage imageNamed:@"loading20.png"],
                                         [UIImage imageNamed:@"loading25.png"],
                                         [UIImage imageNamed:@"loading30.png"],
                                         [UIImage imageNamed:@"loading35.png"],
                                         [UIImage imageNamed:@"loading40.png"],
                                         [UIImage imageNamed:@"loading45.png"],
                                         [UIImage imageNamed:@"loading50.png"],
                                         [UIImage imageNamed:@"loading55.png"],
                                         [UIImage imageNamed:@"loading60.png"],
                                         [UIImage imageNamed:@"loading65.png"],
                                         [UIImage imageNamed:@"loading70.png"],
                                         [UIImage imageNamed:@"loading75.png"],
                                         [UIImage imageNamed:@"loading80.png"],
                                         [UIImage imageNamed:@"loading85.png"],
                                         nil];
    self.loadingImage.animationDuration = 0.3;
    [self.loadingImage startAnimating];
    self.loadingImage.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loadingImage.alpha = 1.0;
                         self.loadingImage.transform = CGAffineTransformMakeScale(1,1);
                     }];
}

-(void) initialize {
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [self displayLoadingIcon];
    self.storeSearchTableView.hidden = YES;
    //self.closeStoreSearchTableButton.hidden=YES;
    self.closeStoreSearchTableButton.alpha = 0.0;
}

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"Where is the deal?", nil);
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // This is the size of the venues table view in the initial display of the view:
    self.venuesTableInitialFrame = CGRectMake(0, barTableGap, 320, [[UIScreen mainScreen]bounds].size.height - 64 - 44 - barTableGap);
    
    // If came frome Edit Deal, no need for dismiss button:
    if ([self.cameFrom isEqualToString:@"Edit Deal"]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    witd1vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WhatIsTheDeal1ID"];
    
    self.collapseMapButton.hidden = YES;
    currentVC = 1;
    self.storesNearby = [[NSMutableArray alloc] init];
    
    self.venuesTableView.scrollEnabled = NO;
    self.venuesTableView.tableFooterView = [self setFoursquareAcknowledgment];
    
    [self configureRestKit];
    
    [super viewDidLoad];
}

-(void) deallocMapView {
    switch (_mapView.mapType) {
        case MKMapTypeHybrid:
        {
            _mapView.mapType = MKMapTypeStandard;
        }
            
            break;
        case MKMapTypeStandard:
        {
            _mapView.mapType = MKMapTypeHybrid;
        }
            
            break;
        default:
            break;
    }
    
    [_mapView removeFromSuperview];
    _mapView.showsUserLocation = NO;
    _mapView=nil;
    [_locationManager stopUpdatingLocation];
}

-(void)didReceiveMemoryWarning{
    if (currentVC) {
        [self deallocMapView];
        NSArray *viewsToRemove = [_scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];}
        _venuesTableView.frame = CGRectMake(0, 0, _venuesTableView.frame.size.height, ([[UIScreen mainScreen] bounds].size.height));
        [_scrollView addSubview:_venuesTableView];
        currentVC=1;
    }
    [super didReceiveMemoryWarning];
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    foursquareManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
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
    
    [foursquareManager addResponseDescriptor:responseDescriptor];
}

- (void)loadStoresSearched:(NSString *)text
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
    
    [foursquareManager getObjectsAtPath:@"/v2/venues/search"
                             parameters:queryParams
                                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                    
                                    self.storesSearched = [self filterStores:mappingResult.array];
                                    
                                    self.app.networkActivityIndicatorVisible = NO;
                                    [self.storeSearchTableView reloadData];
                                }
                                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                    NSLog(@"There was an error with the loading of the store search: %@", error);
                                    self.app.networkActivityIndicatorVisible = NO;
                                }];
    for (Store *store in self.storesSearched) {
        NSLog(@" \n store name: %@ \n store lat: %@ \n store url: %@ \n store verified? %@ ", store.name,store.latitude,store.url,store.verifiedByFoursquare);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.venuesTableView) {
        return self.storesNearby.count;
        
    } else return self.storesSearched.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.venuesTableView) {
        
        static NSString *cellIdentifier = @"StoresTableCell";
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoresTableCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Store *store = [self.storesNearby objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = store.name;
        cell.detailLabel.text = [[store.distance stringValue] stringByAppendingString:@" m"];
        
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
        
        return cell;
        
    } else if (tableView == self.storeSearchTableView) {
        
        
        self.storeSearchTableView.hidden = NO;
        static NSString *cellIdentifier = @"StoresTableCell";
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoresTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (self.storesSearched) {
            Store *store = [self.storesSearched objectAtIndex:indexPath.row];
            cell.nameLabel.text = store.name;
            cell.detailLabel.text = store.address;
            
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
            
            return cell;
        }
    }
    // In case no condition exists:
    UITableViewCell *cell = nil;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
    
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

- (IBAction)Dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction) enlargeMapButtonClicked:(id)sender {
    self.enlargeMapButton.hidden=YES;
    
    self.collapseMapButton.center = CGPointMake(self.collapseMapButton.center.x, [[UIScreen mainScreen]bounds].size.height + self.collapseMapButton.frame.size.height);
    self.collapseMapButton.hidden=NO;
    
    [UIView animateWithDuration:0.3 animations:^{self.mapView.frame = self.scrollView.bounds;}];
    
    CGRect frame = self.venuesTableView.frame;
    frame.origin.y = frame.origin.y + 500;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{self.venuesTableView.frame = frame;} completion:nil];
    CGRect frame3 = self.theShadow.frame;
    frame3.origin.y = frame3.origin.y + 500;
    [UIView animateWithDuration:0.4 animations:^{self.theShadow.frame = frame3;} completion:^(BOOL finished)
     {[UIView animateWithDuration:0.5 animations:^{self.collapseMapButton.center = CGPointMake(self.collapseMapButton.center.x, [[UIScreen mainScreen]bounds].size.height - self.collapseMapButton.frame.size.height / 2);}];}];
}

-(IBAction) collapseMapButtonClicked:(id)sender {
    self.enlargeMapButton.hidden=NO;
    self.collapseMapButton.hidden=YES;
    [UIView animateWithDuration:0.4 animations:^{self.mapView.center = CGPointMake(self.mapView.center.x, barTableGap / 2);}];
    CGRect frame = self.venuesTableView.frame;
    frame.origin.y = frame.origin.y - 500;
    [UIView animateWithDuration:0.4 animations:^{self.venuesTableView.frame = frame;}];
    CGRect frame3 = self.theShadow.frame;
    frame3.origin.y = frame3.origin.y - 500;
    [UIView animateWithDuration:0.4 animations:^{self.theShadow.frame = frame3;}];
    
    // Getting back to the original location of the user:
    lastCoords.latitude = _locationManager.location.coordinate.latitude;
    lastCoords.longitude = _locationManager.location.coordinate.longitude;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta= 0.01;
    region.span = span;
    region.center = lastCoords;
    [self.mapView setRegion:region animated:YES];
}

- (void)sendToFoursquareAndUpdateWithText:(NSString *)text
{
    [self loadStoresSearched:text];
}

-(void) LoadStoresTableView {
    if (SearchTextSize) [self.storeSearchTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) {
        self.storeSearchNameArray = nil;
        self.storeSearchLocationArray = nil;
        [UIView animateWithDuration:0.2
                         animations:^{ self.storeSearchTableView.alpha = 0; }
                         completion:^(BOOL finished) { self.storeSearchTableView.hidden = YES;}
         ];
        SearchTextSize = 0;
        
    } else {
        if (SearchTextSize != 1) {
            self.storeSearchTableView.hidden = NO;
            self.storeSearchTableView.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{ self.storeSearchTableView.alpha = 0.85; }];
        }
        [self sendToFoursquareAndUpdateWithText:searchText];
        SearchTextSize = 1;
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    if (!self.storesSearched) {
        self.storesSearched = [[NSMutableArray alloc]init];
    }
    
    self.closeStoreSearchTableButton.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{ self.closeStoreSearchTableButton.alpha = 0.5; }];
    self.storeSearchTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
    self.storeSearchTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
    [searchBar setShowsCancelButton:YES animated:YES];
    if (searchBar.text.length > 0) {
        self.storeSearchTableView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{ self.storeSearchTableView.alpha = 0.85; }];
        [self sendToFoursquareAndUpdateWithText:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [UIView animateWithDuration:0.2
                     animations:^{ self.storeSearchTableView.alpha = 0; }
                     completion:^(BOOL finished) { self.storeSearchTableView.hidden = YES;}
     ];
    [UIView animateWithDuration:0.2
                     animations:^{ self.closeStoreSearchTableButton.alpha = 0; }
                     completion:^(BOOL finished) { self.closeStoreSearchTableButton.hidden = YES;}
     ];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat y = scrollView.contentOffset.y;
        CGFloat mapCenter = (y + 64 + barTableGap) / 2; // The offset in iOS7 navigation controller is by default -64. So first +64, and then plus the gap between the bar and the table.
        self.mapView.center = CGPointMake(160, mapCenter);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.venuesTableView) {
        
        if ([self.cameFrom isEqualToString:@"Edit Deal"]) {
            
            EditDealTableViewController *edtvc = (EditDealTableViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
            edtvc.store = [self.storesNearby objectAtIndex:indexPath.row];
            edtvc.dealStore.text = edtvc.store.name;
            edtvc.didChangeOriginalDeal = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
        } else if ([self.cameFrom isEqualToString:@"Add Deal"]) {
            
            witd1vc.store = [self.storesNearby objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:witd1vc animated:YES];
        }
        
    } else if (tableView == self.storeSearchTableView) {
        
        if ([self.cameFrom isEqualToString:@"Edit Deal"]) {
            
            EditDealTableViewController *edtvc = (EditDealTableViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
            edtvc.store = [self.storesSearched objectAtIndex:indexPath.row];
            edtvc.dealStore.text = edtvc.store.name;
            edtvc.didChangeOriginalDeal = YES;
            [self.navigationController popViewControllerAnimated:YES];
        
        } else if ([self.cameFrom isEqualToString:@"Add Deal"]) {
            
            witd1vc.store = [self.storesSearched objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:witd1vc animated:YES];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (self.storeSearchTableView.isHidden) {
        self.storeSearchTableView.hidden = NO;
        self.storeSearchTableView.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{ self.storeSearchTableView.alpha = 1.0; }];
        [self sendToFoursquareAndUpdateWithText:self.SearchBar.text];
        [self.SearchBar resignFirstResponder];
        [self.SearchBar setShowsCancelButton:NO animated:YES];
    } else {
        self.storeSearchTableView.contentInset = UIEdgeInsetsZero;
        self.storeSearchTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
        [UIView animateWithDuration:0.2 animations:^{ self.storeSearchTableView.alpha = 1.0; }];
        [self.SearchBar resignFirstResponder];
        [searchBar setShowsCancelButton:NO animated:YES];
    }
}

-(void) closeStoreSearchTableButtonClicked:(id)sender {
    [UIView animateWithDuration:0.2
                     animations:^{ self.closeStoreSearchTableButton.alpha = 0.0; }
                     completion:^(BOOL finished) { self.closeStoreSearchTableButton.hidden = YES; }
     ];
    self.storeSearchTableView.hidden = YES;
    [self.SearchBar resignFirstResponder];
    [self.SearchBar setShowsCancelButton:NO animated:YES];
}

-(void) initMapView {
    
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, self.scrollView.bounds.size.height)];
    self.mapView.center = CGPointMake(160, barTableGap / 2);
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    _locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [_locationManager startUpdatingLocation];
    lastCoords.latitude = _locationManager.location.coordinate.latitude;
    lastCoords.longitude = _locationManager.location.coordinate.longitude;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;     // 0.0 is min value u van provide for zooming
    span.longitudeDelta= 0.01;
    region.span=span;
    region.center =lastCoords;     // to locate to the center
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    self.mapView.showsUserLocation=YES;
    [self.scrollView addSubview:self.mapView];
    [self.scrollView sendSubviewToBack:_mapView];
}

- (void)loadStoresNearby
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
    
    [foursquareManager getObjectsAtPath:@"/v2/venues/search"
                             parameters:queryParams
                                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                    
                                    self.storesNearby = [self filterStores:mappingResult.array];
                                    
                                    self.app.networkActivityIndicatorVisible = NO;
                                    [self.venuesTableView reloadData];
                                    [self setTableView];
                                    loadsuc = YES;
                                }
                                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                    
                                    NSLog(@"There was an error with the loading of the stores nearby: %@", error);
                                    self.app.networkActivityIndicatorVisible = NO;
                                    loadsuc = NO;
                                    [self errorLoadingStores:@"Connection error"];
                                    [self performSelector:@selector(hideWhiteCoverView) withObject:nil afterDelay:0.3];
                                }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initialize];
    [self initMapView];
    if (currentVC) {
        [self loadStoresNearby];
        self.app.networkActivityIndicatorVisible = YES;
    }
    currentVC = 1;
    [self.venuesTableView deselectRowAtIndexPath:self.venuesTableView.indexPathForSelectedRow animated:YES];
    [self.storeSearchTableView deselectRowAtIndexPath:self.storeSearchTableView.indexPathForSelectedRow animated:YES];
    [self.SearchBar setShowsScopeBar:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    currentVC = 0;
    [self deallocMapView];
}

-(void) report_memory {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@"Memory in use (in bytes): %lu", (unsigned long)info.resident_size);
        NSString *a=[NSString stringWithFormat:@"%lu",(unsigned long)info.resident_size/1000000];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:a delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
        NSString *a=[NSString stringWithFormat:@"%s",mach_error_string(kerr)];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:a delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}
@end
