//
//  TableViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/23/13.
//
//

#import "TableViewController.h"
#import "googleCell2.h"
#import "ResaftergoogleplaceViewController.h"
@interface TableViewController ()

@end

@implementation TableViewController
@synthesize mapView;
@synthesize array;
@synthesize arrayforlocation;
@synthesize arrayforicons;
@synthesize iconsarray;
@synthesize iconsarrayfiltered;
@synthesize distancearray,Shadow1,Shadow2,ButtonCoverforMap,arrayforlocationSort,arraySort,iconsarrayfilteredSort,distancearraySort,distancearrayMin,CoveView,LoadingImage,ReturnButton,ReturnButtonFull,RemovemapButton,SearchBar,NavBarImage,DoneButton,BlackCoverImage;


-(void) BackgroundMethod {
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&client_id=JK4EFCX00FOCQX5TKMCFDTGX2J03IAAG1NQM2SZN4G5FXG4O&client_secret=5XLGKL4023AKUAQWUFXRGM1JT1GBEXKRY4RIAB4WIO4TH53G&redius=3000&v=20131120",locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    
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

    
    array=[[NSMutableArray alloc] init];
    arrayforlocation=[[NSMutableArray alloc]init];
    arrayforicons=[[NSMutableArray alloc]init];
    distancearray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[venues count]; i++)
    {
        NSDictionary *responseData3 = [venues objectAtIndex:i];
        NSString *name=[responseData3 objectForKey:@"name"];
        NSString *vicinity=[[responseData3 objectForKey:@"location"]objectForKey:@"address"];
        NSString *distance=[[responseData3 objectForKey:@"location"]objectForKey:@"distance"];
        
        NSArray *a=responseData3[@"categories"];
        UIImageView *tempimage = [[UIImageView alloc]init];
        
        if ([a count]>0) {
            NSDictionary *iconarraytemp=[responseData3[@"categories"] objectAtIndex:0];
            NSString *icon=iconarraytemp[@"icon"][@"prefix"];
            NSString *iconwithsuffix=[icon stringByAppendingString:@"bg_32"];
            iconwithsuffix=[iconwithsuffix stringByAppendingString:@".png"];
            iconwithsuffix=[iconwithsuffix stringByReplacingOccurrencesOfString:@"ss1.4sqi.net" withString:@"foursquare.com"];
            tempimage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconwithsuffix]]];
        } else tempimage.image =[UIImage imageNamed:@"store@2x.png"];

        
        if (name==nil) {
            name=@"";
        }
        if (vicinity==nil) {
            vicinity=@"";
        }
        if (distance==nil) {
            distance=@"";
        }
        
        [array addObject:name];
        [arrayforlocation addObject:vicinity];
        [arrayforicons addObject:tempimage];
        [distancearray addObject:distance];
    }
    
    arraySort=[[NSMutableArray alloc]init];
    arrayforlocationSort=[[NSMutableArray alloc]init];
    iconsarrayfilteredSort=[[NSMutableArray alloc]init];
    distancearraySort=[[NSMutableArray alloc]init];
    distancearrayMin=[[NSMutableArray alloc]initWithArray:distancearray];
    
    for (int i=0; i<[array count]; i++){
     
        NSString *objcet = @"22000";
        NSInteger min = [objcet intValue];
        int index=0;
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        
        for (int i=0; i<[array count]; i++) {
            NSString *objcet2 = [distancearrayMin objectAtIndex:i];
            NSInteger intnum = [objcet2 intValue];
            if (intnum < min) {
                min = intnum;
                index=i;
            }
        }
        
        for (int i=0; i<index; i++) {
            [temp addObject:[distancearrayMin objectAtIndex:i]];
        }
        [temp addObject:@"23000"];
        for (int i=index+1; i<[array count]; i++) {
            [temp addObject:[distancearrayMin objectAtIndex:i]];
        }
        
        distancearrayMin=[[NSMutableArray alloc]initWithArray:temp];
        int j = index;
        
        [arraySort addObject:[array objectAtIndex:j]];
        [arrayforlocationSort addObject:[arrayforlocation objectAtIndex:j]];
        [iconsarrayfilteredSort addObject:[arrayforicons objectAtIndex:j]];
        [distancearraySort addObject:[distancearray objectAtIndex:j]];
    }
    }
    
    NSArray *passagru=[[NSArray alloc]initWithObjects:arraySort,iconsarrayfilteredSort,arrayforlocationSort,distancearraySort, nil];
    [self performSelectorOnMainThread:@selector(MainMethod:) withObject:passagru waitUntilDone:NO];

}
    
