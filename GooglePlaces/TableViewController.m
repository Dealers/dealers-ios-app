//
//  TableViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/23/13.
//
//

#import "TableViewController.h"
#import "OptionalaftergoogleplaceViewController.h"
#import "googleCell2.h"
#import "StoreSearchCell.h"
#import "Functions.h"
#import <mach/mach.h>
#import "AppDelegate.h"
#import "CheckConnection.h"

@interface TableViewController ()

@end

@implementation TableViewController

-(void) connectionProblem {
    [_mapView removeFromSuperview];
    UIButton *selectDealButton9=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton9 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton9.frame=CGRectMake(0, 42,([[UIScreen mainScreen] bounds].size.width),([[UIScreen mainScreen] bounds].size.height-110));
    selectDealButton9.tag=110;
    [selectDealButton9 setBackgroundColor:[UIColor whiteColor]];
    selectDealButton9.alpha=0.7;
    [[self view] addSubview:selectDealButton9];
    [[self view] bringSubviewToFront:selectDealButton9];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Check your Internet" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}

-(BOOL) loadStoresFromFoursquare {
    CheckConnection *checkconnection = [[CheckConnection alloc]init];
    if ([checkconnection connected]) {
        if (_locationManager.location.coordinate.latitude>0) {
            Functions *func = [[Functions alloc]init];
            NSString * url= [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&client_id=JK4EFCX00FOCQX5TKMCFDTGX2J03IAAG1NQM2SZN4G5FXG4O&client_secret=5XLGKL4023AKUAQWUFXRGM1JT1GBEXKRY4RIAB4WIO4TH53G&redius=9000&v=20140201",_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude];
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
                    NSString *storeName=[storeArrayFromVenues objectForKey:@"name"];
                    NSString *vicinity=[[storeArrayFromVenues objectForKey:@"location"]objectForKey:@"address"];
                    NSString *lng=[[storeArrayFromVenues objectForKey:@"location"]objectForKey:@"lng"];
                    NSString *lat=[[storeArrayFromVenues objectForKey:@"location"]objectForKey:@"lat"];
                    NSString *distance=[[storeArrayFromVenues objectForKey:@"location"]objectForKey:@"distance"];
                    NSArray *categoryArrayFromVenues=storeArrayFromVenues[@"categories"];
                    UIImageView *tempimage = [[UIImageView alloc]init];
                    
                    if (storeName==nil) storeName=@"";
                    if (vicinity==nil) vicinity=@"";
                    if (distance==nil) distance=@"";
                    
                    if ([categoryArrayFromVenues count]>0) {
                        NSDictionary *categoryIdArray=[storeArrayFromVenues[@"categories"] objectAtIndex:0];
                        categoryId =categoryIdArray[@"id"];
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
    [UIView animateWithDuration:0.2 animations:^{self.loadingImage.alpha=1.0; self.loadingImage.transform =CGAffineTransformMakeScale(1,1);
        self.loadingImage.transform =CGAffineTransformMakeScale(0,0);}];
    [self performSelector:@selector(hideWhiteCoverView) withObject:nil afterDelay:0.5];
    [self.scrollView setContentSize:((CGSizeMake(320, 118+([self.storeNameArraySort count]*70))))];
    self.venuesTableView.frame = CGRectMake(0, 119, 320, ([self.storeNameArraySort count]*70+15));
    [self.venuesTableView setScrollEnabled:NO];
}

-(void) hideWhiteCoverView {
    [UIView animateWithDuration:0.5 animations:^{self.whiteCoverView.alpha=0.0;}];
    [self.loadingImage stopAnimating];
    // [self report_memory];
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
    [UIView animateWithDuration:0.2 animations:^{self.loadingImage.alpha=1.0; self.loadingImage.transform =CGAffineTransformMakeScale(0,0);
        self.loadingImage.transform =CGAffineTransformMakeScale(1,1);}];
}

-(void) initialize {
    [self displayLoadingIcon];
    self.storeSearchTableView.hidden=YES;
    //self.closeStoreSearchTableButton.hidden=YES;
    self.closeStoreSearchTableButton.alpha=0.0;
    self.storeSearchView.hidden=YES;
    self.closeStoreSearchViewButton.hidden=YES;
}

- (void)viewDidLoad
{
    self.collapseMapButton.hidden=YES;
    NSLog(@"foursquare viewdidload");
    currentVC=1;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.venuesTableView) {
        if ([self.storeNameArraySort count] == 0) {
            return 0;
        }
        return [self.storeNameArraySort count];
    } else return [self.storeSearchNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.venuesTableView) {
        googleCell2 *Cell=nil;
        static NSString *CellIdentifier = @"Cell_google";
        Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!Cell) Cell = [[googleCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if ([self.storeNameArraySort count]>0){
            if (indexPath.row<[self.storeNameArraySort count]) {
                Cell.mainlabel.text = [self.storeNameArraySort objectAtIndex:indexPath.row];
            } else Cell.mainlabel.text = @"Unknown";
            if (indexPath.row<[self.storeLocationArraySort count]) {
                Cell.sublabel.text = [self.storeLocationArraySort objectAtIndex:indexPath.row];
            } else Cell.sublabel.text=@"Unknown";
            if (indexPath.row<[self.storeDistanceArraySort count]) {
                Cell.lastlabel.text = [NSString stringWithFormat:@"%@m",[self.storeDistanceArraySort objectAtIndex:indexPath.row]];
            } else Cell.lastlabel.text=@"Unknown";
            if (indexPath.row<[self.storeIconArraySort count]) {
                UIImageView *tempImage=[self.storeIconArraySort objectAtIndex:(indexPath.row)];
                Cell.googlepic.image =tempImage.image;
            } else {
                UIImage *temp = [UIImage imageNamed:@"Other_store.png"];
                Cell.googlepic.image =temp;
            }
            return Cell;
        }
    }
    if (tableView==self.storeSearchTableView) {
        self.storeSearchTableView.hidden=NO;
        static NSString *CellIdentifier = @"StoreSearch";
        StoreSearchCell *Cell=nil;
        Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!Cell) Cell = [[StoreSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if ([self.storeSearchNameArray count]>0){
            Cell.StoreNameLabel.text = [self.storeSearchNameArray objectAtIndex:indexPath.row];
            Cell.StoreLocationLabel.text = [self.storeSearchLocationArray objectAtIndex:indexPath.row];
            return Cell;
        }
    }
    
    NSLog(@"here");
    googleCell2 *Cell=nil;
    return Cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"local";
    
    if ([[segue identifier] isEqualToString:@"googleseg"]) {
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

        [[segue destinationViewController] setStoreName:string];
        [[segue destinationViewController] setSegcategory:string2];
        [[segue destinationViewController] setSeglat:string3];
        [[segue destinationViewController] setSeglong:string4];
        [[segue destinationViewController] setSegstoreAddress:string5];
        
    }
    if ([[segue identifier] isEqualToString:@"StoreSearchSeq"]) {
        NSIndexPath *indexpath = [self.storeSearchTableView indexPathForSelectedRow];
        NSString *string = [self.storeSearchNameArray objectAtIndex:indexpath.row];
        [[segue destinationViewController] setStoreName:string];
        [[segue destinationViewController] setSegcategory:@"No Category"];
    }
}


- (IBAction) returnButtonClicked:(id)sender {
    self.ReturnButtonFull.alpha=1.0;
    self.ReturnButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButton.alpha=1.0;}];
    [self deallocMemory];
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction) enlargeMapButtonClicked:(id)sender {
    self.enlargeMapButton.hidden=YES;
    self.collapseMapButton.hidden=NO;
    [UIView animateWithDuration:0.3 animations:^{self.mapView.frame=CGRectMake(0, 0, 320, 480);}];
    CGRect frame = self.venuesTableView.frame;
    frame.origin.y = frame.origin.y + 600;
    [UIView animateWithDuration:0.3 animations:^{self.venuesTableView.frame = frame;}];
    CGRect frame3 = self.theShadow.frame;
    frame3.origin.y = frame3.origin.y + 600;
    [UIView animateWithDuration:0.3 animations:^{self.theShadow.frame = frame3;}];
}

-(IBAction) collapseMapButtonClicked:(id)sender {
    self.enlargeMapButton.hidden=NO;
    self.collapseMapButton.hidden=YES;
    [UIView animateWithDuration:0.3 animations:^{self.mapView.frame=CGRectMake(0, -90, 320, 284);}];
    CGRect frame = self.venuesTableView.frame;
    frame.origin.y = frame.origin.y - 600;
    [UIView animateWithDuration:0.3 animations:^{self.venuesTableView.frame = frame;}];
    CGRect frame3 = self.theShadow.frame;
    frame3.origin.y = frame3.origin.y - 600;
    [UIView animateWithDuration:0.3 animations:^{self.theShadow.frame = frame3;}];
}

-(void) storeSearchFromFoursquer{
    
    NSString *searchText=_searchTextToBackground;
    self.storeSearchNameArray = nil;
    self.storeSearchLocationArray = nil;
    self.storeSearchNameArray = [[NSMutableArray alloc]init];
    self.storeSearchLocationArray = [[NSMutableArray alloc]init];
    
    //NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&client_id=JK4EFCX00FOCQX5TKMCFDTGX2J03IAAG1NQM2SZN4G5FXG4O&client_secret=5XLGKL4023AKUAQWUFXRGM1JT1GBEXKRY4RIAB4WIO4TH53G&redius=100000&v=20131120&query=%@&intent=global&limit=50",_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude,searchText];
    
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=JK4EFCX00FOCQX5TKMCFDTGX2J03IAAG1NQM2SZN4G5FXG4O&client_secret=5XLGKL4023AKUAQWUFXRGM1JT1GBEXKRY4RIAB4WIO4TH53G&v=20131120&query=%@&intent=global&limit=50",searchText];
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
        for (int i=0; i<[[venues copy] count]; i++)
        {
            NSDictionary *storeArrayFromVenues = [venues objectAtIndex:i];
            NSString *storeName=[storeArrayFromVenues objectForKey:@"name"];
            NSString *vicinity=[[storeArrayFromVenues objectForKey:@"location"]objectForKey:@"address"];
            if (storeName==nil) storeName=@"";
            if (vicinity==nil) continue; //vicinity=@"Unknow";
            
            [self.storeSearchNameArray addObject:storeName];
            [self.storeSearchLocationArray addObject:vicinity];
        }
    }
    // [self performSelectorOnMainThread:@selector(LoadStoresTableView) withObject:nil waitUntilDone:NO];
    
}

-(void) LoadStoresTableView {
    if (SearchTextSize) [self.storeSearchTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length==0) {
        SearchTextSize=0;
        self.closeStoreSearchTableButton.alpha=0.3;
        [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
        
        self.storeSearchNameArray = nil;
        self.storeSearchLocationArray = nil;
        self.storeSearchTableView.hidden=YES;
        self.theShadow.hidden=YES;
        [self.mapView setZoomEnabled:NO];
        [self.scrollView setScrollEnabled:NO];
    } else {
        SearchTextSize=1;
        self.closeStoreSearchTableButton.alpha=0.0;
        self.storeSearchTableView.hidden=NO;
        _searchTextToBackground=searchText;
        
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
        dispatch_async(queue, ^{
            // Do some computation here.
            [self storeSearchFromFoursquer];
            // Update UI after computation.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI on the main thread.
                [self LoadStoresTableView];
            });
        });
        
        //[self performSelectorInBackground:@selector(storeSearchFromFoursquer:) withObject:searchText];
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.closeStoreSearchTableButton.alpha=0.3;
    return 1;
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView==self.scrollView) {
        CGFloat y = scrollView.contentOffset.y;
        [UIView animateWithDuration:0.0 animations:^{self.mapView.center = CGPointMake(160,58+(y/2));}];
        if (y==0) {
            CGRect cropRect = CGRectMake(0, -90, 320, 284);
            [UIView animateWithDuration:0.0 animations:^{self.mapView.frame=cropRect;}];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.venuesTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.ReturnButton.hidden=YES;
    self.ReturnButtonFull.hidden=YES;
    self.closeStoreSearchViewButton.hidden=NO;
    self.venuesTableView.hidden=YES;
    self.storeSearchView.hidden=NO;
    self.storeSearchTableView.frame = CGRectMake(0, 0, 320, 371);
    [self.storeSearchView addSubview:self.storeSearchTableView];
    [self.SearchBar resignFirstResponder];
}

-(void) closeStoreSearchViewButtonClicked: (id)sender {
    self.closeStoreSearchViewButton.hidden=YES;
    self.ReturnButton.hidden=NO;
    self.ReturnButtonFull.hidden=NO;
    self.closeStoreSearchTableButton.alpha=0.0;
    self.storeSearchTableView.hidden=YES;
    self.venuesTableView.hidden=NO;
    self.theShadow.hidden=NO;
    [self.mapView setZoomEnabled:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.SearchBar resignFirstResponder];
    self.storeSearchView.hidden=YES;
    self.storeSearchTableView.frame = CGRectMake(0, 88, 320, 170);
    [self.view addSubview:self.storeSearchTableView];
}

-(void) closeStoreSearchTableButtonClicked:(id)sender {
    self.ReturnButton.hidden=NO;
    self.ReturnButtonFull.hidden=NO;
    self.closeStoreSearchTableButton.alpha=0.0;
    self.storeSearchTableView.hidden=YES;
    self.venuesTableView.hidden=NO;
    self.theShadow.hidden=NO;
    [self.mapView setZoomEnabled:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.SearchBar resignFirstResponder];
    self.storeSearchView.hidden=YES;
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
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, -85, 320, 285)];
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
    didUpdateTheMap=NO;
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        if (!didUpdateTheMap) {
            loadsuc=[self loadStoresFromFoursquare];
            didUpdateTheMap=YES;
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


-(void)viewDidAppear:(BOOL)animated {
    [self initMapView];
    if (currentVC) {
        [self performSelector:@selector(loadFoursquareaAfterDelay) withObject:nil afterDelay:1];
    }
    currentVC=1;
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
        NSLog(@"Memory in use (in bytes): %u", info.resident_size);
        NSString *a=[NSString stringWithFormat:@"%u",info.resident_size/1000000];
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
