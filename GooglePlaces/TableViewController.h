//
//  TableViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/23/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


#define kGOOGLE_API_KEY @"AIzaSyCcDzlxbL52wI4wT_2y3iKqhrdCCo9WuUY"


@interface TableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate, CLLocationManagerDelegate,UISearchBarDelegate>
{
    CLLocationManager *locationManager;
    NSString *imageName;
    BOOL firstLaunch;
    CLLocationCoordinate2D currentCentre;
    int currenDist;
    BOOL filtered;
    int counter;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (weak, nonatomic) IBOutlet UITableView *tableviewgoogle;
@property (weak, nonatomic) IBOutlet UITableView *StoreSearchTableview;

@property (retain, nonatomic) NSMutableArray *array;
@property (retain, nonatomic) NSMutableArray *arraySort;

@property (retain, nonatomic) NSMutableArray *arrayforlocation;
@property (retain, nonatomic) NSMutableArray *arrayforlocationSort;

@property (retain, nonatomic) NSMutableArray *arrayforicons;
@property (retain, nonatomic) NSMutableArray *iconsarray;
@property (retain, nonatomic) NSMutableArray *distancearray;
@property (retain, nonatomic) NSMutableArray *distancearraySort;
@property (retain, nonatomic) NSMutableArray *distancearrayMin;

@property (retain, nonatomic) NSMutableArray *iconsarrayfiltered;
@property (retain, nonatomic) NSMutableArray *iconsarrayfilteredSort;
@property (retain, nonatomic) NSMutableArray *StoreSearchArray;
@property (retain, nonatomic) NSMutableArray *StoreSearcLocationhArray;

//@property (retain, nonatomic) NSMutableArray *places;
//@property (retain, nonatomic) NSMutableArray *temparray;

@property (weak, nonatomic) IBOutlet UIImageView *Shadow1;
@property (weak, nonatomic) IBOutlet UIImageView *Shadow2;
@property (weak, nonatomic) IBOutlet UIButton *ButtonCoverforMap;
@property (weak, nonatomic) IBOutlet UIView *CoveView;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingImage;
@property (weak, nonatomic) IBOutlet UIButton *RemovemapButton;

- (IBAction)ReturnButtonAction:(id)sender;
- (IBAction)ResizemapButtonAction:(id)sender;
- (IBAction)RemovemapButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *ReturnButton;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButtonFull;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;

@property (weak, nonatomic) IBOutlet UIButton *DoneButton;
- (IBAction)DoneButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *NavBarImage;
@property (weak, nonatomic) IBOutlet UIImageView *BlackCoverImage;

@end
