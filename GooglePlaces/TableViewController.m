//
//  TableViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/23/13.
//
//

#import "TableViewController.h"
#import "OptionalaftergoogleplaceViewController.h"
#import "StoresTableCell.h"
#import "Functions.h"
#import <mach/mach.h>
#import "CheckConnection.h"
#import "EditDealTableViewController.h"

#define CLIENTID @"JK4EFCX00FOCQX5TKMCFDTGX2J03IAAG1NQM2SZN4G5FXG4O"
#define CLIENTSECRET @"5XLGKL4023AKUAQWUFXRGM1JT1GBEXKRY4RIAB4WIO4TH53G"
#define VERSION @"20140201"

#define barTableGap 152 // The gap between the bottom of the search bar and the top of the venues table view.
#define keyboardHeight 216

@interface TableViewController ()

@end

@implementation TableViewController {
    OptionalaftergoogleplaceViewController *oagpvc;
}

-(void) connectionProblem {
    [_mapView removeFromSuperview];
    UIButton *selectDealButton9=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton9 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton9.frame=[[UIScreen mainScreen] bounds];
    selectDealButton9.tag=110;
    [selectDealButton9 setBackgroundColor:[UIColor whiteColor]];
    selectDealButton9.alpha=0.7;
    [[self view] addSubview:selectDealButton9];
    [[self view] bringSubviewToFront:selectDealButton9];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Check your network connection" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}

-(BOOL) loadStoresFromFoursquare {
    CheckConnection *checkconnection = [[CheckConnection alloc]init];
    if ([checkconnection connected]) {
        if (_locationManager.location.coordinate.latitude > 0) {
            Functions *func = [[Functions alloc]init];
            NSString * url= [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&client_id=JK4EFCX00FOCQX5TKMCFDTGX2J03IAAG1NQM2SZN4G5FXG4O&client_secret=5XLGKL4023AKUAQWUFXRGM1JT1GBEXKRY4RIAB4WIO4TH53G&radius=9000&v=20140201",_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude];
            NSLog(@"url form FQ api:%@",url);
            NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
            NSData *data = [NSData dataWithContentsOfURL: googleRequestURL];
            NSError* error;
            
            
            if (data!=nil) {
                NSDictionary* json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&error];
                NSDictionary *responseData = json[@"response"];
                NSArray *venues = responseData[@"venues"];
                
                NSMutableArray *storeNameArray=[[NSMutableArray alloc] init];
                NSMutableArray *storeLocationArray=[[NSMutableArray alloc]init];
                NSMutableArray *storeIconArray=[[NSMutableArray alloc]init];
                NSMutableArray *storeDistanceArray=[[NSMutableArray alloc]init];
                NSMutableArray *storeCategoryArray=[[NSMutableArray alloc]init];
                NSMutableArray *storeLongArray=[[NSMutableArray alloc]init];
                NSMutableArray *storeLatArray=[[NSMutableArray alloc]init];
                
                for (int i=0; i<[[venues copy] count]; i++)
                {
                    NSString *categoryId = [[NSString alloc]init];
                    NSDictionary *storeArrayFromVenues = [venues objectAtIndex:i];
                    NSString *storeName = [storeArrayFromVenues objectForKey:@"name"];
                    NSString *vicinity=[[storeArrayFromVenues objectForKey:@"location"]objectForKey:@"address"];
                    NSString *lng=[[storeArrayFromVenues objectForKey:@"location"]objectForKey:@"lng"];
                    NSString *lat=[[storeArrayFromVenues objectForKey:@"location"]objectForKey:@"lat"];
                    NSString *distance=[[storeArrayFromVenues objectForKey:@"location"]objectForKey:@"distance"];
                    NSArray *categoryArrayFromVenues=storeArrayFromVenues[@"categories"];
                    UIImageView *tempimage = [[UIImageView alloc]init];
                    
                    if (storeName==nil) storeName=@"";
                    if (vicinity==nil) vicinity=@"";
                    if (distance==nil) distance=@"";
                    
                    if ([categoryArrayFromVenues count] > 0) {
                        NSDictionary *categoryIdArray=[storeArrayFromVenues[@"categories"] objectAtIndex:0];
                        categoryId = categoryIdArray[@"id"];
                        if ([func CheckIfCategoryExist:categoryId]) {
                            NSString *ImageName=[func ConnectOldCategoryToNewCategory:categoryId];
                            if (ImageName!=NULL) {
                                tempimage.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@",ImageName]];
                                NSArray *CategoryNameArray = [ImageName componentsSeparatedByString:@"_"];
                                NSString *CategoryName=[CategoryNameArray objectAtIndex:0];
                                CategoryName = [CategoryName stringByReplacingOccurrencesOfString:@"@" withString:@"&"];
                                [storeNameArray addObject:storeName];
                                [storeLocationArray addObject:vicinity]; //vicinity
                                [storeCategoryArray addObject:CategoryName];
                                [storeIconArray addObject:tempimage];
                                [storeDistanceArray addObject:distance];
                                [storeLatArray addObject:lat];
                                [storeLongArray addObject:lng];
                            }
                        }
                    }
                }
                
                
                self.storeNameArraySort=[[NSMutableArray alloc]init];
                self.storeLocationArraySort=[[NSMutableArray alloc]init];
                self.storeIconArraySort=[[NSMutableArray alloc]init];
                self.storeDistanceArraySort=[[NSMutableArray alloc]init];
                self.storeCategoryArraySort=[[NSMutableArray alloc]init];
                self.storeLongArraySort=[[NSMutableArray alloc]init];
                self.storeLatArraySort=[[NSMutableArray alloc]init];
                
                
                if ([storeDistanceArray count]==[storeNameArray count]) {
                    for (int i=0; i<[[storeNameArray copy] count]; i++){
                        int index;
                        int min = 10000;
                        for (int j=0; j<[[storeNameArray copy] count]; j++) {
                            NSString *number;
                            if (j<[storeDistanceArray count]) {
                                number = [storeDistanceArray objectAtIndex:j];
                            } else number=@"0";
                            int minNumber = [number intValue];
                            if (minNumber<min) {
                                index=j;
                                min=minNumber;
                            }
                        }
                        
                        if (index<[storeNameArray count]) {
                            [self.storeNameArraySort addObject:[storeNameArray objectAtIndex:index]];
                            
                        } else [self.storeNameArraySort addObject:@"0"];
                        
                        if (index<[storeLocationArray count]) {
                            [self.storeLocationArraySort addObject:[storeLocationArray objectAtIndex:index]];
                            
                        } else [self.storeLocationArraySort addObject:@"0"];
                        
                        if (index<[storeIconArray count]) {
                            [self.storeIconArraySort addObject:[storeIconArray objectAtIndex:index]];
                            
                        } else [self.storeIconArraySort addObject:@"0"];
                        
                        if (index<[storeDistanceArray count]) {
                            [self.storeDistanceArraySort addObject:[storeDistanceArray objectAtIndex:index]];
                            
                        }else [self.storeDistanceArraySort addObject:@"0"];
                        
                        if (index<[storeCategoryArray count]) {
                            [self.storeCategoryArraySort addObject:[storeCategoryArray objectAtIndex:index]];
                            
                        }else [self.storeDistanceArraySort addObject:@"0"];
                        
                        if (index<[storeLongArray count]) {
                            [self.storeLongArraySort addObject:[storeLongArray objectAtIndex:index]];
                            
                        }else [self.storeLongArraySort addObject:@"0"];
                        
                        if (index<[storeLatArray count]) {
                            [self.storeLatArraySort addObject:[storeLatArray objectAtIndex:index]];
                            
                        }else [self.storeLatArraySort addObject:@"0"];
                        
                        [storeDistanceArray replaceObjectAtIndex:index withObject:@"100000"];
                    }
                }
            }
            
        }//if locationmanager
        else {
            return NO;
        }
    }//if connection
    else {
        return NO;
    }
    return YES;
}

-(void) mainMethod {
    [self.venuesTableView reloadData];
    [self.scrollView setContentSize:((CGSizeMake(320, ([self.storeNameArraySort count]*70+barTableGap))))];
    
    self.venuesTableView.frame = CGRectMake(0, barTableGap, 320, ([self.storeNameArraySort count]*70));
    self.whiteCoverView.frame = self.venuesTableInitialFrame;
    
    if ([self.storeNameArraySort count] == 0 && loadsuc) {
        [self noStoresAround];
    } else if (self.venuesTableView.frame.size.height < self.venuesTableInitialFrame.size.height) {
        self.venuesTableView.frame = self.venuesTableInitialFrame;
        self.venuesTableView.backgroundColor = [UIColor whiteColor];
    }
    
    [UIView animateWithDuration:0.3 animations:^{self.loadingImage.alpha=1.0; self.loadingImage.transform = CGAffineTransformMakeScale(0,0);}];
    [UIView animateWithDuration:0.3 animations:^{self.loadingLabel.alpha=0.0; self.loadingLabel.center = CGPointMake(self.loadingLabel.center.x,self.loadingLabel.center.y+10);}];
    [self performSelector:@selector(hideWhiteCoverView) withObject:nil afterDelay:0.3];
}

-(void) hideWhiteCoverView {
    [UIView animateWithDuration:0.3 animations:^{self.whiteCoverView.alpha=0.0;}];
    [self.loadingImage stopAnimating];
    // [self report_memory];
}

- (void)noStoresAround {
    UILabel *noStoresLabel = [[UILabel alloc]initWithFrame:self.venuesTableInitialFrame];
    noStoresLabel.backgroundColor = [UIColor whiteColor];
    noStoresLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20.0];
    noStoresLabel.textAlignment = NSTextAlignmentCenter;
    noStoresLabel.textColor = [UIColor lightGrayColor];
    
    noStoresLabel.text = @"No stores were found around you";
    
    UILabel *sadSmiley = [[UILabel alloc]initWithFrame:CGRectMake(0, noStoresLabel.center.y - 80, 320, 50)];
    sadSmiley.backgroundColor = [UIColor clearColor];
    sadSmiley.font = [UIFont fontWithName:@"Avenir-Light" size:50.0];
    sadSmiley.textAlignment = NSTextAlignmentCenter;
    sadSmiley.textColor = [UIColor lightGrayColor];
    
    sadSmiley.text = @":(";
    
    UIButton *tryAgain = [UIButton buttonWithType:UIButtonTypeSystem];
    [tryAgain setFrame:CGRectMake(noStoresLabel.center.x - 50, noStoresLabel.center.y + 30, 100, 20)];
    [tryAgain setBackgroundColor:[UIColor clearColor]];
    tryAgain.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20.0];
    [tryAgain addTarget:self action:@selector(loadFoursquareaAfterDelay) forControlEvents:UIControlEventTouchUpInside];
    
    [tryAgain setTitle:@"Try Again" forState:UIControlStateNormal];
    
    [self.scrollView insertSubview:noStoresLabel belowSubview:self.whiteCoverView];
    [self.scrollView insertSubview:sadSmiley belowSubview:self.whiteCoverView];
    [self.scrollView insertSubview:tryAgain belowSubview:self.whiteCoverView];
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
    [UIView animateWithDuration:0.3 animations:^{self.loadingImage.alpha=1.0; self.loadingImage.transform =CGAffineTransformMakeScale(0,0);
        self.loadingImage.transform =CGAffineTransformMakeScale(1,1);}];
}