-(void) MainMethod:(NSArray*) pass {
    
    if ([array count]>0) {
    array = [pass objectAtIndex:0];
    arrayforlocation = [pass objectAtIndex:2];
    arrayforicons = [pass objectAtIndex:1];
    distancearray = [pass objectAtIndex:3];
    [self.tableviewgoogle reloadData];
    }
    
    [UIView animateWithDuration:0.2 animations:^{LoadingImage.alpha=1.0; LoadingImage.transform =CGAffineTransformMakeScale(1,1);
        LoadingImage.transform =CGAffineTransformMakeScale(0,0);}];
    
    [self performSelector:@selector(coverviewhidden) withObject:nil afterDelay:0.5];
    
}

-(void) coverviewhidden {
    [UIView animateWithDuration:0.5 animations:^{CoveView.alpha=0.0;}];
    [LoadingImage stopAnimating];
    
}

-(void) Loadingafterdealy {
    LoadingImage.animationImages = [NSArray arrayWithObjects:
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
    LoadingImage.animationDuration = 0.3;
    [LoadingImage startAnimating];
    [UIView animateWithDuration:0.2 animations:^{LoadingImage.alpha=1.0; LoadingImage.transform =CGAffineTransformMakeScale(0,0);
        LoadingImage.transform =CGAffineTransformMakeScale(1,1);}];
    

}
- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.SearchBar setDelegate:self];
    SearchBar.backgroundImage = [UIImage imageNamed:@"Explore_Search bar"];
    
    [self performSelector:@selector(Loadingafterdealy) withObject:nil afterDelay:0.5];
    self.tableviewgoogle.dataSource = self;
    self.tableviewgoogle.delegate = self;
    RemovemapButton.hidden=YES;
    BlackCoverImage.hidden=YES;
    
  //  [mapView setZoomEnabled:YES];
    
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeStandard;
    mapView.delegate = self;
   // [self.view addSubview:mapView];

    
    iconsarray = [[NSMutableArray alloc]initWithObjects:@"store.png",@"amusement_park.png",@"aquarium.png",@"bowling_alley.png",@"casino.png",@"movie_rental.png",@"movie_theater.png",@"museum.png",@"night_club.png",@"zoo.png",@"spa.png",@"art_gallery.png",@"museum.png",@"car_dealer.png",@"car_rental.png",@"car_repair.png",@"car_wash.png",@"beauty_salon.png",@"hair_care.png",@"health.png",@"physiotherapy.png",@"spa.png",@"book_store.png",@"library.png",@"electronics_store.png",@"clothing_store.png",@"department_store.png",@"shoe_store.png",@"shopping_mall.png",@"bakery.png",@"convenience_store.png",@"food.png",@"grocery_or_supermarket.png",@"liquor_store.png",@"meal_delivery.png",@"meal_takeaway.png",@"pharmacy.png",@"florist.png",@"furniture_store.png",@"hardware_store.png",@"home_goods_store.png",@"locksmith.png",@"painter.png",@"laundry.png",@"jewelry_store.png",@"pet_store.png",@"veterinary_care.png",@"general_contractor.png",@"real_estate_agency.png",@"bars.png",@"cafe.png",@"restaurant.png",@"bicycle_store.png",@"gym.png",@"airport.png",@"lodging.png",@"travel_agency.png",@"bank.png",@"finance.png",@"insurance_agency.png",@"bar.png",nil];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [locationManager startUpdatingLocation];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = locationManager.location.coordinate.latitude;
    location.longitude = locationManager.location.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];

    [self performSelectorInBackground:@selector(BackgroundMethod) withObject:nil];


    [super viewDidLoad];
}