-(void) initialize {
    [self displayLoadingIcon];
    self.storeSearchTableView.hidden = YES;
    //self.closeStoreSearchTableButton.hidden=YES;
    self.closeStoreSearchTableButton.alpha = 0.0;
}

- (void)viewDidLoad
{
    self.title = @"Where is the Deal?";
    
    // This is the size of the venues table view in the initial display of the view:
    self.venuesTableInitialFrame = CGRectMake(0, barTableGap, 320, [[UIScreen mainScreen]bounds].size.height - 64 - 44 - barTableGap);
    
    // If came frome Edit Deal, no need for dismiss button:
    if ([self.cameFrom isEqualToString:@"editDeal"]) {
        self.navigationItem.leftBarButtonItem = NO;
    }
    
    oagpvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Optional"];
    
    self.collapseMapButton.hidden = YES;
    currentVC = 1;
    self.storesNearby = [[NSMutableArray alloc]init];
    
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
        NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=crash&crashtext='foursquare'"];
        [_scrollView addSubview:_venuesTableView];
        NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
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
    RKObjectManager *foursquareManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *storeMapping = [RKObjectMapping mappingForClass:[Store class]];
    [storeMapping addAttributeMappingsFromDictionary:@{
                                                       @"id" : @"foursquareID",
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
                                  @"query" : text
                                  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.storesSearched = mappingResult.array;
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
        if ([self.storeNameArraySort count] == 0) {
            return 0;
        }
        return [self.storeNameArraySort count];
    } else return [self.storesSearched count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Functions *func = [[Functions alloc]init];
    
    if (tableView == self.venuesTableView) {
        
        static NSString *cellIdentifier = @"StoresTableCell";
        StoresTableCell *cell = (StoresTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoresTableCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if ([self.storeNameArraySort count] > 0){
            if (indexPath.row < [self.storeNameArraySort count]) {
                cell.nameLabel.text = [self.storeNameArraySort objectAtIndex:indexPath.row];
            } else cell.nameLabel.text = @"Unknown";
            if (indexPath.row < [self.storeDistanceArraySort count]) {
                cell.detailLabel.text = [NSString stringWithFormat:@"%@m",[self.storeDistanceArraySort objectAtIndex:indexPath.row]];
            } else cell.detailLabel.text=@"Unknown";
            if (indexPath.row < [self.storeIconArraySort count]) {
                UIImageView *tempImage = [self.storeIconArraySort objectAtIndex:(indexPath.row)];
                cell.categoryIcon.image = tempImage.image;
            } else {
                cell.categoryIcon.image = [UIImage imageNamed:@"Other_general.png"];
            }
            return cell;
        }
    
    } else if (tableView == self.storeSearchTableView) {
        
        
        self.storeSearchTableView.hidden = NO;
        static NSString *cellIdentifier = @"StoresTableCell";
        StoresTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
                if ([func CheckIfCategoryExist:categoryID]) {
                    UIImage *categoryIcon = [UIImage imageNamed:[func ConnectOldCategoryToNewCategory:categoryID]];
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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"StoreSearchSeq"]) {
        NSIndexPath *indexpath = [self.storeSearchTableView indexPathForSelectedRow];
        NSString *string = [self.storeSearchNameArray objectAtIndex:indexpath.row];
        [[segue destinationViewController] setStoreName:string];
        [[segue destinationViewController] setSegcategory:@"No Category"];
    }
}

- (void)passingStoreToOptionals
{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"local";
    
    NSIndexPath *indexpath = [self.venuesTableView indexPathForSelectedRow];
    NSString *string;
    NSString *string2;
    NSString *string3;
    NSString *string4;
    NSString *string5;
    
    if (indexpath.row<[self.storeNameArraySort count]) {
        string = [self.storeNameArraySort objectAtIndex:indexpath.row];
    } else string=@"Unknown";
    if (indexpath.row<[self.storeCategoryArraySort count]) {
        string2 = [self.storeCategoryArraySort objectAtIndex:indexpath.row];
    } else string2=@"Unknown";
    if (indexpath.row<[self.storeLatArraySort count]) {
        string3 = [self.storeLatArraySort objectAtIndex:indexpath.row];
    } else string3=@"0";
    if (indexpath.row<[self.storeLongArraySort count]) {
        string4 = [self.storeLongArraySort objectAtIndex:indexpath.row];
    } else string4=@"0";
    if (indexpath.row<[self.storeLocationArraySort count]) {
        string5 = [self.storeLocationArraySort objectAtIndex:indexpath.row];
    } else string5=@"Unknown";
    
    [oagpvc setStoreName:string];
    [oagpvc setSegcategory:string2];
    [oagpvc setSeglat:string3];
    [oagpvc setSeglong:string4];
    [oagpvc setSegstoreAddress:string5];
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
    region.span=span;
    region.center =lastCoords;
    [self.mapView setRegion:region animated:TRUE];
}

- (void)sendToFoursquareAndUpdateWithText:(NSString *)text
{
    self.app.networkActivityIndicatorVisible = YES;
    [self loadStoresSearched:text];
    
    /*
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        [self storeSearchFromFoursquer:text];
        // Update UI after computation.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI on the main thread.
            [self LoadStoresTableView];
        });
    });
     */
}

- (void)storeSearchFromFoursquer:(NSString *)text
{
    self.storeSearchNameArray = nil;
    self.storeSearchLocationArray = nil;
    self.storeSearchNameArray = [[NSMutableArray alloc]init];
    self.storeSearchLocationArray = [[NSMutableArray alloc]init];
    
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=JK4EFCX00FOCQX5TKMCFDTGX2J03IAAG1NQM2SZN4G5FXG4O&client_secret=5XLGKL4023AKUAQWUFXRGM1JT1GBEXKRY4RIAB4WIO4TH53G&v=20131120&query=%@&intent=global&limit=50",text];
    NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL: googleRequestURL];
    NSError *error;
    if (data != nil) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        NSDictionary *responseData = json[@"response"];
        NSArray *venues = responseData[@"venues"];
        for (int i=0; i<[[venues copy] count]; i++)
        {
            NSDictionary *storeArrayFromVenues = [venues objectAtIndex:i];
            NSString *storeName = [storeArrayFromVenues objectForKey:@"name"];
            NSString *vicinity = [[storeArrayFromVenues objectForKey:@"location"]objectForKey:@"address"];
            if (storeName == nil) storeName = @"";
            if (vicinity == nil) continue; //vicinity=@"Unknown";
            
            [self.storeSearchNameArray addObject:storeName];
            [self.storeSearchLocationArray addObject:vicinity];
        }
    }
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
        
        // Need to check this with Itzik regarding the store info.
        
        if ([self.cameFrom isEqualToString:@"editDeal"]) {
            EditDealTableViewController *edtvc = (EditDealTableViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
            edtvc.currentDeal.store = [self.storeNameArraySort objectAtIndex:indexPath.row];
            edtvc.currentDeal.dealStoreAddress = [self.storeLocationArraySort objectAtIndex:indexPath.row];
            edtvc.currentDeal.dealStoreLatitude = [self.storeLatArraySort objectAtIndex:indexPath.row];
            edtvc.currentDeal.dealStoreLongitude = [self.storeLongArraySort objectAtIndex:indexPath.row];
            edtvc.didChangeOriginalDeal = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
        } else if ([self.cameFrom isEqualToString:@"addDeal"]) {
            [self passingStoreToOptionals];
            [self.navigationController pushViewController:oagpvc animated:YES];
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

-(void) deallocMemory {
    NSLog(@"dealloc foursquare");
    
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];}
    [self deallocMapView];
    static NSCache *_cache = nil;
    [_cache removeAllObjects];
    _locationManager.delegate=nil;
    _locationManager=nil;
    self.mapView=nil;
    self.mapView.delegate=nil;
    self.storeNameArraySort=nil;
    self.storeLocationArraySort=nil;
    self.storeCategoryArraySort=nil;
    self.storeIconArraySort=nil;
    self.storeDistanceArraySort=nil;
    self.storeSearchNameArray=nil;
    self.storeSearchLocationArray=nil;
    self.storeSearchTableView.delegate=nil;
    self.storeSearchTableView.dataSource=nil;
    self.storeSearchTableView=nil;
    self.venuesTableView.delegate=nil;
    self.venuesTableView.dataSource=nil;
    self.venuesTableView=nil;
    [self.view removeFromSuperview];
    self.view=nil;
}

-(void) initMapView {
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, self.scrollView.bounds.size.height)];
    self.mapView.center = CGPointMake(160, barTableGap / 2);
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
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

-(void) loadFoursquareaAfterDelay {
    didUpdateTheMap = NO;
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        if (!didUpdateTheMap) {
            loadsuc = [self loadStoresFromFoursquare];
            didUpdateTheMap = YES;
        }
        // Update UI after computation.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI on the main thread.
            [self mainMethod];
            if (!loadsuc) {
                [self connectionProblem];
            }
        });
    });
    [self initialize];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initMapView];
    if (currentVC) {
        [self performSelector:@selector(loadFoursquareaAfterDelay) withObject:nil afterDelay:0];
    }
    currentVC = 1;
    [self.venuesTableView deselectRowAtIndexPath:self.venuesTableView.indexPathForSelectedRow animated:YES];
    [self.storeSearchTableView deselectRowAtIndexPath:self.storeSearchTableView.indexPathForSelectedRow animated:YES];
    [self.SearchBar setShowsScopeBar:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    
}

-(void)viewDidDisappear:(BOOL)animated {
    currentVC=0;
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
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:a delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
        NSString *a=[NSString stringWithFormat:@"%s",mach_error_string(kerr)];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:a delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    }
}
@end