-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self.tableviewgoogle reloadData];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([array count] == 0) {
        return 0;
    }
    return [array count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell_google";
    
    googleCell2 *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!Cell) {
        Cell = [[googleCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (Cell.selected==TRUE) {
    }
    
    if ([array count]>0){
    Cell.mainlabel.text = [array objectAtIndex:indexPath.row];
    Cell.sublabel.text = [arrayforlocation objectAtIndex:indexPath.row];
    NSString *distance=[NSString stringWithFormat:@"%@m",[distancearray objectAtIndex:indexPath.row]];
    Cell.lastlabel.text = distance;
    UIImageView *temp=[arrayforicons objectAtIndex:(indexPath.row)];
    Cell.googlepic.image =temp.image;
    }
    return Cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
    if ([[segue identifier] isEqualToString:@"googleseg"]) {
        NSString *string=nil;
        NSIndexPath *indexpath = nil;
        
        indexpath = [self.tableviewgoogle indexPathForSelectedRow];

        string = [array objectAtIndex:indexpath.row];
        [[segue destinationViewController] setSegstore:string];
    }
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}

- (IBAction)ReturnButtonAction:(id)sender {
    ReturnButtonFull.alpha=1.0;
    ReturnButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButton.alpha=1.0;}];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction) ResizemapButtonAction:(id)sender {
    ButtonCoverforMap.hidden=YES;
    RemovemapButton.hidden=NO;
    CGRect cropRect = CGRectMake(0, 0, 320, 460);
    [UIView animateWithDuration:0.3 animations:^{mapView.frame=cropRect;}];
    CGRect frame = self.tableviewgoogle.frame;
    frame.origin.y = frame.origin.y + 256;
    [UIView animateWithDuration:0.3 animations:^{self.tableviewgoogle.frame = frame;}];
    CGRect frame2 = Shadow1.frame;
    frame2.origin.y = frame2.origin.y + 256;
    [UIView animateWithDuration:0.3 animations:^{Shadow1.frame = frame2;}];
    CGRect frame3 = Shadow2.frame;
    frame3.origin.y = frame3.origin.y + 256;
    [UIView animateWithDuration:0.3 animations:^{Shadow2.frame = frame3;}];

}

-(IBAction) RemovemapButtonAction:(id)sender {
    ButtonCoverforMap.hidden=NO;
    RemovemapButton.hidden=YES;
    CGRect cropRect = CGRectMake(0, 85, 320, 124);
    [UIView animateWithDuration:0.3 animations:^{mapView.frame=cropRect;}];
    CGRect frame = self.tableviewgoogle.frame;
    frame.origin.y = frame.origin.y - 256;
    [UIView animateWithDuration:0.3 animations:^{self.tableviewgoogle.frame = frame;}];
    CGRect frame2 = Shadow1.frame;
    frame2.origin.y = frame2.origin.y - 256;
    [UIView animateWithDuration:0.3 animations:^{Shadow1.frame = frame2;}];
    CGRect frame3 = Shadow2.frame;
    frame3.origin.y = frame3.origin.y - 256;
    [UIView animateWithDuration:0.3 animations:^{Shadow2.frame = frame3;}];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    BlackCoverImage.hidden=NO;
    [UIView animateWithDuration:0.3 animations:^{DoneButton.center = CGPointMake(285, 225);}];
    [UIView animateWithDuration:0.3 animations:^{NavBarImage.center = CGPointMake(160, 225);}];
}

-(void) DoneButtonAction:(id)sender {
    BlackCoverImage.hidden=YES;
    [UIView animateWithDuration:0.3 animations:^{DoneButton.center = CGPointMake(285, 600);}];
    [UIView animateWithDuration:0.3 animations:^{NavBarImage.center = CGPointMake(160, 600);}];
    [SearchBar resignFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
